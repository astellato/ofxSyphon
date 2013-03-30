//
//  SyphonDirectoryObserver.m
//  SyphonExample
//
//  Created by james KONG on 7/2/13.
//
//

#import "SyphonDirectoryObserver.h"
#import <Syphon/Syphon.h>

@interface SyphonDirectoryObserver (Private)

@end

@implementation SyphonDirectoryObserver

- (id)init
{
	self = [super init];
	if (self)
	{
		[[SyphonServerDirectory sharedDirectory] addObserver:self forKeyPath:@"servers" options:0 context:nil];
		[self handleServerChange];
	}
	return self;
}

- (void)finalize
{
	[[SyphonServerDirectory sharedDirectory] removeObserver:self forKeyPath:@"servers"];
	[super finalize];
	
}

- (void)dealloc
{
	[[SyphonServerDirectory sharedDirectory] removeObserver:self forKeyPath:@"servers"];
	[super dealloc];
}

// Here we build our UI in response to changing bindings in our syClient, using KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    //NSLog(@"Changes happened in Syphon Client : %@ change:%@", object, change);
	if([keyPath isEqualToString:@"servers"])
	{
		[self handleServerChange];
	}
}

- (void)handleServerChange
{

	isServerChanged = YES;
	for(NSDictionary* serverDescription in [[SyphonServerDirectory sharedDirectory] servers])
	{
		NSString* name = [serverDescription objectForKey:SyphonServerDescriptionNameKey];
		NSString* appName = [serverDescription objectForKey:SyphonServerDescriptionAppNameKey];
		NSString *uuid = [serverDescription objectForKey:SyphonServerDescriptionUUIDKey];
		NSImage* appImage = [serverDescription objectForKey:SyphonServerDescriptionIconKey];
		
		NSString *title = [NSString stringWithString:appName];
        //NSLog(@"Changes happened in Syphon Client : %@ appName:%@", name, appName);
	}
}

- (BOOL) hasServerChanges
{
	BOOL changed = isServerChanged;
	isServerChanged = NO;
	return changed;
}
@end
