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
width(0), height(0), bSetup(false)
{

}

void ofxSyphonClient::setup()
{
    @autoreleasepool {
        mClient = ofxSNOMake([[SyphonNameboundClient alloc] initWithContext:CGLGetCurrentContext()]);
    }
	bSetup = true;
}

bool ofxSyphonClient::isSetup(){
    return bSetup;
}

bool ofxSyphonClient::isConnected() const {
    if(bSetup)
    {
        @autoreleasepool {
            // Simple proposal
            // Not sure if isClientValid needs some locks
            // Neither if its OK to change a file within the framework (isClientValid)
            const bool ret = [(SyphonNameboundClient *)ofxSNOGet(mClient) isClientValid];

            // Alternative using the provided locking API
            // [(SyphonNameboundClient*)ofxSNOGet(mClient) lockClient];
            // SyphonOpenGLClient* client = [(SyphonNameboundClient *)ofxSNOGet(mClient) client];

            // bool ret = false;
            // if(client)
            // {
            //     ret = [client isValid];
            // }
            // [(SyphonNameboundClient*)ofxSNOGet(mClient) unlockClient];

            return ret;
        }
    }
    return false;
}

void ofxSyphonClient::set(ofxSyphonServerDescription _server){
    set(_server.serverName, _server.appName);
}

void ofxSyphonClient::set(const std::string &_serverName, const std::string &_appName){
    if(bSetup)
    {
        @autoreleasepool {
            NSString *nsAppName = [NSString stringWithCString:_appName.c_str() encoding:[NSString defaultCStringEncoding]];
            NSString *nsServerName = [NSString stringWithCString:_serverName.c_str() encoding:[NSString defaultCStringEncoding]];
            
            [(SyphonNameboundClient*)ofxSNOGet(mClient) setAppName:nsAppName];
            [(SyphonNameboundClient*)ofxSNOGet(mClient) setName:nsServerName];
            
            appName = _appName;
            serverName = _serverName;
        }
    }
}

void ofxSyphonClient::setApplicationName(const std::string &_appName)
{
    if(bSetup)
    {
        @autoreleasepool {
            NSString *name = [NSString stringWithCString:_appName.c_str() encoding:[NSString defaultCStringEncoding]];
            
            [(SyphonNameboundClient*)ofxSNOGet(mClient) setAppName:name];
            
            appName = _appName;
        }
    }
    
}
void ofxSyphonClient::setServerName(const std::string &_serverName)
{
    if(bSetup)
    {
        @autoreleasepool {
            NSString *name = [NSString stringWithCString:_serverName.c_str() encoding:[NSString defaultCStringEncoding]];

            if([name length] == 0)
                name = nil;
            
            [(SyphonNameboundClient*)ofxSNOGet(mClient) setName:name];
            
            serverName = _serverName;
        }
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
        @autoreleasepool {
            [(SyphonNameboundClient*)ofxSNOGet(mClient) lockClient];
           SyphonOpenGLClient *client = [(SyphonNameboundClient*)ofxSNOGet(mClient) client];
           
           ofxSNOSet(latestImage, [client newFrameImage]);
           NSSize texSize = [(SyphonOpenGLImage*)ofxSNOGet(latestImage) textureSize];
           
           // we now have to manually make our ofTexture's ofTextureData a proxy to our SyphonOpenGLImage
           mTex.setUseExternalTextureID([(SyphonOpenGLImage*)ofxSNOGet(latestImage) textureName]);
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
    }
    else
		cout<<"ofxSyphonClient is not setup, or is not properly connected to server.  Cannot bind.\n";
}

void ofxSyphonClient::unbind()
{
    if(bSetup)
    {
        mTex.unbind();
        @autoreleasepool {
            [(SyphonNameboundClient*)ofxSNOGet(mClient) unlockClient];
            latestImage = ofxSyphonNSObject();
        }
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


