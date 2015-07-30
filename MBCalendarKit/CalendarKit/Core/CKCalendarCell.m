//
//  CKCalendarCalendarCell.m
//   MBCalendarKit
//
//  Created by Moshe Berman on 4/10/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

#import "CKCalendarCell.h"
#import "CKCalendarCellColors.h"

#import "UIView+Border.h"

static UIColor* customSelectedCellColor;
static UIColor* customTodayCellColor;

@interface CKCalendarCell ()
{
    CGSize _size;
}

@property ( nonatomic, strong ) UILabel* label;
@property ( nonatomic, strong ) UIView* dot;
@property ( nonatomic, strong ) UIView* backgroundCircle;

@end

@implementation CKCalendarCell

+(void)setSelectedCellColor:( UIColor* )color_
{
    customSelectedCellColor = color_;
}

+(void)setTodayCellColor:( UIColor* )color_
{
    customTodayCellColor = color_;
}

-(id)init
{
    self = [ super init ];
    
    if ( self )
    {
        // Initialization code
        _state = CKCalendarMonthCellStateNormal;
        
        // Normal Cell Colors
        _normalBackgroundColor = kCalendarColorWhite;
        _selectedBackgroundColor = customSelectedCellColor ? customSelectedCellColor : kCalendarColorBlue;
        _inactiveSelectedBackgroundColor = kCalendarColorDarkGray;
        
        // Today Cell Colors
        _todayTextColor = kCalendarColorWhite;
        _todayBackgroundColor = customTodayCellColor ? customTodayCellColor : kCalendarColorBluishGray;
        _todaySelectedBackgroundColor = customSelectedCellColor ? customSelectedCellColor : kCalendarColorBlue;
        _todayTextShadowColor = [ UIColor clearColor ];
        
        // Text Colors
        _textColor = kCalendarColorDarkTextGradient;
        _textSelectedColor = kCalendarColorWhite;
        _textShadowColor = [ UIColor clearColor ];
        _textSelectedShadowColor = [ UIColor clearColor ];
        
        _dotColor = kCalendarColorDarkTextGradient;
        _selectedDotColor = kCalendarColorWhite;
        _cellBorderColor = [ UIColor clearColor ];
        _selectedCellBorderColor = [ UIColor clearColor ];
        
        // Background circle
        _backgroundCircle = [ UIView new ];
        
        // Label
        _label = [ UILabel new ];
        
        // Dot
        _dot = [ UIView new ];
        _dot.hidden = YES;
        _showDot = NO;
    }
    
    return self;
}

-(id)initWithSize:( CGSize )size_
{
    self = [ self init ];
    
    if (self)
    {
        _size = size_;
    }
    
    return self;
}

#pragma mark - View Hierarchy

-(void)willMoveToSuperview:( UIView* )new_superview_
{
    self.frame = CGRectMake( self.frame.origin.x, self.frame.origin.y, _size.width, _size.height );
    [ self layoutSubviews ];
    [ self applyColors ];
}

#pragma mark - Layout

-(void)layoutSubviews
{
    [ self configureLabel ];
    [ self configureDot ];
    [ self configureBackgroundCircle ];
    
    if ( ![ self.subviews containsObject: self.backgroundCircle ] ) [ self addSubview: self.backgroundCircle ];
    if ( ![ self.subviews containsObject: self.label ] ) [ self addSubview: self.label ];
    if ( ![ self.subviews containsObject: self.dot ] ) [ self addSubview: self.dot ];
}

#pragma mark - Setters

-(void)setState:( CKCalendarMonthCellState )state_
{
    if ( state_ >= CKCalendarMonthCellStateTodaySelected && state_ <= CKCalendarMonthCellStateOutOfRange )
    {
        _state = state_;
        [ self applyColorsForState: _state ];
    }
}

-(void)setNumber:( NSNumber* )number_
{
    _number = number_;
    
    // TODO: Locale support?
    self.label.text = number_.stringValue;
}

-(void)setShowDot:( BOOL )show_dot_
{
    _showDot = show_dot_;
    self.dot.hidden = !_showDot;
}

#pragma mark - Recycling Behavior

-(void)prepareForReuse
{
    // Alpha, by default, is 1.0
    self.label.alpha = 1.f;
    self.state = CKCalendarMonthCellStateNormal;
    
    [ self applyColors ];
}

#pragma mark - Label

-(void)configureLabel
{
    self.label.font = [ UIFont boldSystemFontOfSize: 13.f ];
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.backgroundColor = [ UIColor clearColor ];
    self.label.frame = CGRectMake( 0.f, 0.f, self.frame.size.width, self.frame.size.height );
}

#pragma mark - Dot

