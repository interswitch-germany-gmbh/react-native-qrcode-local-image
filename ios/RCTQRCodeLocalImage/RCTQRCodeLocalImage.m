//
//  RCTQRCodeLocalImage.m
//  RCTQRCodeLocalImage
//
//  Created by fangyunjiang on 15/11/4.
//  Copyright (c) 2015年 remobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <React/RCTLog.h>
#import <React/RCTUtils.h>
#import "RCTQRCodeLocalImage.h"

@implementation RCTQRCodeLocalImage
RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(decode:(NSString *)path callback:(RCTResponseSenderBlock)callback)
{
    UIImage *srcImage;
    if ([path hasPrefix:@"http://"] || [path hasPrefix:@"https://"]) {
        srcImage = [UIImage imageWithData: [NSData dataWithContentsOfURL:[NSURL URLWithString: path]]];
    } else {
        srcImage = [[UIImage alloc] initWithContentsOfFile:path];
    }
    if (nil==srcImage){
        NSLog(@"PROBLEM! IMAGE NOT LOADED\n");
        callback(@[@"IMAGE NOT LOADED!", [NSNull null]]);
        return;
    }
    NSLog(@"OK - IMAGE LOADED\n");
    NSDictionary *detectorOptions = @{@"CIDetectorAccuracy": @"CIDetectorAccuracyHigh"};
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:detectorOptions];
    CIImage *image = [CIImage imageWithCGImage:srcImage.CGImage];
    NSArray *features = [detector featuresInImage:image];
    if (0==features.count) {
        NSLog(@"PROBLEM! Feature size is zero!\n");
        callback(@[@"Feature size is zero!", [NSNull null]]);
        return;
    }
    
    CIQRCodeFeature *feature = [features firstObject];
    
    NSString *result = feature.messageString;
    NSLog(@"result: %@", result);
    
    if (result) {
        callback(@[[NSNull null], result]);
    } else {
        callback(@[@"QR Parse failed!", [NSNull null]]);
        return;
    }
}
@end
