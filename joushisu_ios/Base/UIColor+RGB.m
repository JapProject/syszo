//
//  UIColor+RGB.m
//  joushisu_ios
//
//  Created by 常宽 on 15/5/4.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//

#import "UIColor+RGB.h"



@implementation UIColor (RGB)


+ (UIColor *)colorWithString:(NSString *)XXXXXX alpha:(CGFloat)alpha;
{
    NSString *redStr =[XXXXXX substringToIndex:2];
    NSInteger red1 = [self conversion:[redStr substringToIndex:1]];
    NSInteger red2 = [self conversion:[redStr substringFromIndex:1]];
    NSInteger red = (16 * red1) + red2;
    
    NSRange greenC = NSMakeRange(2, 2);
    NSString *greenStr =[XXXXXX substringWithRange:greenC];
    
    NSInteger green1 = [self conversion:[greenStr substringToIndex:1]];
    NSInteger green2 = [self conversion:[greenStr substringFromIndex:1]];
    NSInteger green = (16 * green1) + green2;
    
    
    NSString *blueStr =[XXXXXX substringFromIndex:4];
    NSInteger blue1 = [self conversion:[blueStr substringToIndex:1]];
    NSInteger blue2 = [self conversion:[blueStr substringFromIndex:1]];
    NSInteger blue = (16 * blue1) + blue2;
    
//    NSLog(@"r===%ld, g===%ld, b===%ld, 0x === %d", red, green, blue, 0x1d);
    
    return [UIColor colorWithRed:red/255.f green:green/255.f blue:blue/255.f alpha:alpha];
}

+ (NSInteger)conversion:(NSString *)dd
{
    dd = [dd lowercaseString];
    for (int i = 97; i < 103; i ++) {
        if ([dd isEqualToString:[NSString stringWithFormat:@"%c", i]]) {
            return i - 87;
            break;
        }
    }
    if([dd integerValue] >= 0 && [dd integerValue] < 10) {
        return [dd integerValue];
    }
    return NSNotFound;
}

@end
