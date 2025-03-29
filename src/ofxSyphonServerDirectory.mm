//
//  ofxSyphonServerDirectory.mm
//  ofxSyphonServerDirectoryExample
//
//  Created by astellato on 3/30/13
//
//
//

#include "ofxSyphonServerDirectory.h"
#import <Syphon/Syphon.h>

// CFNotificationCallback implementation

void handleNotification(const void *n, void *observer)
{
    // Unfortunately userInfo is null when dealing with CFNotifications from a Darwin notification center.  This is one of the few non-toll-free bridges between CF and NS.  Otherwise this class would be far less complicated.
    auto name = static_cast<CFStringRef>(n);
    auto directory = static_cast<ofxSyphonServerDirectory *>(observer);
    
    if([(__bridge NSString*)name isEqualToString:SyphonServerAnnounceNotification])
    {
        directory->serverAnnounced();
    }
    else if([(__bridge NSString*)name isEqualToString:SyphonServerUpdateNotification])
    {
        directory->serverUpdated();
    }
    else if([(__bridge NSString*)name isEqualToString:SyphonServerRetireNotification])
    {
        directory->serverRetired();
    }
}

static void notificationHandler(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
    handleNotification(name, observer);
}

// ofxSyphonServerDirectory implementation

ofxSyphonServerDirectory::ofxSyphonServerDirectory()
{
	bSetup = false;
}

ofxSyphonServerDirectory::~ofxSyphonServerDirectory()
{
	if(bSetup)
    {
		removeObservers();
	}
}

bool ofxSyphonServerDirectory::isValidIndex(int _idx) const
{
    return (_idx < serverList.size());
}

void ofxSyphonServerDirectory::setup ()
{
	if(!bSetup)
    {
		bSetup = true;
        addObservers();
        refresh(true);
	}
}

bool ofxSyphonServerDirectory::isSetup() const
{
    return bSetup;
}

// Our workaround for the incomplete CFNotification.  There's just no love for Core Foundation anymore.
void ofxSyphonServerDirectory::refresh(bool isAnnounce){
    std::vector<ofxSyphonServerDescription> eventArgs;

    @autoreleasepool {
        for(NSDictionary* serverDescription in [[SyphonServerDirectory sharedDirectory] servers])
        {
            NSString* name = [serverDescription objectForKey:SyphonServerDescriptionNameKey];
            NSString* appName = [serverDescription objectForKey:SyphonServerDescriptionAppNameKey];
            NSString *uuid = [serverDescription objectForKey:SyphonServerDescriptionUUIDKey];
            NSImage* appImage = [serverDescription objectForKey:SyphonServerDescriptionIconKey];
            
            NSString *title = [NSString stringWithString:appName];
            
            if(isAnnounce){
                bool exists = serverExists([name UTF8String], [appName UTF8String]);
                if(!exists){
                    ofxSyphonServerDescription sy = ofxSyphonServerDescription(std::string([name UTF8String]),std::string([appName UTF8String]));
                    serverList.push_back(sy);
                    eventArgs.push_back(sy);
                    //cout<<"Adding server: "<<std::string([name UTF8String])<<" appName: "<< std::string([appName UTF8String])<<"\n";
                }
            } else {
                eventArgs.push_back(ofxSyphonServerDescription(std::string([name UTF8String]),std::string([appName UTF8String])));
            }
        }
    }
    
    if(!isAnnounce)
    {
       std::vector<ofxSyphonServerDescription> foundServers = eventArgs;
        eventArgs.clear();
        for(std::vector<ofxSyphonServerDescription>::iterator it = serverList.begin(); it != serverList.end(); ++it){
            if(std::find(foundServers.begin(), foundServers.end(), ofxSyphonServerDescription(it->serverName, it->appName)) == foundServers.end()){
                eventArgs.push_back(ofxSyphonServerDescription(it->serverName, it->appName));
                //cout<<"Removing server: "<<it->serverName<<" appName: "<<it->appName<<"\n";
            }
        }
        serverList = foundServers;
    }
    else if (isAnnounce && eventArgs.empty())
    {
        // nothing to do
        return;
    }

    ofxSyphonServerDirectoryEventArgs args;
    args.servers = eventArgs;
    if(isAnnounce){
        ofNotifyEvent(events.serverAnnounced, args, this);
    } else {
        ofNotifyEvent(events.serverRetired, args, this);
    }
}

bool ofxSyphonServerDirectory::serverExists(const ofxSyphonServerDescription &_server) const
{
    for(auto& s: serverList){
        if(s == _server)
            return true;
    }
    
    return false;
}

bool ofxSyphonServerDirectory::serverExists(const std::string &_serverName, const std::string &_appName) const
{
    return serverExists(ofxSyphonServerDescription(_serverName, _appName));
}

const ofxSyphonServerDescription& ofxSyphonServerDirectory::getDescription(int _idx) const
{
    return serverList.at(_idx);
}

const std::vector<ofxSyphonServerDescription>& ofxSyphonServerDirectory::getServerList() const
{
    return serverList;
}

int ofxSyphonServerDirectory::size() const
{
    return (int)serverList.size();
}

void ofxSyphonServerDirectory::serverAnnounced(){
    refresh(true);
}

void ofxSyphonServerDirectory::serverUpdated(){
    //
}

void ofxSyphonServerDirectory::serverRetired(){
    refresh(false);
}

void ofxSyphonServerDirectory::addObservers(){
    CFNotificationCenterAddObserver
    (
     CFNotificationCenterGetLocalCenter(),
     this,
     (CFNotificationCallback)&notificationHandler,
     (CFStringRef)SyphonServerAnnounceNotification,
     NULL,
     CFNotificationSuspensionBehaviorDeliverImmediately
     );
    
    CFNotificationCenterAddObserver
    (
     CFNotificationCenterGetLocalCenter(),
     this,
     (CFNotificationCallback)&notificationHandler,
     (CFStringRef)SyphonServerUpdateNotification,
     NULL,
     CFNotificationSuspensionBehaviorDeliverImmediately
     );
    
    CFNotificationCenterAddObserver
    (
     CFNotificationCenterGetLocalCenter(),
     this,
     (CFNotificationCallback)&notificationHandler,
     (CFStringRef)SyphonServerRetireNotification,
     NULL,
     CFNotificationSuspensionBehaviorDeliverImmediately
     );
}

void ofxSyphonServerDirectory::removeObservers(){
    CFNotificationCenterRemoveEveryObserver(CFNotificationCenterGetLocalCenter(), this);
}
