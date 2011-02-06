/**
 * This header is generated by class-dump-z 0.2a.
 * class-dump-z is Copyright (C) 2009 by KennyTM~, licensed under GPLv3.
 *
 * Source: /System/Library/PrivateFrameworks/BackRow.framework/BackRow
 */

#import "BRInputMethod.h"

@class NSString;

__attribute__((visibility("hidden")))
@interface BRJapaneseInputMethod : BRInputMethod {
@private
	NSString *_mostRecentCandidateBaseCharacter;	// 28 = 0x1c
}
- (void)_createKeyboardsForTextEntryStyle:(int)textEntryStyle;	// 0x32dc9ed1
- (id)candidates;	// 0x32dc9ecd
- (void)dealloc;	// 0x32dca0e5
- (BOOL)inputText:(id)text;	// 0x32dca12d
- (id)isoLanguageCode;	// 0x32dc9ec1
- (id)name;	// 0x32dc9eb5
- (BOOL)usesCandidateDisplayForKeyboard:(id)keyboard;	// 0x32dca081
@end
