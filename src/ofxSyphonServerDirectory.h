//
//  ofxSyphonServerDirectory.h
//  ofxSyphonServerDirectoryExample
//
//  Created by astellato on 3/30/13
//
//
//

#include <algorithm>
#include <string>
#include <vector>
#include "ofEvents.h"

class ofxSyphonServerDirectory;

class ofxSyphonServerDescription
{
public:
    ofxSyphonServerDescription(){
        serverName = appName = "null";
    }
    
	ofxSyphonServerDescription(const std::string &_serverName, const std::string &_appName)
	{
        serverName = _serverName;
        appName = _appName;
	}
    
    friend bool operator== (const ofxSyphonServerDescription& lhs, const ofxSyphonServerDescription& rhs)
    {
        return (lhs.serverName == rhs.serverName) && (lhs.appName == rhs.appName);
    }
    
	std::string serverName, appName;
};

class ofxSyphonServerDirectoryEventArgs : public ofEventArgs {
public:
	std::vector<ofxSyphonServerDescription> servers;
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
    bool serverExists(const std::string &_serverName, const std::string &_appName);
    bool serverExists(const ofxSyphonServerDescription &_server);
    const ofxSyphonServerDescription& getDescription(int _idx);
    
    const std::vector<ofxSyphonServerDescription>& getServerList();
	ofxSyphonServerDirectoryEvents events;
    
    // copy and assignment are not supported
    ofxSyphonServerDirectory(const ofxSyphonServerDirectory &o) = delete;
    ofxSyphonServerDirectory &operator=(const ofxSyphonServerDirectory &o) = delete;
	
private:
    friend void handleNotification(const void *, void *);
	void update(ofEventArgs& args);
    void refresh(bool isAnnounce);
    void serverAnnounced();
    void serverUpdated();
    void serverRetired();
    
    void addObservers();
    void removeObservers();

	bool bSetup;
	std::vector<ofxSyphonServerDescription> serverList;
};
