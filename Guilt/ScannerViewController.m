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
    [self setupUI];
    [GoogleAnalytics trackAnalyticsForScreen:@"ScannerViewController"];
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
    label.text = @"Trying to scan...";
    [self.view addSubview:label];
    
    UIButton* dismissScannerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    dismissScannerButton.backgroundColor = [UIColor whiteColor];
    dismissScannerButton.frame = CGRectMake(self.view.frame.origin.x + 10.0f, self.view.frame.origin.y + 10.0f, 80, 40);
    [dismissScannerButton setTitle:@"Back" forState:UIControlStateNormal];
    dismissScannerButton.layer.cornerRadius = 8;
    dismissScannerButton.layer.borderWidth = 1;
    dismissScannerButton.layer.borderColor = [UIColor blueColor].CGColor;
    dismissScannerButton.clipsToBounds = YES;
    dismissScannerButton.titleLabel.textColor = [UIColor blueColor];
    
    [self.view addSubview:dismissScannerButton];
    [self.view bringSubviewToFront:dismissScannerButton];
    
    [dismissScannerButton setUserInteractionEnabled:YES];
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissScannerButtonPressed:)];
    [dismissScannerButton addGestureRecognizer:recognizer];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    flag = NO;
    
    //make white line corners outlining scan area
    UIBezierPath *leftTopCornerPath = [UIBezierPath bezierPath];
    [leftTopCornerPath moveToPoint:CGPointMake(self.view.frame.origin.x + 50.0f, self.view.center.y -150.0f)];
    [leftTopCornerPath addLineToPoint:CGPointMake(self.view.frame.origin.x + 50.0f, self.view.center.y -160.0f)];
    [leftTopCornerPath addLineToPoint:CGPointMake(self.view.frame.origin.x + 60.0f, self.view.center.y -160.0f)];
    
    UIBezierPath *rightTopCornerPath = [UIBezierPath bezierPath];
    [rightTopCornerPath moveToPoint:CGPointMake(self.view.frame.size.width - 50.0f, self.view.center.y -150.0f)];
    [rightTopCornerPath addLineToPoint:CGPointMake(self.view.frame.size.width - 50.0f, self.view.center.y -160.0f)];
    [rightTopCornerPath addLineToPoint:CGPointMake(self.view.frame.size.width - 60.0f, self.view.center.y -160.0f)];
    
    UIBezierPath *rightbottomCornerPath = [UIBezierPath bezierPath];
    [rightbottomCornerPath moveToPoint:CGPointMake(self.view.frame.size.width - 50.0f, self.view.center.y +150.0f)];
    [rightbottomCornerPath addLineToPoint:CGPointMake(self.view.frame.size.width - 50.0f, self.view.center.y +160.0f)];
    [rightbottomCornerPath addLineToPoint:CGPointMake(self.view.frame.size.width - 60.0f, self.view.center.y +160.0f)];
    
    UIBezierPath *leftBottomCornerPath = [UIBezierPath bezierPath];
    [leftBottomCornerPath moveToPoint:CGPointMake(self.view.frame.origin.x + 50.0f, self.view.center.y +150.0f)];
    [leftBottomCornerPath addLineToPoint:CGPointMake(self.view.frame.origin.x + 50.0f, self.view.center.y +160.0f)];
    [leftBottomCornerPath addLineToPoint:CGPointMake(self.view.frame.origin.x + 60.0f, self.view.center.y +160.0f)];
    
    CAShapeLayer *rightTopCornerLayer = [CAShapeLayer layer];
    rightTopCornerLayer.path = [rightTopCornerPath CGPath];
    rightTopCornerLayer.strokeColor = [[UIColor whiteColor] CGColor];
    rightTopCornerLayer.lineWidth = 1.0;
    [self.view.layer addSublayer:rightTopCornerLayer];
    
    CAShapeLayer *rightBottomCornerLayer = [CAShapeLayer layer];
    rightBottomCornerLayer.path = [rightbottomCornerPath CGPath];
    rightBottomCornerLayer.strokeColor = [[UIColor whiteColor] CGColor];
    rightBottomCornerLayer.lineWidth = 1.0;
    [self.view.layer addSublayer:rightBottomCornerLayer];
    
    CAShapeLayer *leftBottomCornerLayer = [CAShapeLayer layer];
    leftBottomCornerLayer.path = [leftBottomCornerPath CGPath];
    leftBottomCornerLayer.strokeColor = [[UIColor whiteColor] CGColor];
    leftBottomCornerLayer.lineWidth = 1.0;
    [self.view.layer addSublayer:leftBottomCornerLayer];
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
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
                    [self createScannerBar:highlightViewRect];
                }
            }
        }
        
        if (detectionString != nil) {
            label.text =[NSString stringWithFormat:@"UPC = %@", detectionString];
            [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.5]];
            
            [self findProductInfo:detectionString];
            flag=YES; //ensures that only one look per scan takes place
        }
    } else {
        label.text = @"Searching for bargain price...";
    }
}

- (void)createScannerBar:(CGRect)highlightViewRect
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(highlightViewRect.origin.x, highlightViewRect.origin.y)];
    [path addLineToPoint:CGPointMake(self.view.frame.origin.x, highlightViewRect.origin.y)];
    [path addLineToPoint:CGPointMake(self.view.frame.size.width, highlightViewRect.origin.y)];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = [path CGPath];
    shapeLayer.strokeColor = [[UIColor redColor] CGColor];
    shapeLayer.lineWidth = 3.0;
    [self.view.layer addSublayer:shapeLayer];
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
                               } else {
                                   NSLog(@"API error %@", [connectionError localizedDescription]);
                               }
                               [self exit];
                           }];
}

- (void)parseSemanticsProductResponse:(NSDictionary *)productDictionary
{
    NSArray *outerLayer = [[NSArray alloc] initWithArray:[productDictionary objectForKey:@"results"]];
    NSDictionary *innerLayer = [[NSDictionary alloc] initWithDictionary:[outerLayer firstObject]];
    productName = [innerLayer objectForKey:@"name"];
    productPrice = [[innerLayer objectForKey:@"price"] floatValue];
    urlForProduct = [[[innerLayer objectForKey:@"sitedetails"] firstObject] objectForKey:@"url"];
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


- (void)dismissScannerButtonPressed:(UIButton *)sender
{
    [GoogleAnalytics trackAnalyticsForAction:@"touch" withLabel:sender.titleLabel.text onScreen:@"ScannerViewController"];
    [self exit];
}
@end
