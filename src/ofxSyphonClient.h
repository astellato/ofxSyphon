/*
 *  ofxSyphonServer.h
 *  syphonTest
 *
 *  Created by astellato,vade,bangnoise on 11/6/10.
 *
 *  http://syphon.v002.info/license.php
 */

#include "ofMain.h"
#include "ofxSyphon.h"
#include "ofxSyphonNSObject.hpp"

class ofxSyphonClient {
	public:
	ofxSyphonClient();

    void setup();
    bool isSetup();
    
    void set(ofxSyphonServerDescription _server);
    void set(const std::string &_serverName, const std::string &_appName);
    
    void setApplicationName(const std::string &_appName);
    void setServerName(const std::string &_serverName);
    
    const std::string& getApplicationName();
    const std::string& getServerName();
  
    void bind();
    void unbind();
    
    /*
     To use the texture with getTexture()
     you should surround it with bind() and 
     unbind() functions */
    
    ofTexture& getTexture() {return mTex;}
    
    void draw(float x, float y, float w, float h);
    void draw(float x, float y);
    void drawSubsection(float x, float y, float w, float h, float sx, float sy, float sw, float sh);
    void drawSubsection(float x, float y, float sx, float sy, float sw, float sh);

	
	float getWidth();
	float getHeight();
    
	protected:
	ofxSyphonNSObject mClient;
    ofxSyphonNSObject latestImage;
	ofTexture mTex;
	int width, height;
	bool bSetup;
    std::string appName, serverName;
};
