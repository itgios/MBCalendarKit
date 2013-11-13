//
//  CKCalendarEvent.h
//   MBCalendarKit
//
//  Created by Moshe Berman on 4/14/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CKCalendarEvent : NSObject

@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSDictionary *info;
@property (nonatomic) BOOL isAllDayEvent;


+(CKCalendarEvent *)eventWithTitle:(NSString *)title andStartDate:(NSDate *)startDate andInfo:(NSDictionary *)info;
+(CKCalendarEvent *)eventWithTitle:(NSString *)title andStartDate:(NSDate *)startDate andEndDate:(NSDate *)endDate andInfo:(NSDictionary *)info;

-(NSString *) startTime;

@end
