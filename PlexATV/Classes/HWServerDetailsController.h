//
//  HWServerDetailsController.h
//  atvTwo
//
//  Created by Serendipity on 02/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <plex-oss/Machine.h>

@interface HWServerDetailsController : SMFMediaMenuController<MachineManagerDelegate> {
	Machine *machine;
	
	//add new server variables
	BOOL hasCompletedAddNewRemoteServerWizardStep1; //if completed proceed to step 2
	BOOL hasCompletedAddNewRemoteServerWizardStep2; //if completed proceed to step 3
	BOOL hasCompletedAddNewRemoteServerWizardStep3; //if completed proceed to step 4
	
	NSString *_serverName;
	NSString *_userName;
	NSString *_password;
	NSString *_hostName;
	int _portNumber;
	NSString *_etherId;
}
@property (copy) NSString *serverName;
@property (copy) NSString *userName;
@property (copy) NSString *password;
@property (copy) NSString *hostName;
@property (assign) int portNumber;
@property (copy) NSString *etherId;

//custom methods
- (void)loadInPersistentMachines;
- (NSDictionary *)persistentRemoteServerWithHostName:(NSString *)aHostName andServerName:(NSString *)aServerName;

- (void)resetDialogFlags;
- (void)resetMachineSettingVariables;

- (void)addNewMachineWithServerName:(NSString *)serverName userName:(NSString *)userName password:(NSString *)password hostName:(NSString *)hostName portNumber:(int)portNumber etherId:(NSString *)etherId;
- (void)modifyMachine:(Machine *)m;

- (void)showEnterHostNameDialogBoxWithInitialText:(NSString *)initalText;
- (void)showEnterServerNameDialogBoxWithInitialText:(NSString *)initalText;
- (void)showEnterUsernameDialogBoxWithInitialText:(NSString *)initalText;
- (void)showEnterPasswordDialogBoxWithInitialText:(NSString *)initalText;
- (void)showDialogBoxWithTitle:(NSString *)title secondaryInfoText:(NSString *)infoText textFieldLabel:(NSString *)textFieldLabel withInitialText:(NSString *)initialText;
- (void)showEditServerViewForRow:(long)row;

//list provider
- (float)heightForRow:(long)row;
- (long)itemCount;
- (id)itemForRow:(long)row;
- (BOOL)rowSelectable:(long)selectable;
- (id)titleForRow:(long)row;
- (void)setNeedsUpdate;

@end
