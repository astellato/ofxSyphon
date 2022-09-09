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
    cleanup();
}

ofxSyphonClient::ofxSyphonClient(ofxSyphonClient const& s) :
mClient(s.mClient),
latestImage(s.latestImage),
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

    mClient = s.mClient;
    latestImage = s.latestImage;
    mTex = s.mTex;
    width = s.width;
    height = s.height;
    bSetup = s.bSetup;
    appName = s.appName;
    serverName = s.serverName;

    return *this;
}


void ofxSyphonClient::cleanup(){
    if( mClient != nil ){
        //this transfers the memory back from void * to an objective-c object so ARC can automatically do cleanup
        SyphonNameboundClient * fakeClient = (__bridge_transfer SyphonNameboundClient *)mClient;
        mClient = nil;
    }
}


void ofxSyphonClient::setup()
{
    //sketchy as we transfer ownership to void * and that means we have to manage the memory ourselves so in destructor we are going to make it back into an obj-c object and transfer back so ARC can do its thing.
    cleanup();
	mClient = (__bridge_retained void *)[[SyphonNameboundClient alloc] initWithContext:CGLGetCurrentContext()];
               
	bSetup = true;
}

bool ofxSyphonClient::isSetup(){
    return bSetup;
}

void ofxSyphonClient::set(ofxSyphonServerDescription _server){
    set(_server.serverName, _server.appName);
}

void ofxSyphonClient::set(const std::string &_serverName, const std::string &_appName){
    if(bSetup)
    {
        NSString *nsAppName = [NSString stringWithCString:_appName.c_str() encoding:[NSString defaultCStringEncoding]];
        NSString *nsServerName = [NSString stringWithCString:_serverName.c_str() encoding:[NSString defaultCStringEncoding]];
        
        [(__bridge SyphonNameboundClient*)mClient setAppName:nsAppName];
        [(__bridge SyphonNameboundClient*)mClient setName:nsServerName];
        
        appName = _appName;
        serverName = _serverName;
    }
}

void ofxSyphonClient::setApplicationName(const std::string &_appName)
{
    if(bSetup)
    {
        NSString *name = [NSString stringWithCString:_appName.c_str() encoding:[NSString defaultCStringEncoding]];
        
        [(__bridge SyphonNameboundClient*)mClient setAppName:name];
        
        appName = _appName;
    }
    
}
void ofxSyphonClient::setServerName(const std::string &_serverName)
{
    if(bSetup)
    {
        NSString *name = [NSString stringWithCString:_serverName.c_str() encoding:[NSString defaultCStringEncoding]];

        if([name length] == 0)
            name = nil;
        
        [(__bridge SyphonNameboundClient*)mClient setName:name];
        
        serverName = _serverName;
    }
}

const std::string& ofxSyphonClient::getApplicationName(){
    return appName;
}

const std::string& ofxSyphonClient::getServerName(){
    return serverName;
}

void ofxSyphonClient::bind()
{
    if(bSetup)
    {
     	[(__bridge SyphonNameboundClient*)mClient lockClient];
        SyphonOpenGLClient *client = [(__bridge SyphonNameboundClient*)mClient client];
        
        latestImage = (__bridge void *)[client newFrameImage];
		NSSize texSize = [(__bridge SyphonOpenGLImage*)latestImage textureSize];
        
        // we now have to manually make our ofTexture's ofTextureData a proxy to our SyphonOpenGLImage
        mTex.setUseExternalTextureID([(__bridge SyphonOpenGLImage*)latestImage textureName]);
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
}

void ofxSyphonClient::unbind()
{
    if(bSetup)
    {
        mTex.unbind();

        [(__bridge SyphonNameboundClient*)mClient unlockClient];
        latestImage = nil;
    }
    else
		cout<<"ofxSyphonClient is not setup, or is not properly connected to server.  Cannot unbind.\n";
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


