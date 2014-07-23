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
    label = [[UILabel alloc] init];
    label.frame = CGRectMake(0, self.view.bounds.size.height - 40, self.view.bounds.size.width, 40);
    label.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    label.backgroundColor = [UIColor colorWithWhite:0.15 alpha:0.65];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.layer.borderColor = [[UIColor whiteColor] CGColor];
    label.layer.borderWidth = 2;
    label.layer.cornerRadius = 10;
    label.text = @"Scanning...";
    [self.view addSubview:label];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    flag = NO;
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    NSLog(@"flag = %hhd", flag);
    if (flag == NO) {
        
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
        //create scanner line
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(highlightViewRect.origin.x, highlightViewRect.origin.y)];
        [path addLineToPoint:CGPointMake(highlightViewRect.origin.x + highlightViewRect.size.width, highlightViewRect.origin.y)];
        
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.path = [path CGPath];
        shapeLayer.strokeColor = [[UIColor redColor] CGColor];
        shapeLayer.lineWidth = 3.0;
        [self.view.layer addSublayer:shapeLayer];
        
        if (detectionString != nil) {
            label.text =[NSString stringWithFormat:@"UPC = %@", detectionString];
            [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.5]];
            
            [self findProductInfo:detectionString];
            flag=YES; //ensures that only one look per scan takes place
        }
    } else {
        label.text = @"Retrieving Data...";
    }
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
                                   NSDictionary* dictionary= [NSJSONSerialization JSONObjectWithData:data options:0 error:&connectionError];
                                   
                                   [self parseSemanticsProductResponse:dictionary];
                                   
                                   [self exit];
                               } else {
                                   NSLog(@"API error %@", [connectionError localizedDescription]);
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
