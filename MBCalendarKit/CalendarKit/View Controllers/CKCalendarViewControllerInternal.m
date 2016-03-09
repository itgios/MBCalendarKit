//
//  CKViewController.m
//   MBCalendarKit
//
//  Created by Moshe Berman on 4/10/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

#import "CKCalendarViewControllerInternal.h"

#import "CKCalendarView.h"

#import "CKCalendarEvent.h"

#import "NSCalendarCategories.h"

@interface CKCalendarViewControllerInternal ()<CKCalendarViewDataSource, CKCalendarViewDelegate>

@property (nonatomic, strong)CKCalendarView *calendarView;

@property (nonatomic, strong) UISegmentedControl *modePicker;

@property (nonatomic, strong) NSMutableArray *events;

@end

@implementation CKCalendarViewControllerInternal 

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    /*  In iOS 7, UIKit will automatically
     *  put content beneath navigation bars.
     *  It also tries to pad scroll views
     *  and table views to make them
     *  scroll nicely beneath them.
     *
     *  These two checks will fix them.
     *
     *  For iOS 6 compatibility, we need to
     *  check if the view controller class
     *  actually responds to the relevant
     *  methods. (If not, we'll crash
     *  when calling them.)
     */
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
        [self setAutomaticallyAdjustsScrollViewInsets:NO];
    }
    
    [self setTitle:NSLocalizedString(@"Calendar", @"A title for the calendar view.")];
    
    /* Prepare the events array */
    
    [self setEvents:[NSMutableArray new]];
    
    /* Calendar View */

    [self setCalendarView:[CKCalendarView new]];
    [[self calendarView] setDataSource:self];
    [[self calendarView] setDelegate:self];
    [[self view] addSubview:[self calendarView]];

    [[self calendarView] setCalendar:[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] animated:NO];
    [[self calendarView] setDisplayMode:CKCalendarViewModeMonth animated:NO];
    
    /* Mode Picker */
    
    NSArray *items = @[NSLocalizedString(@"Month", @"A title for the month view button."), NSLocalizedString(@"Week",@"A title for the week view button."), NSLocalizedString(@"Day", @"A title for the day view button.")];
    
    [self setModePicker:[[UISegmentedControl alloc] initWithItems:items]];
    [[self modePicker] addTarget:self action:@selector(modeChangedUsingControl:)forControlEvents:UIControlEventValueChanged];
    [[self modePicker] setSelectedSegmentIndex:1];
    [self modeChangedUsingControl:self.modePicker];
    
    /* Toolbar setup */
    
    NSString *todayTitle = NSLocalizedString(@"Today", @"A button which sets the calendar to today.");
    UIBarButtonItem *todayButton = [[UIBarButtonItem alloc] initWithTitle:todayTitle style:UIBarButtonItemStyleBordered target:self action:@selector(todayButtonTapped:)];
    
    [[self navigationItem] setTitleView:[self modePicker]];
    [[self navigationItem] setLeftBarButtonItems: ( self.navigationItem.leftBarButtonItems ? [ self.navigationItem.leftBarButtonItems arrayByAddingObject: todayButton ] : @[ todayButton ] ) ];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

}

#pragma mark - Toolbar Items

- (void)modeChangedUsingControl:(id)sender
{
    [[self calendarView] setDisplayMode:(int)[[self modePicker] selectedSegmentIndex]];

}

- (void)todayButtonTapped:(id)sender
{
    [[self calendarView] setDate:[NSDate date] animated:NO];

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

#pragma mark - Calendar View

- (CKCalendarView *)calendarView
{
    return _calendarView;

}
@end
