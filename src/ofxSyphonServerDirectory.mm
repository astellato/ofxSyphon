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
	}
}
void ofxSyphonServerDirectory::update()
{
	
}