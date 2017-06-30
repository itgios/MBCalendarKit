//
//  CKCalendarDataSource.h
//  MBCalendarKit
//
//  Created by Moshe Berman on 4/17/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

#ifndef MBCalendarKit_CKCalendarDataSource_h
#define MBCalendarKit_CKCalendarDataSource_h

@class CKCalendarView;
@class CKCalendarEvent;

@protocol CKCalendarViewDataSource <NSObject>

- (NSArray *)calendarView:(CKCalendarView *)calendarView eventsForDate:(NSDate *)date;

@optional
- (NSArray *)calendarView:(CKCalendarView *)calendarView actionsForEvent:(CKCalendarEvent *)event;

@end



#endif
