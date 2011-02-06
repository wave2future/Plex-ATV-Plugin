/**
 * This header is generated by class-dump-z 0.2a.
 * class-dump-z is Copyright (C) 2009 by KennyTM~, licensed under GPLv3.
 *
 * Source: /System/Library/PrivateFrameworks/BackRow.framework/BackRow
 */

#import "BackRow-Structs.h"
#import "BRControl.h"

@class NSArray, BRImageControl, BRTextControl, BRPasscodeSelectionWidget;

__attribute__((visibility("hidden")))
@interface BRPasscodeSelectionLayer : BRControl {
@private
	NSArray *_backgroundLayers;	// 40 = 0x28
	NSArray *_digitLayers;	// 44 = 0x2c
	NSArray *_bulletLayers;	// 48 = 0x30
	BRImageControl *_arrowsLayer;	// 52 = 0x34
	BRPasscodeSelectionWidget *_selectionWidget;	// 56 = 0x38
	BRTextControl *_doneLayer;	// 60 = 0x3c
	BOOL _isUserEditable;	// 64 = 0x40
	unsigned _numDigits;	// 68 = 0x44
	BOOL _hideDigits;	// 72 = 0x48
	int _selection;	// 76 = 0x4c
}
@property(retain) id passcode;	// G=0x32df8099; S=0x32df7ed9; converted property
- (id)initWithNumDigits:(unsigned)numDigits userEditable:(BOOL)editable hideDigits:(BOOL)digits;	// 0x32df7199
- (void)_adjustDigitVisibility:(id)visibility;	// 0x32df6c39
- (CGRect)_arrowsFrameForSelection:(int)selection;	// 0x32df8cf9
- (id)_buildArrowsLayer;	// 0x32df87c1
- (id)_buildBackgroundLayers;	// 0x32df886d
- (id)_buildBulletLayers;	// 0x32df6e05
- (id)_buildDigitLayers;	// 0x32df6f51
- (id)_buildDoneLayer;	// 0x32df8995
- (CGRect)_cellFrameForSelection:(int)selection;	// 0x32df75bd
- (CGRect)_digitFrameForSelection:(int)selection digit:(id)digit;	// 0x32df8c4d
- (void)_hideDigitAtIndex:(int)index;	// 0x32df6c91
- (float)_layoutUIWithHeight:(float)height;	// 0x32df7731
- (CGRect)_selectionWidgetFrameForSelection:(int)selection;	// 0x32df76a1
- (void)_setDigitHighlighted:(BOOL)highlighted atIndex:(int)index;	// 0x32df6d11
- (void)_setDigitValue:(id)value atIndex:(int)index;	// 0x32df8a5d
- (void)_setSelection:(int)selection;	// 0x32df73e1
- (id)accessibilityLabel;	// 0x32df7a95
- (id)accessibilityTraits;	// 0x32df6bcd
- (void)dealloc;	// 0x32df70f5
- (BOOL)decrementSelection;	// 0x32df8281
- (BOOL)digitsHidden;	// 0x32df6bbd
- (BOOL)doneButtonSelected;	// 0x32df7e91
- (void)hideDigits:(int)digits;	// 0x32df7cbd
- (BOOL)incrementSelection;	// 0x32df8449
- (BOOL)moveSelectionLeft;	// 0x32df8621
- (BOOL)moveSelectionRight;	// 0x32df86e9
// converted property getter: - (id)passcode;	// 0x32df8099
- (CGRect)preferredFrameForScreenSize:(CGSize)screenSize;	// 0x32df8b19
- (void)reset;	// 0x32df7075
- (void)setFrame:(CGRect)frame;	// 0x32df7d9d
// converted property setter: - (void)setPasscode:(id)passcode;	// 0x32df7ed9
- (BOOL)setSelection:(int)selection;	// 0x32df81b5
- (void)showDigits;	// 0x32df7bbd
- (float)widthOfDigitsForScreenSize:(CGSize)screenSize;	// 0x32df7a29
@end
