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
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    
    [(SyphonServer *)mSyphon stop];
    [(SyphonServer *)mSyphon release];
    
    [pool drain];
}


void ofxSyphonServer::setName(string n)
{
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    
	NSString *title = [NSString stringWithCString:n.c_str()
										 encoding:[NSString defaultCStringEncoding]];
	
	if (!mSyphon)
	{
		mSyphon = [[SyphonServer alloc] initWithName:title context:CGLGetCurrentContext() options:nil];
	}
	else
	{
		[(SyphonServer *)mSyphon setName:title];
	}
    
    [pool drain];
}

string ofxSyphonServer::getName()
{
	string name;
	if (mSyphon)
	{
		NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
        
		name = [[(SyphonServer *)mSyphon name] cStringUsingEncoding:[NSString defaultCStringEncoding]];
		
		[pool drain];
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
        NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
        
		ofTextureData texData = inputTexture->getTextureData();
        
		if (!mSyphon)
		{
			mSyphon = [[SyphonServer alloc] initWithName:@"Untitled" context:CGLGetCurrentContext() options:nil];
		}
		
		[(SyphonServer *)mSyphon publishFrameTexture:texData.textureID textureTarget:texData.textureTarget imageRegion:NSMakeRect(0, 0, texData.width, texData.height) textureDimensions:NSMakeSize(texData.width, texData.height) flipped:!texData.bFlipTexture];
        [pool drain];
    }
    else
    {
		cout<<"ofxSyphonServer texture is not properly backed.  Cannot draw.\n";
	}
}

void ofxSyphonServer::publishTexture(GLuint id, GLenum target, GLsizei width, GLsizei height, bool isFlipped)
{
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    
    if (!mSyphon)
    {
        mSyphon = [[SyphonServer alloc] initWithName:@"Untitled" context:CGLGetCurrentContext() options:nil];
    }
    
    [(SyphonServer *)mSyphon publishFrameTexture:id textureTarget:target imageRegion:NSMakeRect(0, 0, width, height) textureDimensions:NSMakeSize(width, height) flipped:!isFlipped];
    [pool drain];
    
}

bool ofxSyphonServer::tryToBindForSize(int w,int h){
  bool res;
  @autoreleasepool{

    if (!mSyphon)
    {
      mSyphon = [[SyphonServer alloc] initWithName:@"Untitled" context:CGLGetCurrentContext() options:nil];
    }

    res = [(SyphonServer *)mSyphon bindToDrawFrameOfSize:NSMakeSize( w,h)];
    if(res){
      ofPushMatrix();
      ofPushView();
      ofViewport(0,0,w,h,false);
      ofSetupScreenOrtho(w,h);

    }
  }
  
		return res;
}

void ofxSyphonServer::unbindAndPublish(){
  if (mSyphon){
    @autoreleasepool{
      [(SyphonServer *)mSyphon unbindAndPublish];

      updateCurrentTexture();
      ofPopView();
      ofPopMatrix();
    }
  }
}

ofTexture & ofxSyphonServer::getCurrentTexture(){
  return mTex;
}
void ofxSyphonServer::updateCurrentTexture(){

  if(!mSyphon) return ;
  @autoreleasepool{
    SyphonImage * Img =[(SyphonServer *)mSyphon newFrameImage] ;
    NSSize texSize = [(SyphonImage*)Img textureSize];
    mTex.setUseExternalTextureID([Img textureName]);


    mTex.texData.textureTarget = GL_TEXTURE_RECTANGLE_ARB;  // Syphon always outputs rect textures.
    mTex.texData.width = texSize.width;
    mTex.texData.height = texSize.height;
    mTex.texData.tex_w = texSize.width;
    mTex.texData.tex_h = texSize.height;
    mTex.texData.tex_t = texSize.width;
    mTex.texData.tex_u = texSize.height;
    mTex.texData.glInternalFormat = GL_RGBA;
#if (OF_VERSION_MAJOR == 0) && (OF_VERSION_MINOR < 8)
    mTex.texData.glType = GL_RGBA;
    mTex.texData.pixelType = GL_UNSIGNED_BYTE;
#endif
    mTex.texData.bFlipTexture = YES;
    mTex.texData.bAllocated = YES;
    
    
  }
  
}
