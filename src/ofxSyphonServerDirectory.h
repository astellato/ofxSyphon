//
//  ofxSyphonServerDirectory.h
//  ofxSyphonServerDirectoryExample
//
//  Created by astellato on 3/30/13
//
//
//

#include "ofMain.h"
#include <algorithm>

class ofxSyphonServerDirectory;

class ofxSyphonServerDescription
{
public:
    ofxSyphonServerDescription(){
        serverName = appName = "null";
    }
    
	ofxSyphonServerDescription(string _serverName, string _appName)
	{
        serverName = _serverName;
        appName = _appName;
	}
    
    friend bool operator== (const ofxSyphonServerDescription& lhs, const ofxSyphonServerDescription& rhs)
    {
        return (lhs.serverName == rhs.serverName) && (lhs.appName == rhs.appName);
    }
    
	string serverName, appName;
};

class ofxSyphonServerDirectoryEventArgs : public ofEventArgs {
public:
	vector<ofxSyphonServerDescription> servers;
};

class ofxSyphonServerDirectoryEvents {
public:
    ofEvent<ofxSyphonServerDirectoryEventArgs> serverUpdated;
    ofEvent<ofxSyphonServerDirectoryEventArgs> serverAnnounced;
    ofEvent<ofxSyphonServerDirectoryEventArgs> serverRetired;
};

class ofxSyphonServerDirectory {
public:
	ofxSyphonServerDirectory();
	~ofxSyphonServerDirectory();
	
    void setup();
    bool isSetup();
    int size();

    bool isValidIndex(int _idx);
    bool serverExists(string _serverName, string _appName);
    bool serverExists(ofxSyphonServerDescription _server);
    ofxSyphonServerDescription& getDescription(int _idx);
    
    vector<ofxSyphonServerDescription>& getServerList();
	ofxSyphonServerDirectoryEvents events;
    
    //needs to be public because of the nature of CFNotifications.  please do not call this.
    void handleNotification(CFStringRef name, CFDictionaryRef userInfo);
	
private:
	void update(ofEventArgs& args);
    void refresh(bool isAnnounce);
    void serverAnnounced();
    void serverUpdated();
    void serverRetired();
    
    void addObservers();
    void removeObservers();
    
    bool CFStringRefToString(CFStringRef src, std::string &dest);

	bool bSetup;
    vector<ofxSyphonServerDescription> serverList;
};

