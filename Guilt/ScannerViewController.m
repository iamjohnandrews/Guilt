//
//  ScannerViewController.m
//  Guilt
//
//  Created by Agnt86 on 10/29/13.
//  Copyright (c) 2013 John Andrews. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "ScannerViewController.h"
#import "ImagesViewController.h"
#import "GAIDictionaryBuilder.h"

@interface ScannerViewController ()  <AVCaptureMetadataOutputObjectsDelegate>
{
    AVCaptureSession *_session;
    AVCaptureDevice *_device;
    AVCaptureDeviceInput *_input;
    AVCaptureMetadataOutput *_output;
    AVCaptureVideoPreviewLayer *_prevLayer;
    
    UIView *highlightView;
    UILabel *label;
    
    BOOL flag;    
}
@end

@implementation ScannerViewController

@synthesize productName;
@synthesize  productPrice;
@synthesize  urlForProduct;
@synthesize delegate;

- (void)viewDidLoad
{
    [super viewDidLoad];    
    
    _session = [[AVCaptureSession alloc] init];
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error = nil;
    
    _input = [AVCaptureDeviceInput deviceInputWithDevice:_device error:&error];
    if (_input) {
        [_session addInput:_input];
    } else {
        NSLog(@"Error: %@", error);
    }
    
    _output = [[AVCaptureMetadataOutput alloc] init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    [_session addOutput:_output];
    
    _output.metadataObjectTypes = [_output availableMetadataObjectTypes];
    
    _prevLayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    _prevLayer.frame = self.view.bounds;
    _prevLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:_prevLayer];
    
    [_session startRunning];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // returns the same tracker you created in your app delegate
    // defaultTracker originally declared in AppDelegate.m
    id tracker = [[GAI sharedInstance] defaultTracker];
    
    // This screen name value will remain set on the tracker and sent with
    // hits until it is set to a new value or to nil.
    [tracker set:kGAIScreenName value:@"ScannerViewController"];
    
    // manual screen tracking
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
    [self setupUI];
}

- (void)setupUI
{
    highlightView = [[UIView alloc] init];
    highlightView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin;
    highlightView.layer.borderColor = [UIColor greenColor].CGColor;
    highlightView.layer.borderWidth = 3;
    [self.view addSubview:highlightView];
    
    label = [[UILabel alloc] init];
    label.frame = CGRectMake(0, self.view.bounds.size.height - 40, self.view.bounds.size.width, 40);
    label.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    label.backgroundColor = [UIColor colorWithWhite:0.15 alpha:0.65];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.layer.borderColor = [[UIColor whiteColor] CGColor];
    label.layer.borderWidth = 2;
    label.layer.cornerRadius = 10;
    label.text = @"UPC Code Will Appear Here";
    [self.view addSubview:label];
    
    [self.view bringSubviewToFront:highlightView];
    [self.view bringSubviewToFront:label];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    flag = NO;
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    CGRect highlightViewRect = CGRectZero;
    AVMetadataMachineReadableCodeObject *barCodeObject;
    NSString *detectionString = nil;
    NSArray *barCodeTypes = @[AVMetadataObjectTypeUPCECode, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode39Mod43Code,
                              AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeCode128Code,
                              AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeQRCode, AVMetadataObjectTypeAztecCode];
    
    for (AVMetadataObject *metadata in metadataObjects) {
        for (NSString *type in barCodeTypes) {
            if ([metadata.type isEqualToString:type]) {
                barCodeObject = (AVMetadataMachineReadableCodeObject *)[_prevLayer transformedMetadataObjectForMetadataObject:(AVMetadataMachineReadableCodeObject *)metadata];
                highlightViewRect = barCodeObject.bounds;
                detectionString = [(AVMetadataMachineReadableCodeObject *)metadata stringValue];
            }
        }
    }
    if (detectionString != nil) {
        label.text = detectionString;
        
        //find product information
        
        NSLog(@"UPC %@",detectionString);
        
        if (flag==NO) {
            [self findProductInfo:detectionString];
            flag=YES; //ensures that only one look per scan takes place
            label.text = detectionString;
        } else {
            label.text = @"(none)";
        }
    }
    highlightView.frame = highlightViewRect;
}


-(void)findProductInfo: (NSString*)upc
{
    NSString * escapedUrlString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)[NSString stringWithFormat:@"{\"upc\":\"%@\"}",upc], NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8 ));

    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.semantics3.com/test/v1/products?q=%@",escapedUrlString]];

    NSLog(@"URL: %@",url);
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    
    //Create a mutable copy of the immutable request & and add more headers
    NSMutableURLRequest *mutableRequest = [request mutableCopy];
    
    [mutableRequest addValue:SEMANTICS_API_KEY forHTTPHeaderField:@"api_key"];

    request = [mutableRequest copy];
    NSLog(@"Request is %@", request);
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError){
                               
                               if (!connectionError) {
                                   NSLog(@"recieved API response from Semantics");
                               }
                               
                               NSDictionary* dictionary= [NSJSONSerialization JSONObjectWithData:data options:0 error:&connectionError];
                               
                               [self parseSemanticsProductResponse:dictionary];
                               
                               NSLog(@"API Returns Dictionary: %@", dictionary);
                               
                               NSString* code =[dictionary objectForKey:@"code"];
                               
                               NSString *message =[dictionary objectForKey:@"message" ];
                               
                               
                               if ([code isEqualToString:@"APIError" ] || [message isEqualToString:@"No results found; please modify your search."]) {
                                   
                                   NSLog(@"API Error occurred or No Results found");
                                   
                                   [self exit];

                               }
                           }];
}

- (void)parseSemanticsProductResponse:(NSDictionary *)productDictionary
{
    NSArray *outerLayer = [[NSArray alloc] initWithArray:[productDictionary objectForKey:@"results"]];
    NSDictionary *innerLayer = [[NSDictionary alloc] initWithDictionary:[outerLayer firstObject]];
    productName = [innerLayer objectForKey:@"name"];
    productPrice = [[innerLayer objectForKey:@"price"] floatValue];
    urlForProduct = [innerLayer objectForKey:@"url"];
    
    [self exit];
}

-(void)exit
{
    if (!productPrice) {
        [self.delegate productDatabaseReturnedNothing];
    } else {
        [self.delegate productInfoReturned:[NSNumber numberWithFloat:productPrice] urlS:urlForProduct productNameNow:productName];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


@end
