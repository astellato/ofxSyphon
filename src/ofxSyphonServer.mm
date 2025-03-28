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
#import <string>
#import "ofAppRunner.h"
#import "ofTexture.h"

ofxSyphonServer::ofxSyphonServer()
{
	
}

void ofxSyphonServer::setName(const std::string &n)
{
    @autoreleasepool {
        NSString *title = [NSString stringWithCString:n.c_str()
                                             encoding:[NSString defaultCStringEncoding]];
        
        if (!mSyphon)
        {
            ofxSNOSet(mSyphon, [[SyphonOpenGLServer alloc] initWithName:title context:CGLGetCurrentContext() options:nil]);
        }
        else
        {
            [(SyphonOpenGLServer *)ofxSNOGet(mSyphon) setName:title];
        }
    }
}

std::string ofxSyphonServer::getName()
{
	std::string name;
	if (mSyphon)
	{
        @autoreleasepool {
            name = [[(SyphonOpenGLServer *)ofxSNOGet(mSyphon) name] cStringUsingEncoding:[NSString defaultCStringEncoding]];
        }
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
        
        @autoreleasepool {
            if (!mSyphon)
            {
                ofxSNOSet(mSyphon, [[SyphonOpenGLServer alloc] initWithName:@"Untitled" context:CGLGetCurrentContext() options:nil]);
            }
            
            [(SyphonOpenGLServer *)ofxSNOGet(mSyphon) publishFrameTexture:texData.textureID textureTarget:texData.textureTarget imageRegion:NSMakeRect(0, 0, texData.width, texData.height) textureDimensions:NSMakeSize(texData.width, texData.height) flipped:!texData.bFlipTexture];
        }
    }
    else
    {
		cout<<"ofxSyphonServer texture is not properly backed.  Cannot draw.\n";
	}
}

void ofxSyphonServer::publishTexture(GLuint id, GLenum target, GLsizei width, GLsizei height, bool isFlipped)
{
    @autoreleasepool {
        if (!mSyphon)
        {
            ofxSNOSet(mSyphon, [[SyphonOpenGLServer alloc] initWithName:@"Untitled" context:CGLGetCurrentContext() options:nil]);
        }
        
        [(SyphonOpenGLServer *)ofxSNOGet(mSyphon) publishFrameTexture:id textureTarget:target imageRegion:NSMakeRect(0, 0, width, height) textureDimensions:NSMakeSize(width, height) flipped:!isFlipped];
    }
}
