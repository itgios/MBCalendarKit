//
//  CKCalendarViewController.m
//  MBCalendarKit
//
//  Created by Moshe Berman on 4/17/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

#import "CKCalendarViewController.h"

#import "CKCalendarViewControllerInternal.h"

@interface CKCalendarViewController ()<CKCalendarViewDataSource, CKCalendarViewDelegate>

@property (nonatomic, strong)CKCalendarViewControllerInternal *calendarViewController;

@end

@implementation CKCalendarViewController

@synthesize delegate;

- (id)init
{
    CKCalendarViewControllerInternal *calendarViewController = [CKCalendarViewControllerInternal new];
    
    self = [super initWithRootViewController:calendarViewController];
    if (self)
    {
        _calendarViewController = calendarViewController;
        [_calendarViewController setDelegate:self];
        [_calendarViewController setDataSource:self];
        
    }
    return self;
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

#pragma mark - CKCalendarViewDataSource

- (NSArray *)calendarView:(CKCalendarView *)CalendarView eventsForDate:(NSDate *)date
{
    if ([[self dataSource] respondsToSelector:@selector(calendarView:eventsForDate:)])
    {
        return [[self dataSource] calendarView:CalendarView eventsForDate:date];
        
    }
    return nil;
    
}

- (NSArray *)calendarView:(CKCalendarView *)calendarView actionsForEvent:(CKCalendarEvent *)event
{
    if ( [ self.dataSource respondsToSelector: @selector( calendarView:actionsForEvent: ) ] )
    {
        return [ self.dataSource calendarView: calendarView actionsForEvent: event ];
        
    }
    else
    {
        return nil;
    }
}

- (NSArray *)barButtonItemsForCalendarView:(CKCalendarView *)calendarView
{
    if ( [ self.dataSource respondsToSelector: @selector( barButtonItemsForCalendarView: ) ] )
    {
        return [ self.dataSource barButtonItemsForCalendarView: calendarView ];
    }
    else
    {
        return nil;
    }
}

#pragma mark - CKCalendarViewDelegate

// Called before/after the selected date changes
- (void)calendarView:(CKCalendarView *)CalendarView willSelectDate:(NSDate *)date
{
    if ([self isEqual:[self delegate]])
    {
        return;
        
    }
    
    if ([[self delegate] respondsToSelector:@selector(calendarView:willSelectDate:)])
    {
        [[self delegate] calendarView:CalendarView willSelectDate:date];
        
    }
    
}

- (void)calendarView:(CKCalendarView *)CalendarView didSelectDate:(NSDate *)date
{
    if ([self isEqual:[self delegate]])
    {
        return;
        
    }
    
    if ([[self delegate] respondsToSelector:@selector(calendarView:didSelectDate:)])
    {
        [[self delegate] calendarView:CalendarView didSelectDate:date];
        
    }
    
}

//  A row is selected in the events table. (Use to push a detail view or whatever.)
- (void)calendarView:(CKCalendarView *)CalendarView didSelectEvent:(CKCalendarEvent *)event
{
    if ([self isEqual:[self delegate]])
    {
        return;
        
    }
    
    if ([[self delegate] respondsToSelector:@selector(calendarView:didSelectEvent:)])
    {
        [[self delegate] calendarView:CalendarView didSelectEvent:event];
        
    }
    
}

- (void)calendarView:(CKCalendarView *)CalendarView didSelectEditingEvents:(NSArray *)events
{
    if ([self isEqual:[self delegate]])
    {
        return;
        
    }
    
    if ([[self delegate] respondsToSelector:@selector(calendarView:didSelectEditingEvents:)])
    {
        [[self delegate] calendarView:CalendarView didSelectEditingEvents:events];
        
    }
}

#pragma mark - Calendar View

- (CKCalendarView *)calendarView
{
    return [[self calendarViewController] calendarView];
    
}

@end
