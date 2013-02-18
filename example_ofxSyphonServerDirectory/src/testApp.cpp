#include "testApp.h"

//--------------------------------------------------------------
void testApp::setup(){
	client.setup();
	client.setServerName("");
	client.setApplicationName("");
	directory.setup();
	ofAddListener(directory.events.directoryUpdated,this,&testApp::directoryUpdated);
}
void testApp::directoryUpdated(ofxSyphonServerDirectoryEventArgs &arg)
{
	
	if(arg.directory->serverList.size()>0)
	{
		ofLogVerbose("directoryUpdated")<<" Name: "<<arg.directory->serverList[0].name <<" App Name: "<<arg.directory->serverList[0].appName;
		client.setServerName(arg.directory->serverList[0].name);
		
		client.setApplicationName(arg.directory->serverList[0].appName);
		
	}
}

//--------------------------------------------------------------
void testApp::update(){

}

//--------------------------------------------------------------
void testApp::draw(){

}

//--------------------------------------------------------------
void testApp::keyPressed(int key){

}

//--------------------------------------------------------------
void testApp::keyReleased(int key){

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