- (void)configureDot
{
    CGFloat dot_radius_ = 3.f;
    CGFloat self_height_ = self.frame.size.height;
    CGFloat self_width_ = self.frame.size.width;
    
    self.dot.layer.cornerRadius = dot_radius_ / 2;
    self.dot.frame = CGRectMake( self_width_ / 2 - dot_radius_ / 2, ( self_height_ - ( self_height_ / 5 ) ) - dot_radius_ / 2, dot_radius_, dot_radius_ );
}

#pragma mark - BackgroundCircle

-(void)configureBackgroundCircle
{
    CGFloat height_ = MIN( self.frame.size.width, self.frame.size.height );
    CGFloat radius_ = ( height_ / 2 ) - 4.f;
    
    self.backgroundCircle.layer.cornerRadius = radius_;
    self.backgroundCircle.frame = CGRectMake( ( self.frame.size.width / 2 ) - radius_, ( self.frame.size.height / 2 ) - radius_, radius_ * 2, radius_ * 2 );
}

#pragma mark - UI Coloring

-(void)applyColors
{
    [ self applyColorsForState: self.state ];
    [ self showBorder ];
}

// TODO: Make the cell states bitwise, so we can use masks and clean this up a bit
- (void)applyColorsForState:( CKCalendarMonthCellState )state_
{
    // Default colors and shadows
    self.label.textColor = self.textColor;
    self.label.shadowColor = self.textShadowColor;
    self.label.shadowOffset = CGSizeMake( 0.f, 0.5f );
    
    self.backgroundColor = self.normalBackgroundColor;
    self.backgroundCircle.backgroundColor = self.normalBackgroundColor;
    
    [ self setBorderColor: self.backgroundColor ];
    [ self setBorderWidth: 0.5f ];
    
    // Today cell
    if( state_ == CKCalendarMonthCellStateTodaySelected )
    {
        self.backgroundCircle.backgroundColor = self.todaySelectedBackgroundColor;
        self.label.shadowColor = self.todayTextShadowColor;
        self.label.textColor = self.todayTextColor;
    }
    // Today cell, selected
    else if( state_ == CKCalendarMonthCellStateTodayDeselected )
    {
        self.backgroundCircle.backgroundColor = self.todayBackgroundColor;
        self.label.shadowColor = self.todayTextShadowColor;
        self.label.textColor = self.todayTextColor;
    }
    //  Selected cells in the active month have a special background color
    else if( state_ == CKCalendarMonthCellStateSelected )
    {
        self.backgroundCircle.backgroundColor = self.selectedBackgroundColor;
        self.label.textColor = self.textSelectedColor;
        self.label.shadowColor = self.textSelectedShadowColor;
        self.label.shadowOffset = CGSizeMake( 0.f, -0.5f );
    }
    
    if ( state_ == CKCalendarMonthCellStateInactive )
    {
        self.label.alpha = 0.5f;    //  Label alpha needs to be lowered
        self.label.shadowOffset = CGSizeZero;
    }
    else if ( state_ == CKCalendarMonthCellStateInactiveSelected )
    {
        self.label.alpha = 0.5f;    //  Label alpha needs to be lowered
        self.label.shadowOffset = CGSizeZero;
        self.backgroundCircle.backgroundColor = self.inactiveSelectedBackgroundColor;
    }
    else if( state_ == CKCalendarMonthCellStateOutOfRange )
    {
        self.label.alpha = 0.01f;   //  Label alpha needs to be lowered
        self.label.shadowOffset = CGSizeZero;
    }
    
    // Make the dot follow the label's style
    self.dot.backgroundColor = self.label.textColor;
    self.dot.alpha = self.label.alpha;
}

#pragma mark - Selection State

-(void)setSelected
{
    if ( self.state == CKCalendarMonthCellStateInactive )
    {
        self.state = CKCalendarMonthCellStateInactiveSelected;
    }
    else if ( self.state == CKCalendarMonthCellStateNormal )
    {
        self.state = CKCalendarMonthCellStateSelected;
    }
    else if ( self.state == CKCalendarMonthCellStateTodayDeselected )
    {
        self.state = CKCalendarMonthCellStateTodaySelected;
    }
}

-(void)setDeselected
{
    if ( self.state == CKCalendarMonthCellStateInactiveSelected )
    {
        self.state = CKCalendarMonthCellStateInactive;
    }
    else if ( self.state == CKCalendarMonthCellStateSelected )
    {
        self.state = CKCalendarMonthCellStateNormal;
    }
    else if ( self.state == CKCalendarMonthCellStateTodaySelected )
    {
        self.state = CKCalendarMonthCellStateTodayDeselected;
    }
}

-(void)setOutOfRange
{
    self.state = CKCalendarMonthCellStateOutOfRange;
}

@end
