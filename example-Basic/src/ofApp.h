#ifndef _TEST_APP
#define _TEST_APP


#include "ofMain.h"
#include "ofxSyphon.h"

class ofApp : public ofBaseApp{
	
public:
	
	void setup();
	void update();
	void draw();
	
	void keyPressed(int key);
	
	float 	counter;
	bool	bSmooth;
	
    ofTexture tex;
    
	ofxSyphonServer mainOutputSyphonServer;
	ofxSyphonServer individualTextureSyphonServer;
	
	ofxSyphonClient mClient;
};

#endif

