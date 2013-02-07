//
//  ofxSyphonServerDirectory.h
//  SyphonExample
//
//  Created by james KONG on 7/2/13.
//	http://fishkingsin.com
//

#include "ofMain.h"

class ofxSyphonServerDirectory {
public:
	ofxSyphonServerDirectory();
	~ofxSyphonServerDirectory();
	
    void setup ();
	void update();
protected:
	bool bSetup;
	void* serverDirectory;
};