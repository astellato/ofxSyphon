/*
 *  ofxSyphonServer.cpp
 *  syphonTest
 *
 *  Created by astellato,vade,bangnoise on 11/6/10.
 *  
 *  http://syphon.v002.info/license.php
 */

#include "ofxSyphonClient.h"
#import <Syphon/Syphon.h>
#import "SyphonNameboundClient.h"

ofxSyphonClient::ofxSyphonClient() :
mClient(nil), latestImage(nil), width(0), height(0), bSetup(false)
{

}

ofxSyphonClient::~ofxSyphonClient()
{
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];

    [(SyphonNameboundClient*)mClient release];
    mClient = nil;
    
    [pool drain];
}

ofxSyphonClient::ofxSyphonClient(ofxSyphonClient const& s) :
mClient([(SyphonNameboundClient*)s.mClient retain]),
latestImage([(SyphonImage*)s.latestImage retain]),
mTex(s.mTex),
width(s.width),
height(s.height),
bSetup(s.bSetup),
appName(s.appName),
serverName(s.serverName)
{

}

ofxSyphonClient & ofxSyphonClient::operator= (ofxSyphonClient const& s)
{
    if (&s == this)
    {
        return *this;
    }
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];

    [(SyphonNameboundClient*)mClient release];
    mClient = [(SyphonNameboundClient*)s.mClient retain];
    [(SyphonImage*)latestImage release];
    latestImage = [(SyphonImage*)s.latestImage retain];
    mTex = s.mTex;
    width = s.width;
    height = s.height;
    bSetup = s.bSetup;
    appName = s.appName;
    serverName = s.serverName;

    [pool drain];
}

void ofxSyphonClient::setup()
{
    // Need pool
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
        
	mClient = [[SyphonNameboundClient alloc] initWithContext:CGLGetCurrentContext()];
               
	bSetup = true;
    
    [pool drain];
}

bool ofxSyphonClient::isSetup(){
    return bSetup;
}

void ofxSyphonClient::set(ofxSyphonServerDescription _server){
    set(_server.serverName, _server.appName);
}

void ofxSyphonClient::set(string _serverName, string _appName){
    if(bSetup)
    {
        NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
        
        NSString *nsAppName = [NSString stringWithCString:_appName.c_str() encoding:[NSString defaultCStringEncoding]];
        NSString *nsServerName = [NSString stringWithCString:_serverName.c_str() encoding:[NSString defaultCStringEncoding]];
        
        [(SyphonNameboundClient*)mClient setAppName:nsAppName];
        [(SyphonNameboundClient*)mClient setName:nsServerName];
        
        appName = _appName;
        serverName = _serverName;
        
        [pool drain];
    }
}

void ofxSyphonClient::setApplicationName(string _appName)
{
    if(bSetup)
    {
        NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
        
        NSString *name = [NSString stringWithCString:_appName.c_str() encoding:[NSString defaultCStringEncoding]];
        
        [(SyphonNameboundClient*)mClient setAppName:name];
        
        appName = _appName;

        [pool drain];
    }
    
}
void ofxSyphonClient::setServerName(string _serverName)
{
    if(bSetup)
    {
        NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
        
        NSString *name = [NSString stringWithCString:_serverName.c_str() encoding:[NSString defaultCStringEncoding]];

        if([name length] == 0)
            name = nil;
        
        [(SyphonNameboundClient*)mClient setName:name];
        
        serverName = _serverName;
    
        [pool drain];
    }    
}

string& ofxSyphonClient::getApplicationName(){
    return appName;
}

string& ofxSyphonClient::getServerName(){
    return serverName;
}

void ofxSyphonClient::bind()
{
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    
    if(bSetup)
    {
     	[(SyphonNameboundClient*)mClient lockClient];
        SyphonClient *client = [(SyphonNameboundClient*)mClient client];
        
        latestImage = [client newFrameImage];
		NSSize texSize = [(SyphonImage*)latestImage textureSize];
        
        // we now have to manually make our ofTexture's ofTextureData a proxy to our SyphonImage
        mTex.setUseExternalTextureID([(SyphonImage*)latestImage textureName]);
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
        
        mTex.bind();
    }
    else
		cout<<"ofxSyphonClient is not setup, or is not properly connected to server.  Cannot bind.\n";
    
    [pool drain];
}

void ofxSyphonClient::unbind()
{
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    
    if(bSetup)
    {
        mTex.unbind();

        [(SyphonNameboundClient*)mClient unlockClient];
        [(SyphonImage*)latestImage release];
        latestImage = nil;
    }
    else
		cout<<"ofxSyphonClient is not setup, or is not properly connected to server.  Cannot unbind.\n";

        [pool drain];
}

void ofxSyphonClient::draw(float x, float y, float w, float h)
{
    this->bind();
    
    mTex.draw(x, y, w, h);
    
    this->unbind();
}

void ofxSyphonClient::draw(float x, float y)
{
	this->draw(x, y, mTex.texData.width, mTex.texData.height);
}

void ofxSyphonClient::drawSubsection(float x, float y, float w, float h, float sx, float sy, float sw, float sh)
{
    this->bind();
    
    mTex.drawSubsection(x, y, w, h, sx, sy, sw, sh);
    
    this->unbind();
}

void ofxSyphonClient::drawSubsection(float x, float y, float sx, float sy, float sw, float sh)
{
	this->drawSubsection(x, y, mTex.texData.width, mTex.texData.height, sx, sy, sw, sh);
}

float ofxSyphonClient::getWidth()
{
	return mTex.texData.width;
}

float ofxSyphonClient::getHeight()
{
	return mTex.texData.height;
}


