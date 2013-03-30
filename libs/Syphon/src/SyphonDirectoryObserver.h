//
//  SyphonDirectoryObserver.h
//  SyphonExample
//
//  Created by james KONG on 7/2/13.
//
//

#import <Cocoa/Cocoa.h>
#import <libkern/OSAtomic.h>
#import <Syphon/Syphon.h>

@interface SyphonDirectoryObserver : NSObject
{
@private
	BOOL isServerChanged;
}

-(BOOL) hasServerChanges;
@end
