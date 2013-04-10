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

bool ofxSyphonServerDirectory::isValidIndex(int _idx){
    return (_idx < serverList.size());
}

bool ofxSyphonServerDirectory::isValidServer(string _appName, string _serverName){
    bool b = false;
    for(auto& server : serverList){
        if(server.serverName == _serverName && server.appName == _appName){
            b = true;
            break;
        }
    }
    return b;
}

void ofxSyphonServerDirectory::setup ()
{
	if(!bSetup)
    {
		NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
		
		serverDirectory = [[SyphonDirectoryObserver alloc] init];

        //NSLog(@"%@",serverDirectory);
        ofLogVerbose("ofxSyphonServerDirectory") << " setup";

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
			
            ofLogVerbose("ofxSyphonServerDirectory" )<<"Update in Syphon Client : "<<std::string([name UTF8String])<<" appName: "<< std::string([appName UTF8String]);
            
			serverList.push_back(ofxSyphonServerList(std::string([name UTF8String]),std::string([appName UTF8String])));
		}
		ofxSyphonServerDirectoryEventArgs args;
		args.directory = this;

		ofNotifyEvent(events.directoryUpdated, args, this);
		
	}
	[pool drain];
}

vector<ofxSyphonServerList>& ofxSyphonServerDirectory::getServerList(){
    return serverList;
}

int ofxSyphonServerDirectory::size(){
    return serverList.size();
}

void ofxSyphonServerDirectory::printServerList(){
    int i = 0;
    for( auto& dir : getServerList() ){ //new c++ auto keyword
        ofLogNotice("ofxSyphonServerDirectory:: ")<<" Idx: "<<i<<" Server Name: "<<dir.serverName <<" | App Name: "<<dir.appName;
        i++;
    }
}