// example-Image: grabs Syphon texture pixel data into an image via an FBO
//
// 2017 Dan Wilcox danomatika.com
// for EDP Creative Coding @ the University of Denver
//
#pragma once

#include "ofMain.h"
#include "ofxSyphon.h"

class ofApp : public ofBaseApp{

	public:
		void setup();
		void update();
		void draw();

		void keyPressed(int key);
		void keyReleased(int key);
		void mouseMoved(int x, int y);
		void mouseDragged(int x, int y, int button);
		void mousePressed(int x, int y, int button);
		void mouseReleased(int x, int y, int button);
		void windowResized(int w, int h);
		void dragEvent(ofDragInfo dragInfo);
		void gotMessage(ofMessage msg);

        void serverAnnounced(ofxSyphonServerDirectoryEventArgs &arg);

        ofxSyphonServerDirectory serverDir;
        ofxSyphonClient client;
        int serverIndex;
	
		ofFbo fbo;
		ofPixels pixels;
		ofImage image;
};
