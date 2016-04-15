//
//  NSString+RegularExpressions.m
//  joushisu_ios
//
//  Created by zim on 15/8/8.
//  Copyright (c) 2015年 Unite and Grow Inc. All rights reserved.
//

#import "NSString+RegularExpressions.h"

@implementation NSString (RegularExpressions)

+ ( NSArray *)isUrls:(NSString *)str{
    NSString *pattern = regularExpressionUrl ;
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
 NSArray *array =    [ regex matchesInString:str options:0 range:NSMakeRange(0, str.length)];
    return array;
}

@end
