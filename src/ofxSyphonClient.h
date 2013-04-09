/*
 *  ofxSyphonServer.h
 *  syphonTest
 *
 *  Created by astellato,vade,bangnoise on 11/6/10.
 *
 *  http://syphon.v002.info/license.php
 */

#include "ofMain.h"

class ofxSyphonClient {
	public:
	ofxSyphonClient();
	~ofxSyphonClient();
	
    void setup();
    
    void setApplicationName(string appName);
    void setServerName(string serverName);
    
    string& getApplicationName();
    string& getServerName();
  
    void bind();
    void unbind();
    
    void draw(float x, float y, float w, float h);
    void draw(float x, float y);
	
	float getWidth();
	float getHeight();
    
    //Confused about this value from the library's SyphonClient
    bool isValid();
    
    bool isSetup();
    
	protected:
	void* mClient;
    void* latestImage;
	ofTexture mTex;
	int width, height;
	bool bSetup;
    string appName, serverName;
};