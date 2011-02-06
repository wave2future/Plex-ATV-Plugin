/**
 * This header is generated by class-dump-z 0.2a.
 * class-dump-z is Copyright (C) 2009 by KennyTM~, licensed under GPLv3.
 *
 * Source: /System/Library/PrivateFrameworks/BackRow.framework/BackRow
 */

#import "BackRow-Structs.h"
#import "BRControl.h"

@class BRTextControl;

__attribute__((visibility("hidden")))
@interface BRMetadataLineLayer : BRControl {
@private
	BRTextControl *_labelLayer;	// 40 = 0x28
	BRControl *_valueLayer;	// 44 = 0x2c
	float _maxLabelWidth;	// 48 = 0x30
}
- (id)initWithLabel:(id)label value:(id)value;	// 0x32dc114d
- (id)accessibilityLabel;	// 0x32dc1265
- (void)dealloc;	// 0x32d87599
- (id)label;	// 0x32d87555
- (void)layoutSubcontrols;	// 0x32dc12b5
- (void)setMaxLabelWidth:(float)width;	// 0x32d87575
- (id)value;	// 0x32dc113d
@end
