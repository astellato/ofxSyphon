#include "testApp.h"

const int width = 800;
const int height = 600;

//--------------------------------------------------------------
void testApp::setup(){
	counter = 0;
	ofSetCircleResolution(50);
	
    //ofBackground(0,0,0);
    
	
    bSmooth = false;
	ofSetWindowTitle("ofxSyphon Example");
    
	mainOutputSyphonServer.setName("Screen Output");
	individualTextureSyphonServer.setName("Texture Output");

	mClient.setup();
    
    //using Syphon app Simple Server, found at http://syphon.v002.info/
    mClient.set("","Simple Server");
	
    tex.allocate(200, 100, GL_RGBA);
    
	ofSetFrameRate(60); // if vertical sync is off, we can go a bit fast... this caps the framerate at 60fps.
}

//--------------------------------------------------------------
void testApp::update(){
	counter = counter + 0.033f;
}

//--------------------------------------------------------------
void testApp::draw(){
	
    // Clear with alpha, so we can capture via syphon and composite elsewhere should we want.
    glClearColor(0.0, 0.0, 0.0, 0.0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
	//--------------------------- circles
	//let's draw a circle:
	ofSetColor(255,130,0);
	float radius = 50 + 10 * sin(counter);
	ofFill();		// draw "filled shapes"
	ofCircle(100,400,radius);
	
	// now just an outline
	ofNoFill();
	ofSetHexColor(0xCCCCCC);
	ofCircle(100,400,80);
	
	// use the bitMap type
	// note, this can be slow on some graphics cards
	// because it is using glDrawPixels which varies in
	// speed from system to system.  try using ofTrueTypeFont
	// if this bitMap type slows you down.
	ofSetHexColor(0x000000);
	ofDrawBitmapString("circle", 75,500);
	
	
	//--------------------------- rectangles
	ofFill();
	for (int i = 0; i < 200; i++){
		ofSetColor((int)ofRandom(0,255),(int)ofRandom(0,255),(int)ofRandom(0,255));
		ofRect(ofRandom(250,350),ofRandom(350,450),ofRandom(10,20),ofRandom(10,20));
	}
	ofSetHexColor(0x000000);
	ofDrawBitmapString("rectangles", 275,500);
	
	//---------------------------  transparency
	ofSetHexColor(0x00FF33);
	ofRect(100,150,100,100);
	// alpha is usually turned off - for speed puposes.  let's turn it on!
	ofEnableAlphaBlending();
	ofSetColor(255,0,0,127);   // red, 50% transparent
	ofRect(150,230,100,33);
	ofSetColor(255,0,0,(int)(counter * 10.0f) % 255);   // red, variable transparent
	ofRect(150,170,100,33);
	ofDisableAlphaBlending();
	
	ofSetHexColor(0x000000);
	ofDrawBitmapString("transparency", 110,300);
	
	//---------------------------  lines
	// a bunch of red lines, make them smooth if the flag is set
	
	if (bSmooth){
		ofEnableSmoothing();
	}
	
	ofSetHexColor(0xFF0000);
	for (int i = 0; i < 20; i++){
		ofLine(300,100 + (i*5),500, 50 + (i*10));
	}
	
	if (bSmooth){
		ofDisableSmoothing();
	}
	
    ofSetColor(255,255,255);
	ofDrawBitmapString("lines\npress 's' to toggle smoothness", 300,300);
    
    // draw static into our one texture.
    unsigned char pixels[200*100*4];
    
    for (int i = 0; i < 200*100*4; i++)
    {
        pixels[i] = (int)(255 * ofRandomuf());
    }
    tex.loadData(pixels, 200, 100, GL_RGBA);
    
    ofSetColor(255, 255, 255);
    
    ofEnableAlphaBlending();
    
    tex.draw(50, 50);
    
	// Syphon Stuff
    
    mClient.draw(50, 50);    
    
	mainOutputSyphonServer.publishScreen();
    
    individualTextureSyphonServer.publishTexture(&tex);
    
    ofDrawBitmapString("Note this text is not captured by Syphon since it is drawn after publishing.\nYou can use this to hide your GUI for example.", 150,500);    
}


//--------------------------------------------------------------
void testApp::keyPressed  (int key){
	if (key == 's'){
		bSmooth = !bSmooth;
	}
}
