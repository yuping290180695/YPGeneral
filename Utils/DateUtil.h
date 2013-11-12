//
//  DateUtil.h
//  NBD
//
//  Created by Tai Jason on 12-9-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#define DATE_FORMAT_DEFAULT @"yyyy-MM-dd HH:mm:ss"
#define DATE_FORMAT_DEFAULT_MINUTE @"yyyy-MM-dd HH:mm"
#define DATE_FORMAT_DEFAULT_DAY @"yyyy-MM-dd"
#define DATE_FORMAT_MONTH @"MM-dd HH:mm"

@interface DateUtil : NSObject
{
    NSDateFormatter *_dateFormatter;
}
+ (DateUtil *)shareInstance;
- (NSString *)formatDateWithTimeInterval:(int)timeInterval;
- (NSString *)formatDateWithTimeInterval:(int)timeInterval format:(NSString *)format;
- (NSString *)formatDateWithCustom:(int)timeInterval;
- (NSString *)getDateDiffWithFromTime:(int)dateMills;
- (NSString *)getDateDiffWithFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate;
- (NSString *)formatDate:(NSDate *)date;
- (NSString *)formatDate:(NSDate *)date format:(NSString *)format;
- (NSString *)formatDateString:(NSString *)dateString
                    fromFormat:(NSString *)fromFormat
                      toFormat:(NSString *)toFormat;
- (NSString *)getWeek:(NSDate *)date;

- (NSDateComponents *)getDateComponentsByFromDate:(NSDate *)fromDate
                                           ToDate:(NSDate *)toDate;
- (NSDateComponents *)getDateComponentsByFromDate:(NSDate *)fromDate
                                           ToDate:(NSDate *)toDate
                                        unitFlags:(NSUInteger)unitFlags;

- (NSDate *)dateWithString:(NSString *)dateString format:(NSString *)format;
+ (NSNumber *)numberWithCurrentDate;
@end
