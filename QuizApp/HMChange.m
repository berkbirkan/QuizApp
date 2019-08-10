//
//  HMChange.m
//  H5Game
//
//  Created by LiangXinLiang on 2/6/18.
//  Copyright © 2018 WL. All rights reserved.
//

#import "HMChange.h"

@implementation HMChange
+(BOOL)isNormalByTimeStr:(NSString *)string {
    //目标时间
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    NSDate *date = [formatter dateFromString:string];
    NSTimeInterval pointTime = [date timeIntervalSince1970];
    
    //当前时间
    NSDate *currentDate = [[NSDate alloc] init];
    NSTimeInterval currentTime = [currentDate timeIntervalSince1970];

    
    return currentTime > pointTime;
}
@end
