//
// 2017 Dan Wilcox danomatika.com
// for EDP Creative Coding @ the University of Denver
// Updates 2025 Tom Butterworth
//
// Demonstrates the steps to get a texture from an ofxSyphonClient
//  to ofPixels (and an ofImage).
#include "ofApp.h"

//--------------------------------------------------------------
void ofApp::setup(){
	ofSetWindowTitle("ofxSyphonImageExample");
	ofSetWindowShape(800, 600);
	ofSetFrameRate(60);

	// setup our Syphon server directory & client
	serverDir.setup();
	client.setup();
}

//--------------------------------------------------------------
void ofApp::update(){

}

//--------------------------------------------------------------
void ofApp::draw(){
    ofBackground(180, 180, 180);
    // it would be smarter to only grab this from the GPU when there is a new
    // frame, but there currently isn't a way to check this via the Syphon
    // client object
    if(serverDir.isValidIndex(0)){
        
        // always lock/unlock around direct texture access
        if (client.lockTexture())
        {
            // Setup our FBO to match the client
            if (client.getTexture().isAllocated())
            {
                ofTextureData &texData = client.getTexture().getTextureData();
                // reallocate if the incoming texture size is different from our fbo & image
                if((texData.width != 0 && texData.height != 0) &&
                   (fbo.getWidth() != texData.width || fbo.getHeight() != texData.height)){
                    fbo.allocate(texData.width, texData.height);
                }
            }
        
            // render Syphon client texture into the FBO
            ofSetColor(255);
            ofSetRectMode(OF_RECTMODE_CORNER);
                
            fbo.begin();
                
            ofBackground(0, 0, 0, 0);
            ofEnableAlphaBlending();
            client.draw(0, 0);
                
            fbo.end();

            client.unlockTexture();
            
            // read the pixels in the FBO into our local ofImage's pixels
            fbo.readToPixels(image.getPixels());
            // we manually loaded pixel data into the image, so update the image texture here
            image.update();
        }
    }
	
	// render the image copy
	if(image.isAllocated()){
		ofSetColor(255);
		ofSetRectMode(OF_RECTMODE_CORNER);
		image.draw(0, 0);
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
