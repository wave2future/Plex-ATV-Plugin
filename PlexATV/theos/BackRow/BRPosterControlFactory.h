/**
 * This header is generated by class-dump-z 0.2a.
 * class-dump-z is Copyright (C) 2009 by KennyTM~, licensed under GPLv3.
 *
 * Source: /System/Library/PrivateFrameworks/BackRow.framework/BackRow
 */

#import "BRControlFactory.h"
#import "BRControlHeightFactory.h"
//

@class BRImage;

@interface BRPosterControlFactory : NSObject <BRControlFactory, BRControlHeightFactory> {
@private
	BRImage *_defaultImage;	// 4 = 0x4
}
+ (id)factory;	// 0x32da9391
- (id)init;	// 0x32da917d
- (id)_posterForGridFromAsset:(id)asset currentControl:(id)control requestedBy:(id)by;	// 0x32da92d9
- (id)_posterForShelfFromAsset:(id)asset currentControl:(id)control requestedBy:(id)by;	// 0x32da9289
- (id)_posterFromAsset:(id)asset currentControl:(id)control requestedBy:(id)by;	// 0x32da91b5
- (id)controlForData:(id)data currentControl:(id)control requestedBy:(id)by;	// 0x32da93c1
- (void)dealloc;	// 0x32da9349
- (float)heightForControlForData:(id)data requestedBy:(id)by;	// 0x32da95bd
- (void)setDefaultImage:(id)image;	// 0x32da9311
@end
