/*
 *  ofxSyphonServer.h
 *  syphonTest
 *
 *  Created by astellato,vade,bangnoise on 11/6/10.
 *
 *  http://syphon.v002.info/license.php
 */

#include "ofxSyphon.h"
#include "ofxSyphonNSObject.hpp"
#include "ofTexture.h"

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
    
    void draw(float x, float y, float w, float h);
    void draw(float x, float y);
    void drawSubsection(float x, float y, float w, float h, float sx, float sy, float sw, float sh);
    void drawSubsection(float x, float y, float sx, float sy, float sw, float sh);

    float getWidth();
    float getHeight();

    void lockTexture();
    void unlockTexture();
    
    // calls lockTexture() then getTexture().bind()
    OF_DEPRECATED_MSG("Use getTexture().bind()", void bind());
    // calls getTexture().unbind() then unlockTexture()
    OF_DEPRECATED_MSG("Use getTexture().unbind()", void unbind());
    
    /*
     To use the texture with getTexture()
     you must surround it with lockTexture() and
     unlockTexture() functions */
    
    ofTexture& getTexture() {return mTex;}
    
	protected:
	ofxSyphonNSObject mClient;
    ofxSyphonNSObject latestImage;
	ofTexture mTex;
	int width, height;
	bool bSetup;
    std::string appName, serverName;
};
