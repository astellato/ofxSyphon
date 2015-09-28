/*
 *  ofxSyphonServer.h
 *  syphonTest
 *
 *  Created by astellato,vade,bangnoise on 11/6/10.
 *
 *  http://syphon.v002.info/license.php
 */

#include "ofMain.h"

class ofxSyphonServer {
	public:
	ofxSyphonServer();
	~ofxSyphonServer();
	void setName (string n);
	string getName();
	void publishScreen();
    void publishFBO(ofFbo* inputFbo);
    void publishTexture(ofTexture* inputTexture);
    void publishTexture(GLuint id, GLenum target, GLsizei width, GLsizei height, bool isFlipped);
	protected:
	void *mSyphon;
};
