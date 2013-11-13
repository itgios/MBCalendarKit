//
//  CKCalendarEvent.m
//   MBCalendarKit
//
//  Created by Moshe Berman on 4/14/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

#import "CKCalendarEvent.h"

@implementation CKCalendarEvent

+(CKCalendarEvent *)eventWithTitle:(NSString *)title andStartDate:(NSDate *)startDate andInfo:(NSDictionary *)info {
    return [self.class eventWithTitle:title andStartDate:startDate andEndDate:nil andInfo:info];
}

+(CKCalendarEvent *)eventWithTitle:(NSString *)title andStartDate:(NSDate *)startDate andEndDate:(NSDate *)endDate andInfo:(NSDictionary *)info
{
    CKCalendarEvent *e = [CKCalendarEvent new];
    [e setTitle:title];
    [e setStartDate:startDate];
    [e setEndDate:endDate];
    [e setInfo:info];
    
    return e;
}

-(NSString *) startTime; {
    if (self.isAllDayEvent) {
        return @"All Day";
    }
    
    NSDateFormatter* f = [NSDateFormatter new];
    [f setDateFormat:@"h:mm a"];
    if (self.endDate == nil || [self.endDate isEqualToDate:self.startDate]) {
        return [f stringFromDate:self.startDate];
    }
    return [NSString stringWithFormat:@"%@\r\n- %@", [f stringFromDate:self.startDate], [f stringFromDate:self.endDate]];
}

@end
