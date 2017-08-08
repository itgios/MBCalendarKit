//
//  CKCalendarCalendarCell.h
//   MBCalendarKit
//
//  Created by Moshe Berman on 4/10/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

@import UIKit;

#import "CKCalendarMonthCellStates.h"


/**
 The `CKCalendarCell` class manages the display of a single date in the calendar.
 It is responsible for handling its visual state, and its contents. Specifically,
 the cell class configures the number representing a date, and the visibility of 
 the event indicator dot.
 */
@interface CKCalendarCell : UIView

// MARK: - Layout Constraints

/**
 A constraint used to pin the cell vertically
 */
@property (nonatomic, strong) NSLayoutConstraint *topConstraint;

/**
 A constraint used to pin the cell horizontally, starting at the leading edge.
 */
@property (nonatomic, strong) NSLayoutConstraint *leadingConstraint;


// MARK: - Tracking Cell State and Touch Tracking

/**
 The state of the cell.
 */
@property (nonatomic, assign) CKCalendarMonthCellState state;

/**
 An index used to to correspond dates and cells when tracking touches in the calendar view.
 */
@property (nonatomic, assign) NSUInteger index;

// MARK: - Controlling Cell Content

/**
 The day of the month that is shown in the cell.
 */
@property (nonatomic, strong) NSNumber *number;

/**
 A property which determines if the cell shows a dot for events.
 */
@property (nonatomic, assign) BOOL showDot;

// MARK: - Cell Background Colors

/**
 The background color for the cell.
 */
@property (nonatomic, strong) UIColor *normalBackgroundColor UI_APPEARANCE_SELECTOR;

/**
 The cell background color for cells displaying a date in the same month as the selected date, when the cell is selected, or when a finger is tracking it.
 */
@property (nonatomic, strong) UIColor *selectedBackgroundColor UI_APPEARANCE_SELECTOR;

/**
The cell background color for a cells representing dates in months outside the current month, when a finger is tracking on them.
 */
@property (nonatomic, strong) UIColor *inactiveSelectedBackgroundColor UI_APPEARANCE_SELECTOR;

/**
 The background color for the cell representing today.
 */
@property (nonatomic, strong) UIColor *todayBackgroundColor UI_APPEARANCE_SELECTOR;

/**
 The background color for the cell representing today, when the cell is selected.
 */
@property (nonatomic, strong) UIColor *todaySelectedBackgroundColor UI_APPEARANCE_SELECTOR;

/**
 The label's text color for the cell representing today.
 */
@property (nonatomic, strong) UIColor *todayTextColor UI_APPEARANCE_SELECTOR;

/**
 The label's shadow color for the cell representing today.
 */
@property (nonatomic, strong) UIColor *todayTextShadowColor UI_APPEARANCE_SELECTOR;


// MARK: - Date Label Colors

/**
 The label's text color.
 */
@property (nonatomic, strong) UIColor *textColor UI_APPEARANCE_SELECTOR;

/**
 The label's shadow color.
 */
@property (nonatomic, strong) UIColor *textShadowColor UI_APPEARANCE_SELECTOR;

/**
 The label's text color for selected cells.
 */
@property (nonatomic, strong) UIColor *textSelectedColor UI_APPEARANCE_SELECTOR;

/**
 The label's shadow color for selected cells.
 */
@property (nonatomic, strong) UIColor *textSelectedShadowColor UI_APPEARANCE_SELECTOR;


// MARK: - Event Dot Color

/**
 The color for event indicator dots in the cells.
 */
@property (nonatomic, strong) UIColor *dotColor UI_APPEARANCE_SELECTOR;


/**
 The color for event indicator dots in the cell when it is selected.
 */
@property (nonatomic, strong) UIColor *selectedDotColor UI_APPEARANCE_SELECTOR;

// MARK: - Cell Border Colors


/**
 The border color for the cell.
 */
@property (nonatomic, strong) UIColor *cellBorderColor UI_APPEARANCE_SELECTOR;


/**
 The border color for the cell in its deselected state.
 */
@property (nonatomic, strong) UIColor *selectedCellBorderColor UI_APPEARANCE_SELECTOR;

// MARK: - Cell Recycling Behavior

/**
 Called before the cell is dequeued by the calendar view.
 Use this to reset colors and opacities to default values.
 */
-(void)prepareForReuse;


// MARK: - Setting Cell Selection State

/**
 Marks the cell as selected and update on the appearance of the cell.
 */
- (void)setSelected;

/**
 Mark the cell as deselected and update on the appearance of the cell.
 */
- (void)setDeselected;

/**
 Mark the cell as out of range, when the calendar has a minimumDate or maximumDate set.
 */
- (void)setOutOfRange;

@end
