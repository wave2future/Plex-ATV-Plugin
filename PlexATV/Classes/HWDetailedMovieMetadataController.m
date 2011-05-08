//
//  HWDetailedMovieMetadataController.m
//  atvTwo
//
//  Created by ccjensen on 2/7/11.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//  
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//  
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//  

#define LOCAL_DEBUG_ENABLED 1

#import "HWDetailedMovieMetadataController.h"
#import "PlexMediaProvider.h"
#import "PlexNavigationController.h"
#import "PlexAudioSubsController.h"
#import <plex-oss/PlexRequest.h>
#import <plex-oss/PlexMediaObject + VideoDetails.h>
#import "PlexMediaObject+Assets.h"
#import "PlexPreviewAsset.h"

//these are in the AppleTV.framework, but cannot #import <AppleTV/AppleTV.h> due to
//naming conflicts with Backrow.framework. below is a hack!
@interface BRThemeInfo (PlexExtentions)
- (id)ccBadge;
- (id)hdPosterBadge;
- (id)dolbyDigitalBadge;
- (id)storeRentalPlaceholderImage;
@end

typedef enum {
	kPreviewButton = 0,
	kPlayButton,
	kAudioSubsButton,
	kMoreButton
} ActionButton;

@implementation HWDetailedMovieMetadataController
@synthesize assets;
@synthesize selectedMediaObject;

#pragma mark -
#pragma mark Object/Class Lifecycle
- (id)init {
    self = [super init];
    if (self) {
        self.datasource = self;
		self.delegate = self;
        
        //create the popup
		listDropShadowControl = [[SMFListDropShadowControl alloc] init];
		[listDropShadowControl setCDelegate:self];
		[listDropShadowControl setCDatasource:self];
    }
    return self;
}

- (id)initWithPlexMediaObject:(PlexMediaObject *)aMediaObject {
    self = [self init];
    if (self) {
        self.selectedMediaObject = aMediaObject;
        DLog(@"init with media object:%@", self.selectedMediaObject);
    }
    return self;
}

- (id)initWithPreviewAssets:(NSArray*)previewAssets withSelectedIndex:(int)selIndex {
    self = [self init];
	if (self) {
		self.assets = previewAssets;
#if LOCAL_DEBUG_ENABLED
		DLog(@"init with asset count:%d and index:%d", [self.assets count], selIndex);
#endif
		if ([self.assets count] > selIndex) {
			currentSelectedIndex = selIndex;
			self.selectedMediaObject = [self.assets objectAtIndex:currentSelectedIndex];
		} else if ([self.assets count] > 0) {
			currentSelectedIndex = 0;
			self.selectedMediaObject = [self.assets objectAtIndex:currentSelectedIndex];
		} else {
            //fail, container has no items
		}
		
	}
	return self;
}

- (id)initWithPlexContainer:(PlexMediaContainer*)aContainer withSelectedIndex:(int)selIndex {
	NSArray *previewAssets = aContainer.directories;	
	return [self initWithPreviewAssets:previewAssets withSelectedIndex:selIndex];
}

-(void)dealloc {
#if LOCAL_DEBUG_ENABLED
	DLog(@"deallocing HWDetailedMovieMetadataController");
#endif
	self.assets = nil;
    
    [listDropShadowControl release];
	[super dealloc];
}

- (void)changeMetadataViewToShowDataForIndex:(int)newIndex {
    //check that it is a new one, otherwise don't refresh
	if (currentSelectedIndex != newIndex) {
        //set both focused and selected to the new index
		currentSelectedIndex = newIndex;
		self._shelfControl.focusedIndex = newIndex;
		self.selectedMediaObject = [self.assets objectAtIndex:currentSelectedIndex];
        //move the shelf if needed to show the new item
        //[self._shelfControl _scrollIndexToVisible:currentSelectedIndex];
        //refresh metadata, but don't touch the shelf
		[self reload];
	}
}


#pragma mark -
#pragma mark Controller Lifecycle behaviour
- (void)wasPushed {
#if LOCAL_DEBUG_ENABLED
    DLog();
#endif
	[[MachineManager sharedMachineManager] setMachineStateMonitorPriority:NO];
	[super wasPushed];
}

- (void)wasPopped {
    self.datasource = nil;
    self.assets = nil;
	[super wasPopped];
}

- (void)wasExhumed {
	[[MachineManager sharedMachineManager] setMachineStateMonitorPriority:NO];
	[super wasExhumed];
}

- (void)wasBuried {
	[super wasBuried];
}


#pragma mark -
#pragma mark Delegate Methods
#define ArrowSwitchDelay 0.7f

