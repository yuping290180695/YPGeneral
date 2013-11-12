//
//  DateUtil.m
//  NBD
//
//  Created by Tai Jason on 12-9-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DateUtil.h"

@implementation DateUtil

+ (DateUtil *)shareInstance
{
    static DateUtil *dateUtil = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateUtil = [[DateUtil alloc] init];
        [dateUtil initInstance];
    });
    return dateUtil;
}

- (void)initInstance
{
    _dateFormatter = [[NSDateFormatter alloc] init];
}
- (NSString *)formatDateWithTimeInterval:(int)timeInterval
{
    return [self formatDateWithTimeInterval:timeInterval format:DATE_FORMAT_DEFAULT];
}

- (NSString *)formatDateWithTimeInterval:(int)timeInterval format:(NSString *)format
{
    return [self formatDate:[NSDate dateWithTimeIntervalSince1970:timeInterval] format:format];
}

- (NSString *)formatDate:(NSDate *)date
{
    return [self formatDate:date format:DATE_FORMAT_DEFAULT];
}

- (NSString *)formatDate:(NSDate *)date format:(NSString *)format
{
    [_dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [_dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [_dateFormatter setDateFormat:format];
    return [_dateFormatter stringFromDate:date];
}

- (NSString *)formatDateString:(NSString *)dateString
                    fromFormat:(NSString *)fromFormat
                      toFormat:(NSString *)toFormat
{
    NSDate *date = [self dateWithString:dateString format:fromFormat];
    return [self formatDate:date format:toFormat];
}

- (NSString *)formatDateWithCustom:(int)timeInterval
{
    [_dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [_dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    
    int current = [[self dateWithString:[self formatDate:[NSDate date] format:@"yyyy-MM-dd"] format:@"yyyy-MM-dd"] timeIntervalSince1970] + 86400;
    NSLog(@"current-->%@", [self formatDateWithTimeInterval:timeInterval]);
    int diff = current - timeInterval;
    if (diff > 0 && diff <= 86400) {
        return [NSString stringWithFormat:@"今天 %@", [self formatDateWithTimeInterval:timeInterval format:@"H点"]];
    } else if (diff > 86400 && diff <= 172800) {
        return [NSString stringWithFormat:@"昨天 %@", [self formatDateWithTimeInterval:timeInterval format:@"H点"]];
    } else if (diff > 172800 && diff <= 258200) {
        return [NSString stringWithFormat:@"前天 %@", [self formatDateWithTimeInterval:timeInterval format:@"H点"]];
    } else {
        return [self formatDateWithTimeInterval:timeInterval format:@"M / d H点"];
    }
}

- (NSString *)getDateDiffWithFromTime:(int)dateMills
{
    NSDate *fromDate = [NSDate dateWithTimeIntervalSince1970:dateMills];
    NSDate *toDate = [NSDate date];
    return [self getDateDiffWithFromDate:fromDate toDate:toDate];
}

- (NSString *)getDateDiffWithFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate
{
    NSDateComponents *compInfo = [self getDateComponentsByFromDate:fromDate ToDate:toDate];
    int year = [compInfo year];
    int month = [compInfo month];
    int day = [compInfo day];
    int hour = [compInfo hour];
    int minute = [compInfo minute];
    int second = [compInfo second];
    
    if (year > 0 || month > 0 || day > 0) {
        return [[DateUtil shareInstance] formatDate:fromDate];
    } else if (hour > 0) {
        return [NSString stringWithFormat:@"%d%@", hour, @"小时前"];
    } else if (minute> 0) {
        return [NSString stringWithFormat:@"%d%@", minute, @"分钟前"];
    } else if (second > 0) {
        return [NSString stringWithFormat:@"%d%@", second, @"秒前"];
    } else {
        return nil;
    }
    return nil;
}

- (NSDateComponents *)getDateComponentsByFromDate:(NSDate *)fromDate ToDate:(NSDate *)toDate
{
    unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |
    NSDayCalendarUnit | NSHourCalendarUnit |
    NSMinuteCalendarUnit | NSSecondCalendarUnit;
    return [self getDateComponentsByFromDate:fromDate ToDate:toDate unitFlags:unitFlags];
}

- (NSDateComponents *)getDateComponentsByFromDate:(NSDate *)fromDate
                                           ToDate:(NSDate *)toDate
                                        unitFlags:(NSUInteger)unitFlags
{
    NSCalendar *sysCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    return [sysCalendar components:unitFlags
                          fromDate:fromDate
                            toDate:toDate
                           options:0];
}

- (NSString *)getWeek:(NSDate *)date
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *comps = [calendar components:unitFlags fromDate:date];
    
    int week = [comps weekday];
    switch (week) {
        case 1:
            return @"星期天";
        case 2:
            return @"星期一";
        case 3:
            return @"星期二";
        case 4:
            return @"星期三";
        case 5:
            return @"星期四";
        case 6:
            return @"星期五";
        case 7:
            return @"星期六";
        default:
            break;
    }
    return nil;
}

- (NSDate *)dateWithString:(NSString *)dateString format:(NSString *)format
{
    [_dateFormatter setDateFormat:format];//设定时间格式,这里可以设置成自己需要的格式
    NSDate *date = [_dateFormatter dateFromString:dateString];
    return date;
}

+ (NSNumber *)numberWithCurrentDate
{
    return [NSNumber numberWithInt:[[NSDate date] timeIntervalSince1970]];
}
@end
