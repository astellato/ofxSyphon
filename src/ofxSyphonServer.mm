/*
 *  ofxSyphonServer.cpp
 *  syphonTest
 *
 *  Created by astellato,vade,bangnoise on 11/6/10.
 *
 *  http://syphon.v002.info/license.php
 */

#include "ofxSyphonServer.h"
#import <Syphon/Syphon.h>

ofxSyphonServer::ofxSyphonServer()
{
	mSyphon = nil;
}

ofxSyphonServer::~ofxSyphonServer()
{
    if( mSyphon != nil ){
        [(__bridge SyphonOpenGLServer *)mSyphon stop];
    }
    cleanup();
}

void ofxSyphonServer::cleanup(){
    if( mSyphon != nil ){
        //this transfers the memory back from void * to an objective-c object so ARC can automatically do cleanup
        SyphonOpenGLServer * fakeServer = (__bridge_transfer SyphonOpenGLServer *)mSyphon;
        mSyphon = nil;
    }
}

void ofxSyphonServer::setName(const std::string &n)
{
	NSString *title = [NSString stringWithCString:n.c_str()
										 encoding:[NSString defaultCStringEncoding]];
	
	if (!mSyphon)
	{
        	//sketchy as we transfer ownership to void * and that means we have to manage the memory ourselves so in destructor we are going to make it back into an obj-c object and transfer back so ARC can do its thing.
        	mSyphon = (__bridge_retained void *)[[SyphonOpenGLServer alloc] initWithName:title context:CGLGetCurrentContext() options:nil];
	}
	else
	{
		[(__bridge SyphonOpenGLServer *)mSyphon setName:title];
	}
    
}

std::string ofxSyphonServer::getName()
{
	std::string name;
	if (mSyphon)
	{
		name = [[(__bridge SyphonOpenGLServer *)mSyphon name] cStringUsingEncoding:[NSString defaultCStringEncoding]];
	}
	else
	{
		name = "Untitled";
	}
	return name;
}

void ofxSyphonServer::publishScreen()
{
	int w = ofGetWidth();
	int h = ofGetHeight();
	
	ofTexture tex;
	tex.allocate(w, h, GL_RGBA);
	
	tex.loadScreenData(0, 0, w, h);
    
	this->publishTexture(&tex);
	
	tex.clear();
}


void ofxSyphonServer::publishTexture(ofTexture* inputTexture)
{
    // If we are setup, and our input texture
	if(inputTexture->isAllocated())
    {
		ofTextureData texData = inputTexture->getTextureData();
        
		if (!mSyphon)
		{
			mSyphon = (__bridge_retained void *)[[SyphonOpenGLServer alloc] initWithName:@"Untitled" context:CGLGetCurrentContext() options:nil];
		}
		
		[(__bridge SyphonOpenGLServer *)mSyphon publishFrameTexture:texData.textureID textureTarget:texData.textureTarget imageRegion:NSMakeRect(0, 0, texData.width, texData.height) textureDimensions:NSMakeSize(texData.width, texData.height) flipped:!texData.bFlipTexture];
    }
    else
    {
		cout<<"ofxSyphonServer texture is not properly backed.  Cannot draw.\n";
	}
}

void ofxSyphonServer::publishTexture(GLuint id, GLenum target, GLsizei width, GLsizei height, bool isFlipped)
{
    if (!mSyphon)
    {
        mSyphon = (__bridge_retained void *)[[SyphonOpenGLServer alloc] initWithName:@"Untitled" context:CGLGetCurrentContext() options:nil];
    }
    
    [(__bridge SyphonOpenGLServer *)mSyphon publishFrameTexture:id textureTarget:target imageRegion:NSMakeRect(0, 0, width, height) textureDimensions:NSMakeSize(width, height) flipped:!isFlipped];    
}