-(BOOL)controllerCanSwitchToPrevious:(SMFMoviePreviewController *)c {
	return YES;
}

-(void)controllerSwitchToPrevious:(SMFMoviePreviewController *)ctrl {
	[ctrl switchPreviousArrowOn];
	[ctrl performSelector:@selector(switchPreviousArrowOff) withObject:nil afterDelay:ArrowSwitchDelay];
	
	[[SMFThemeInfo sharedTheme] playNavigateSound];
	int newIndex;
	if (currentSelectedIndex - 1 < 0) {
        //we have reached the beginning, loop around
		newIndex = [self.assets count] - 1;
	} else {
        //go to previous one
		newIndex = currentSelectedIndex - 1;
	}
#if LOCAL_DEBUG_ENABLED
	DLog(@"switching from item %d to previous one %d", currentSelectedIndex, newIndex);
#endif
	lastFocusedIndex = newIndex;
	[self changeMetadataViewToShowDataForIndex:lastFocusedIndex];
	[self setFocusedControl:[self._buttons objectAtIndex:0]];
}

-(BOOL)controllerCanSwitchToNext:(SMFMoviePreviewController *)c {
	return YES;
}

-(void)controllerSwitchToNext:(SMFMoviePreviewController *)ctrl {
	[ctrl switchNextArrowOn];
	[ctrl performSelector:@selector(switchNextArrowOff) withObject:nil afterDelay:ArrowSwitchDelay];
	
	[[SMFThemeInfo sharedTheme] playNavigateSound];
	int newIndex;
	if (currentSelectedIndex + 1 < [self.assets count]) {
        //go to next one
		newIndex = currentSelectedIndex + 1;
	} else {
        //we have reached the end, loop around
		newIndex = 0;
	}
#if LOCAL_DEBUG_ENABLED
	DLog(@"switching from item %d to next one %d", currentSelectedIndex, newIndex);
#endif
	lastFocusedIndex = newIndex;
	[self changeMetadataViewToShowDataForIndex:lastFocusedIndex];
	[self setFocusedControl:[self._buttons lastObject]];
	
}

-(void)controller:(SMFMoviePreviewController *)c selectedControl:(BRControl *)ctrl {
#if LOCAL_DEBUG_ENABLED
	DLog(@"controller selected %@", ctrl);
#endif
    PlexAudioSubsController *subCtrl;
    
	if ([ctrl isKindOfClass:[BRButtonControl class]]) {
        //one of the buttons have been pushed
		BRButtonControl *buttonControl = (BRButtonControl *)ctrl;
#if LOCAL_DEBUG_ENABLED
		DLog(@"button chosen: %@", buttonControl.identifier);
#endif
        
		int buttonId = [buttonControl.identifier intValue];
		switch (buttonId) {
			case kPlayButton:
				DLog(@"play movie plz kthxbye");
                [[PlexNavigationController sharedPlexNavigationController] initiatePlaybackOfMediaObject:self.selectedMediaObject];
				break;
            case kMoreButton:
                [listDropShadowControl addToController:self]; //show popup for marking movie as watched/unwatched
                break;
            case kAudioSubsButton:
                subCtrl = [[PlexAudioSubsController alloc] initWithMediaObject:self.selectedMediaObject];
                [[[BRApplicationStackManager singleton] stack] pushController:subCtrl];
			default:
				break;
		}
		
        //none of the buttons do anything, make error sound for now
		[[SMFThemeInfo sharedTheme] playErrorSound];
		
	} else if (ctrl == self._shelfControl) {
        //user has selected a media item
		[[SMFThemeInfo sharedTheme] playSelectSound];
		[self changeMetadataViewToShowDataForIndex:self._shelfControl.focusedIndex];
	}
}

-(void)controller:(SMFMoviePreviewController *)c switchedFocusTo:(BRControl *)newControl {
	if ([newControl isKindOfClass:[BRButtonControl class]]) {		
        //one of the buttons is now focused
		DLog(@"switchedFocusTo button focused");
		if (shelfIsSelected)
			shelfIsSelected = NO; //shelf was focused, and now one of the buttons are.
	} else if (newControl == self._shelfControl) {
        //the shelf is now re-focused, load previous focused element
		shelfIsSelected = YES;
		self._shelfControl.focusedIndex = lastFocusedIndex;
	}
}

-(void)controller:(SMFMoviePreviewController *)c shelfLastIndex:(long)index {
    //check if the shelf is currently selected
    //we perform this check because this delegate method is called every time
    //the user focuses a new control in the view
	if (shelfIsSelected)
		lastFocusedIndex = index;
}


