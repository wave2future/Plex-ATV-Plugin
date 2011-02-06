/**
 * This header is generated by class-dump-z 0.2a.
 * class-dump-z is Copyright (C) 2009 by KennyTM~, licensed under GPLv3.
 *
 * Source: /System/Library/PrivateFrameworks/BackRow.framework/BackRow
 */

#import "BackRow-Structs.h"
#import "BRControl.h"
#import "BRTextField.h"

@class NSMutableString, NSTimer, BRMarqueeTextControl, NSDictionary;

@interface BRTextFieldControl : BRControl <BRTextField> {
@private
	id _delegate;	// 40 = 0x28
	id _characterDelegate;	// 44 = 0x2c
	BRMarqueeTextControl *_displayString;	// 48 = 0x30
	NSMutableString *_clearString;	// 52 = 0x34
	NSDictionary *_savedAttributes;	// 56 = 0x38
	BOOL _useSecureText;	// 60 = 0x3c
	BOOL _processingDeleteChar;	// 61 = 0x3d
	BOOL _showCursor;	// 62 = 0x3e
	int _textLengthLimit;	// 64 = 0x40
	NSTimer *_textObscureTimer;	// 68 = 0x44
}
@property(assign) id characterDelegate;	// G=0x32e2d4f9; S=0x32e2d509; converted property
@property(assign) id delegate;	// G=0x32e2d4d9; S=0x32e2d4e9; converted property
@property(assign) BOOL showCursor;	// G=0x32e2d519; S=0x32e2d9cd; converted property
@property(retain) id textAttributes;	// G=0x32e2d559; S=0x32e2d921; converted property
@property(assign) int textLengthLimit;	// G=0x32e2d539; S=0x32e2d549; converted property
@property(assign) BOOL useSecureText;	// G=0x32e2d529; S=0x32e2d999; converted property
- (id)init;	// 0x32e2da7d
- (id)_secureTextFromClearText;	// 0x32e2d6a9
- (void)_secureTextObscureTimerFired:(id)fired;	// 0x32e2d595
- (void)_startSecureTextObscureTimer;	// 0x32e2d615
- (void)_stopSecureTextObscureTimer;	// 0x32e2d5e9
- (id)accessibilityLabel;	// 0x32e2d825
- (BOOL)brEventAction:(id)action;	// 0x32e2d569
- (BOOL)brKeyEvent:(id)event;	// 0x32e2dc75
// converted property getter: - (id)characterDelegate;	// 0x32e2d4f9
- (void)dealloc;	// 0x32e2da01
// converted property getter: - (id)delegate;	// 0x32e2d4d9
- (float)maxScrollPosition;	// 0x32e2d865
- (BOOL)needsScrollingInBounds:(CGRect)bounds;	// 0x32e2d885
// converted property setter: - (void)setCharacterDelegate:(id)delegate;	// 0x32e2d509
- (void)setClearString:(id)string;	// 0x32e2d8d1
// converted property setter: - (void)setDelegate:(id)delegate;	// 0x32e2d4e9
- (void)setDisplayString:(id)string;	// 0x32e2dba1
- (void)setScrollPosition:(float)position;	// 0x32e2d845
// converted property setter: - (void)setShowCursor:(BOOL)cursor;	// 0x32e2d9cd
- (void)setString:(id)string;	// 0x32e2d7a1
// converted property setter: - (void)setTextAttributes:(id)attributes;	// 0x32e2d921
// converted property setter: - (void)setTextLengthLimit:(int)limit;	// 0x32e2d549
// converted property setter: - (void)setUseSecureText:(BOOL)text;	// 0x32e2d999
// converted property getter: - (BOOL)showCursor;	// 0x32e2d519
- (CGSize)sizeThatFits:(CGSize)fits;	// 0x32e2dc39
- (id)stringValue;	// 0x32e2d7f5
// converted property getter: - (id)textAttributes;	// 0x32e2d559
// converted property getter: - (int)textLengthLimit;	// 0x32e2d539
// converted property getter: - (BOOL)useSecureText;	// 0x32e2d529
@end
