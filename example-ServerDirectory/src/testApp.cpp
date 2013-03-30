#include "testApp.h"

//--------------------------------------------------------------
void testApp::setup(){
    ofSetWindowTitle("ofxSyphonServerDirectoryExample");
    ofSetFrameRate(60); // if vertical sync is off, we can go a bit fast... this caps the framerate at 60fps.
    ofSetLogLevel(OF_LOG_NOTICE); //change to OF_LOG_VERBOSE for full directory debug statements
    
	client.setup(); //setup a generic client
	directory.setup();
    
    //register for our directory's callbacks
	ofAddListener(directory.events.directoryUpdated,this,&testApp::directoryUpdated);
    
    dirIdx = -1;
}
void testApp::directoryUpdated(ofxSyphonServerDirectoryEventArgs &arg)
{
    for( auto& dir : arg.directory->getServerList() ){ //new c++ auto keyword
        ofLogNotice("ofxSyphonServerDirectory Updated:: ")<<" Server Name: "<<dir.serverName <<" | App Name: "<<dir.appName;
    }
    dirIdx = 0;
}

//--------------------------------------------------------------
void testApp::update(){

}

//--------------------------------------------------------------
void testApp::draw(){
    ofBackground(255, 0, 0);
    
    if(directory.isValidIndex(dirIdx))
        client.draw(0, 0, ofGetWidth(), ofGetHeight());
}

//--------------------------------------------------------------
void testApp::keyPressed(int key){

}

//--------------------------------------------------------------
void testApp::keyReleased(int key){
    dirIdx++;
    if(dirIdx > directory.size() - 1)
        dirIdx = 0;
    client.setServerName(directory.getServerList()[dirIdx].serverName);
    client.setApplicationName(directory.getServerList()[dirIdx].appName);
    ofSetWindowTitle(client.getApplicationName() + ": " + client.getServerName());
}

//--------------------------------------------------------------
void testApp::mouseMoved(int x, int y ){

}

//--------------------------------------------------------------
void testApp::mouseDragged(int x, int y, int button){

}

//--------------------------------------------------------------
void testApp::mousePressed(int x, int y, int button){

}

//--------------------------------------------------------------
void testApp::mouseReleased(int x, int y, int button){

}

//--------------------------------------------------------------
void testApp::windowResized(int w, int h){

}

//--------------------------------------------------------------
void testApp::gotMessage(ofMessage msg){

}

//--------------------------------------------------------------
void testApp::dragEvent(ofDragInfo dragInfo){ 

}