#pragma mark -
#pragma mark datasource methods
-(NSString *)title {
#if LOCAL_DEBUG_ENABLED
	DLog(@"title: %@", [self.selectedMediaObject.previewAsset title]);
#endif
	return [self.selectedMediaObject.previewAsset title];
}

-(NSString *)subtitle {
#if LOCAL_DEBUG_ENABLED
	DLog(@"subtitle_end: %@", [self.selectedMediaObject.previewAsset broadcaster]);
#endif
    
    if ([self.selectedMediaObject.previewAsset broadcaster])
        return [self.selectedMediaObject.previewAsset broadcaster];
    else
        return @"";
}

-(NSString *)summary {
#if LOCAL_DEBUG_ENABLED
    //DLog(@"summary: %@", [self.selectedMediaItemPreviewData mediaSummary]);
#endif
	return [self.selectedMediaObject.previewAsset mediaSummary];
}

-(NSArray *)headers {
	return [NSArray arrayWithObjects:@"Details",@"Actors",@"Director",@"Producers",nil];
}

-(NSArray *)columns {
    //the table will hold all the columns
	NSMutableArray *table = [NSMutableArray array];
	
    // ======= details column ======
	NSMutableArray *details = [NSMutableArray array];
	
	BRGenre *genre = [self.selectedMediaObject.previewAsset primaryGenre];
	[details addObject:[genre displayString]];
	
	NSString *released = [NSString stringWithFormat:@"Released %@", [self.selectedMediaObject.previewAsset year]];
	[details addObject:released];
	
	NSString *duration = [NSString stringWithFormat:@"%d minutes", [self.selectedMediaObject.previewAsset duration]/60];
	[details addObject:duration];
	
	NSMutableArray *badges = [NSMutableArray array];
	if ([self.selectedMediaObject.previewAsset isHD])
		[badges addObject:[[BRThemeInfo sharedTheme] hdPosterBadge]];
	if ([self.selectedMediaObject.previewAsset hasDolbyDigitalAudioTrack])
		[badges addObject:[[BRThemeInfo sharedTheme] dolbyDigitalBadge]];
	if ([self.selectedMediaObject.previewAsset hasClosedCaptioning])
		[badges addObject:[[BRThemeInfo sharedTheme] ccBadge]];
	[details addObject:badges];
	
    if ([self.selectedMediaObject.previewAsset starRatingImage]) {
        BRImage *starRating = [self.selectedMediaObject.previewAsset starRatingImage];
        [details addObject:starRating];
	}
    
	[table addObject:details];
	
	
    // ======= actors column ======
    if ([self.selectedMediaObject.previewAsset cast]) {
        NSArray *actors = [self.selectedMediaObject.previewAsset cast];
        [table addObject:actors];
	}
	
    // ======= director column ======
	NSMutableArray *directorAndWriters = [NSMutableArray arrayWithArray:[self.selectedMediaObject.previewAsset directors]];
    if (directorAndWriters == nil)
        [directorAndWriters initWithCapacity:2];
    
	[directorAndWriters addObject:@" "];
	NSAttributedString *subHeadingWriters = [[NSAttributedString alloc]initWithString:@"Writers" attributes:[SMFMoviePreviewController columnHeaderAttributes]];
	[directorAndWriters addObject:subHeadingWriters];
	[subHeadingWriters release];
	[directorAndWriters addObjectsFromArray:[self.selectedMediaObject.previewAsset writers]];
	
	[table addObject:directorAndWriters];
	
	
    // ======= producers column ======
    if ([self.selectedMediaObject.previewAsset producers]) {
        NSArray *producers = [self.selectedMediaObject.previewAsset producers];
        [table addObject:producers];
	}
	
    // ======= done building table ======
#if LOCAL_DEBUG_ENABLED
	DLog(@"table: %@", table);
#endif
	return table;
}

-(NSString *)rating {
#if LOCAL_DEBUG_ENABLED
	DLog(@"rating: %@", [self.selectedMediaObject.previewAsset rating]);
#endif
	return [self.selectedMediaObject.previewAsset rating];
}

-(BRImage *)coverArt {
	BRImage *coverArt = nil;
	if ([self.selectedMediaObject.previewAsset hasCoverArt]) {
		coverArt = [self.selectedMediaObject.previewAsset coverArt];
	}
#if LOCAL_DEBUG_ENABLED
	DLog(@"coverArt: %@", coverArt);
#endif
	return coverArt;
}

