//
//  ofxSyphonServerDirectory.h
//  SyphonExample
//
//  Created by james KONG on 7/2/13.
//	http://fishkingsin.com
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
class ServerList
{
public:
	ServerList(string _name, string _appName)
	{
		name = _name;
		appName = _appName;
	}
	string name,appName;
};
class ofxSyphonServerDirectory {
public:
	ofxSyphonServerDirectory();
	~ofxSyphonServerDirectory();
	
    void setup ();
	ofxSyphonServerDirectoryEvents events;
	vector<ServerList>serverList;
private:
	void update(ofEventArgs& args);
	
	bool bSetup;
	void* serverDirectory;

};

