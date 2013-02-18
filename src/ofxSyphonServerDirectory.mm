//
//  ofxSyphonServerDirectory.mm
//  SyphonExample
//
//  Created by james KONG on 7/2/13.
//
//

#include "ofxSyphonServerDirectory.h"
#import <Syphon/Syphon.h>
#import "SyphonDirectoryObserver.h"
ofxSyphonServerDirectory::ofxSyphonServerDirectory()
{
	bSetup = false;
}
ofxSyphonServerDirectory::~ofxSyphonServerDirectory()
{
	if(bSetup)
    {
		NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
		
		[(SyphonDirectoryObserver*)serverDirectory release];
		serverDirectory = nil;
		
		[pool drain];
	}
}

void ofxSyphonServerDirectory::setup ()
{
	if(!bSetup)
    {
		NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
		
		serverDirectory = [[SyphonDirectoryObserver alloc] init];
		NSLog(@"%@",serverDirectory);
		ofLogNotice("ofxSyphonServerDirectory") << "setup";
		[pool drain];
		bSetup = true;
		if(bSetup)
		{
			ofAddListener(ofEvents().update, this, &ofxSyphonServerDirectory::update);
		}
	}
}
void ofxSyphonServerDirectory::update(ofEventArgs &args)
{
	NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
	if([(SyphonDirectoryObserver*)serverDirectory hasServerChanges]==YES)
	{
		serverList.clear();
		for(NSDictionary* serverDescription in [[SyphonServerDirectory sharedDirectory] servers])
		{
			NSString* name = [serverDescription objectForKey:SyphonServerDescriptionNameKey];
			NSString* appName = [serverDescription objectForKey:SyphonServerDescriptionAppNameKey];
			NSString *uuid = [serverDescription objectForKey:SyphonServerDescriptionUUIDKey];
			NSImage* appImage = [serverDescription objectForKey:SyphonServerDescriptionIconKey];
			
			NSString *title = [NSString stringWithString:appName];
			
			ofLogNotice("ofxSyphonServerDirectory" )<<"Changes happened in Syphon Client : "<<std::string([name UTF8String])<<" appName:"<< std::string([appName UTF8String]);
			serverList.push_back(ServerList(std::string([name UTF8String]),std::string([appName UTF8String])));
		}
		ofxSyphonServerDirectoryEventArgs args;
		args.directory = this;

		ofNotifyEvent(events.directoryUpdated, args, this);
		
	}
	[pool drain];
}