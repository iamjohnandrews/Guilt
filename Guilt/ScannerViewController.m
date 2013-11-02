//
//  ScannerViewController.m
//  Guilt
//
//  Created by Agnt86 on 10/29/13.
//  Copyright (c) 2013 John Andrews. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "ScannerViewController.h"

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
    label.text = @"(none)";
    [self.view addSubview:label];
    
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
            if ([metadata.type isEqualToString:type])
            {
                barCodeObject = (AVMetadataMachineReadableCodeObject *)[_prevLayer transformedMetadataObjectForMetadataObject:(AVMetadataMachineReadableCodeObject *)metadata];
                highlightViewRect = barCodeObject.bounds;
                detectionString = [(AVMetadataMachineReadableCodeObject *)metadata stringValue];
                break;
            }
        }
        
        if (detectionString != nil)
        {
            label.text = detectionString;
            
            //find product information
            
            NSLog(@"UPC %@",detectionString);
            
            if (flag==NO) {
                
                [self findProductInfo:detectionString];
                flag=YES; //ensures that only one look per scan takes place
#warning the above if statement is not working. Should we put timer on scanner fo after 3 seconds it gives up?
            }
            
            break;
        }
        else
            label.text = @"(none)";
    }
    
    highlightView.frame = highlightViewRect;
}


-(void)findProductInfo: (NSString*)upc
{
//    urlForProduct = @"www.test.com";
//    productName = @"ARGO fuck yourself";
//    productPrice = 12.34;
    
    // upc = @"883974958450";
   //upc = @"0049000028904";
   NSLog(@"UPC = %@",upc);
    

    
    NSString * escapedUrlString =(NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                                       NULL,

                                                                                                       (CFStringRef)[NSString stringWithFormat:@"{\"upc\":\"%@\"}",upc],
                                                                                                       NULL,
                                                                                                       (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                                       kCFStringEncodingUTF8 ));
    
    NSLog(@"escapedURLString %@",escapedUrlString);
    
    
	// Do any additional setup after loading the view, typically from a nib.
    //   NSURL * url = [NSURL URLWithString:@"https://alpha-api.app.net/stream/0/posts/stream/global"];
    //    NSURL * url = [NSURL URLWithString:@"https://api.semantics3.com/test/v1/products?q={\"search\":\"Apple iPad*\"}"];
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.semantics3.com/test/v1/products?q=%@",escapedUrlString]];
    
        NSLog(@"URL: %@",url);
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    
    //Create a mutable copy of the immutable request & and add more headers
    NSMutableURLRequest *mutableRequest = [request mutableCopy];
    ////
    [mutableRequest addValue:@"SEM3B4375C1733AA1EB425CD175E9449D509"forHTTPHeaderField:@"api_key"];
    //////
    request = [mutableRequest copy];
    
        NSLog(@"Request is %@", request);
    
    // api_key: SEM3B4375C1733AA1EB425CD175E9449D509" https://api.semantics3.com/test/v1/products --data-urlencode 'q={"search":"Apple iPad*"}
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
         
         
         
         NSDictionary* dictionary= [NSJSONSerialization JSONObjectWithData:data options:0 error:&connectionError];
         
         NSLog(@" Dictionary: %@", dictionary);
         
         NSString* code =[dictionary objectForKey:@"code"];
         
         if ([code isEqualToString:@"APIError" ]) {
             
             NSLog(@"API Error occurred");
             [self.navigationController popToRootViewControllerAnimated:YES];
             //above code sends user to ConversionViewController
             [self.delegate productDatabaseReturnedNothing];
             
             
             
             
         }
         NSArray *tempArray = [dictionary objectForKey:@"results"];
         
         NSLog(@" tempArray: %@", tempArray);
         
         NSDictionary *tempDict1 = [tempArray objectAtIndex:0];
         
         
         
         NSArray *tempArray2 = [tempDict1 objectForKey:@"sitedetails"];
         
         NSLog(@" tempArray2: %@", tempArray2);
         
         NSDictionary* latestOffers = [tempArray2 objectAtIndex:0];
         
         NSLog(@" latestOffers: %@", latestOffers);
         NSLog(@"URL for this is: %@", [latestOffers objectForKey:@"url"]);
         
         urlForProduct = [latestOffers objectForKey:@"url"];
         
         
         NSArray *ltArray = [latestOffers objectForKey:@"latestoffers"];
         for (int i = 0; i < [ltArray count]; i++) {
             
             NSString* price = [ltArray[i] objectForKey:@"price"];
             NSLog(@"Price is item %i is $%@", i,  price);
             
             productPrice = [price floatValue];
             [self.navigationController popToRootViewControllerAnimated:YES];
             //gotta call the calculateconversion method from ConversionVC on product price
         }
         
         
     }];
    
    
    
    
    
}





@end
