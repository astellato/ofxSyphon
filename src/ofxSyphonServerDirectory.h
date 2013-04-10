//
//  ofxSyphonServerDirectory.h
//  ofxSyphonServerDirectoryExample
//
//  Created by james KONG on 7/2/13.
//	http://fishkingsin.com
//
//  Modified by a.stellato on 30/3/13.
//

#include "ofMain.h"

class ofxSyphonServerDirectory;
class ofxSyphonServerDirectoryEventArgs : public ofEventArgs {
public:
	ofxSyphonServerDirectory* directory;
};

class ofxSyphonServerDirectoryEvents {
public:
	ofEvent<ofxSyphonServerDirectoryEventArgs> directoryUpdated;
};

class ofxSyphonServerList
{
public:
	ofxSyphonServerList(string _serverName, string _appName)
	{
		serverName = _serverName;
		appName = _appName;
	}
	string serverName, appName;
};

// TO DO: Add caching of server list to send out messages if client is no longer valid - AS
// TO POSSIBLY DO: Add syphon client access from directory itself - AS

class ofxSyphonServerDirectory {
public:
	ofxSyphonServerDirectory();
	~ofxSyphonServerDirectory();
	
    void setup();
    int size();

    bool isValidIndex(int _idx);
    bool isValidServer(string _appName, string _serverName);
    
    vector<ofxSyphonServerList>& getServerList();
    void printServerList();
	ofxSyphonServerDirectoryEvents events;
	
private:
	void update(ofEventArgs& args);
	
	bool bSetup;
	void* serverDirectory;
    vector<ofxSyphonServerList> serverList;
};