- (NSURL *)backgroundImageUrl {
    NSURL* backgroundImageUrl = nil;
    
    NSString *artPath = nil;
    
    if ([self.selectedMediaObject.attributes valueForKey:@"art"]) {
        //movie
        artPath = [self.selectedMediaObject.attributes valueForKey:@"art"];
    } else {
        //tv show
        artPath = [self.selectedMediaObject.mediaContainer.attributes valueForKey:@"art"];
    }
    
    if (artPath) {
		NSString *backgroundImagePath = [NSString stringWithFormat:@"%@%@",self.selectedMediaObject.request.base, artPath];
        backgroundImageUrl = [self.selectedMediaObject.request pathForScaledImage:backgroundImagePath ofSize:self.frame.size];
	}
    DLog(@"=============!!!===background image with url %@", backgroundImageUrl);
	return backgroundImageUrl;
}

-(NSArray *)buttons {
    // built-in images:
    // deleteActionImage, menuActionUnfocusedImage, playActionImage,
    // previewActionImage, queueActionImage, rateActionImage
	NSMutableArray *buttons = [NSMutableArray array];
	
	BRButtonControl* b = [BRButtonControl actionButtonWithImage:[[BRThemeInfo sharedTheme]playActionImage] 
                                                       subtitle:@"Play"
                                                          badge:nil];
	[b setIdentifier:[NSNumber numberWithInt:kPlayButton]];	
	[buttons addObject:b];
	
    /*
     b = [BRButtonControl actionButtonWithImage:[[BRThemeInfo sharedTheme]previewActionImage] 
     subtitle:@"Preview" 
     badge:nil];
     [b setIdentifier:[NSNumber numberWithInt:kPreviewButton]];
     [buttons addObject:b];
     */
    b = [BRButtonControl actionButtonWithImage:[[BRThemeInfo sharedTheme]queueActionImage] 
                                      subtitle:@"Audio/subs" 
                                         badge:nil];
    [b setIdentifier:[NSNumber numberWithInt:kAudioSubsButton]];
    [buttons addObject:b];
    
    
    b = [BRButtonControl actionButtonWithImage:[[BRThemeInfo sharedTheme]rateActionImage] 
                                      subtitle:@"More" 
                                         badge:nil];
    [b setIdentifier:[NSNumber numberWithInt:kMoreButton]];
    [buttons addObject:b];
    
    
    return buttons;
}

-(BRPhotoDataStoreProvider *)providerForShelf {
	NSSet *_set = [NSSet setWithObject:[BRMediaType photo]];
	NSPredicate *_pred = [NSPredicate predicateWithFormat:@"mediaType == %@",[BRMediaType photo]];
	BRDataStore *store = [[BRDataStore alloc] initWithEntityName:@"Hello" predicate:_pred mediaTypes:_set];
	
	for (PlexMediaObject *pmo in self.assets) {
		[store addObject:pmo.previewAsset];
	}
	
	BRPosterControlFactory *tcControlFactory = [BRPosterControlFactory factory];
	[tcControlFactory setDefaultImage:[[BRThemeInfo sharedTheme] storeRentalPlaceholderImage]];
	
	id provider = [BRPhotoDataStoreProvider providerWithDataStore:store controlFactory:tcControlFactory];
	[store release];
#if LOCAL_DEBUG_ENABLED
	DLog(@"providerForShelf: %@", provider);
#endif
	return provider;
}

#pragma mark -
#pragma mark Popup delegates

#define MarkAsWatchedOption 0
#define MarkAsUnwatchedOption 1

- (float)popupHeightForRow:(long)row { 
	return 0.0f;
}

- (BOOL)popupRowSelectable:(long)row { 
	return YES;
}

- (long)popupItemCount { 
	return 3;
}

- (id)popupItemForRow:(long)row	{ 
    SMFMenuItem *it = [SMFMenuItem menuItem];
    switch (row) {
		case MarkAsWatchedOption: {
			[it setTitle:@"Mark as watched"];
			break;
		}
        case MarkAsUnwatchedOption: {
			[it setTitle:@"Mark as unwatched"];
            break;
        }
		default:
			[it setTitle:@"Go back"];
			break;
	}
    return it;
}

- (long)popupDefaultIndex { 
	return 0;
}

- (void)popup:(id)p itemSelected:(long)row {
	[p removeFromParent];
	switch (row) {
		case MarkAsWatchedOption: {
            DLog(@"marking movie as watched");
            [self.selectedMediaObject markSeen];
			break;
		}
        case MarkAsUnwatchedOption: {
            DLog(@"marking movie as un-watched");
            [self.selectedMediaObject markUnseen];
            break;
        }
		default:
            DLog(@"going back");
			break;
	}
}


@end
