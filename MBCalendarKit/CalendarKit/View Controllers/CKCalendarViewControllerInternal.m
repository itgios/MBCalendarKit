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

-(void)viewDidLoad
{
    [ super viewDidLoad ];
    
    self.tableView.allowsSelection = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.extendedLayoutIncludesOpaqueBars = YES;
    
    self.title = NSLocalizedString( @"Calendar", nil );
    self.events = [ NSMutableArray new ];
    
    UIView* top_view_ = [ UIView new ];
    [ self.tableView addSubview: top_view_ ];
    top_view_.translatesAutoresizingMaskIntoConstraints = NO;
    
    [ self.tableView addConstraints: @[
        [ top_view_.heightAnchor constraintEqualToConstant: 42.f ],
        [ top_view_.topAnchor constraintEqualToAnchor: self.tableView.topAnchor ],
        [ top_view_.leadingAnchor constraintEqualToAnchor: self.tableView.safeAreaLayoutGuide.leadingAnchor constant: 5.f ],
        [ top_view_.trailingAnchor constraintEqualToAnchor: self.tableView.safeAreaLayoutGuide.trailingAnchor  constant: -5.f ]
    ] ];
    
    UIView* bottom_view_ = [ UIView new ];
    [ self.tableView addSubview: bottom_view_ ];
    bottom_view_.translatesAutoresizingMaskIntoConstraints = NO;
    
    [ self.tableView addConstraints: @[
        [ bottom_view_.topAnchor constraintEqualToAnchor: top_view_.bottomAnchor ],
        [ bottom_view_.bottomAnchor constraintEqualToAnchor: self.tableView.safeAreaLayoutGuide.bottomAnchor ],
        [ bottom_view_.leadingAnchor constraintEqualToAnchor: self.tableView.safeAreaLayoutGuide.leadingAnchor ],
        [ bottom_view_.trailingAnchor constraintEqualToAnchor: self.tableView.safeAreaLayoutGuide.trailingAnchor ]
    ] ];
    
    self.calendarView = [ CKCalendarView new ];
    self.calendarView.dataSource = self;
    self.calendarView.delegate = self;
    [ bottom_view_ addSubview: self.calendarView ];
    [ self.calendarView setCalendar: [ [ NSCalendar alloc ] initWithCalendarIdentifier: NSCalendarIdentifierGregorian ] animated: NO ];
    [ self.calendarView setDisplayMode: CKCalendarViewModeMonth animated: NO ];
    
    self.modePicker = [ [ UISegmentedControl alloc ] initWithItems: @[ NSLocalizedString(@"Month", nil ),
                                                                       NSLocalizedString( @"Week", nil ),
                                                                       NSLocalizedString( @"Day", nil ) ] ];
    self.modePicker.frame = CGRectMake( 0.f, 10.f, top_view_.frame.size.width, self.modePicker.frame.size.height );
    self.modePicker.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [ self.modePicker addTarget: self action: @selector( modeChangedUsingControl: )
               forControlEvents: UIControlEventValueChanged ];
    [ self.modePicker setSelectedSegmentIndex: 1 ];
    [ self modeChangedUsingControl: self.modePicker ];
    [ top_view_ addSubview: self.modePicker ];
    
    UIBarButtonItem* today_button_ = [ [ UIBarButtonItem alloc ] initWithTitle: NSLocalizedString( @"Today", nil )
                                                                         style: UIBarButtonItemStylePlain
                                                                        target: self
                                                                        action: @selector( todayButtonTapped: ) ];
    
    self.navigationItem.leftBarButtonItems = ( self.navigationItem.leftBarButtonItems ? [ self.navigationItem.leftBarButtonItems arrayByAddingObject: today_button_ ] : @[ today_button_ ] );
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
    return _calendarView;
    
}
@end
