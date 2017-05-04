//
// 2017 Dan Wilcox danomatika.com
// for EDP Creative Coding @ the University of Denver
//
#include "ofApp.h"

//--------------------------------------------------------------
void ofApp::setup(){
	ofSetWindowTitle("ofxSyphonImageExample");
	ofSetWindowShape(800, 600);
	ofSetFrameRate(60);
	ofBackground(0);

	// setup our Syphon server directory & client
	serverDir.setup();
	client.setup();
	serverIndex = -1;

	// register Syphon server callback
	ofAddListener(serverDir.events.serverAnnounced, this, &ofApp::serverAnnounced);
	
	// allocate fbo and image
	fbo.allocate(640, 480);
	image.allocate(640, 480, OF_IMAGE_COLOR_ALPHA); // use OF_PIXELS_RGBA if grabbing to ofPixels
	
	// clear image with all black
	image.setColor(ofColor(0));
	image.update();
}

// called when a Syphon server appears, automatically connects to first server
void ofApp::serverAnnounced(ofxSyphonServerDirectoryEventArgs &arg){
	for(auto& dir : arg.servers){
		ofLog() << "Server Name: "<< dir.serverName <<" | App Name: " << dir.appName;
	}
	serverIndex = 0;
	client.set(serverDir.getDescription(serverIndex));
}

//--------------------------------------------------------------
void ofApp::update(){

}

//--------------------------------------------------------------
void ofApp::draw(){
	
	// render Syphon client texture into the FBO
	ofSetColor(255);
	ofSetRectMode(OF_RECTMODE_CORNER);
	fbo.begin();
	if(serverDir.isValidIndex(serverIndex)){
		client.draw(0, 0);
	}
	fbo.end();
	fbo.draw(0, 0); // draw the FBO so we can see it
	
	// if the server is valid (aka there's probably a valid texture),
	// read the pixels in the FBO into our local ofImage's pixels using OpenGL
	// (assuming your graphics card & driver support GL_FRAMBUFFER_EXT)
	//
	// it would be smarter to only grab this from the GPU when there is a new
	// frame, but there currently isn't a way to check this via the Syphon
	// client object
	//
	// this solution comes from https://forum.openframeworks.cc/t/saveimage-plus-alpha/1145/6
	if(serverDir.isValidIndex(serverIndex) && client.getTexture().isAllocated()){
		ofTextureData &texData = client.getTexture().getTextureData();
		// grab pixel data from the FBO, note pixel data pointer as destination
		glBindFramebufferEXT(GL_FRAMEBUFFER_EXT, fbo.getId());
		glReadPixels(0, 0, texData.width, texData.height, texData.glInternalFormat, GL_UNSIGNED_BYTE, image.getPixels().getData());
		glBindFramebufferEXT(GL_FRAMEBUFFER_EXT, 0);
		// we manually loaded pixel data into the image, so update the image texture here
		image.update();
	}
	
	// draw a rectangle using the color of the center pixel
	float x = fbo.getWidth()/2;
	float y = fbo.getHeight()/2;
	ofSetColor(255);
	ofSetRectMode(OF_RECTMODE_CENTER);
	ofDrawRectangle(x, y, 40, 40);
	ofSetColor(image.getPixels().getColor(x, y));
	ofDrawRectangle(x, y, 30, 30);
	
	// render the local image copy in the upper right corner
	if(image.isAllocated()){
		int w = image.getWidth()/4;
		int h = image.getHeight()/4;
		ofSetColor(255);
		ofSetRectMode(OF_RECTMODE_CORNER);
		image.draw(ofGetWidth()-w, 0, w, h);
	}
}

//--------------------------------------------------------------
void ofApp::keyPressed(int key){

}

//--------------------------------------------------------------
void ofApp::keyReleased(int key){

}

//--------------------------------------------------------------
void ofApp::mouseMoved(int x, int y){

}

//--------------------------------------------------------------
void ofApp::mouseDragged(int x, int y, int button){

}

//--------------------------------------------------------------
void ofApp::mousePressed(int x, int y, int button){

}

//--------------------------------------------------------------
void ofApp::mouseReleased(int x, int y, int button){

}

//--------------------------------------------------------------
void ofApp::windowResized(int w, int h){

}

//--------------------------------------------------------------
void ofApp::gotMessage(ofMessage msg){

}

//--------------------------------------------------------------
void ofApp::dragEvent(ofDragInfo dragInfo){ 

}
