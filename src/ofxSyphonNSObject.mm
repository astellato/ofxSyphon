//
//  ofxSyphonNSObject.mm
//  ofxSyphon
//
//  Created by Tom Butterworth on 16/09/2022.
//

#include "ofxSyphonNSObject.hpp"

ofxSyphonNSObject::ofxSyphonNSObject()
: mObject(nil)
{
    
}

ofxSyphonNSObject::~ofxSyphonNSObject()
{
    // This can be called from C++ with no autorelease pool in place, so we need one
    @autoreleasepool {
        // Do this explicitely here to force ARC release
        mObject = nil;
    }
}

ofxSyphonNSObject::ofxSyphonNSObject(const ofxSyphonNSObject &o)
: mObject(o.mObject)
{
    
}

ofxSyphonNSObject & ofxSyphonNSObject::operator=(const ofxSyphonNSObject &o)
{
    if (&o != this)
    {
        // This can be called from C++ with no autorelease pool in place, so we need one
        @autoreleasepool {
            mObject = o.mObject;
        }
    }
    return *this;
}

ofxSyphonNSObject::operator bool() const
{
    return mObject ? true : false;
}

ofxSyphonNSObject ofxSNOMake(ofxSyphonNSObject::ObjectType obj)
{
    ofxSyphonNSObject dst;
    dst.mObject = obj;
    return dst;
}

void ofxSNOSet(ofxSyphonNSObject &dst, ofxSyphonNSObject::ObjectType obj)
{
    dst.mObject = obj;
}

ofxSyphonNSObject::ObjectType ofxSNOGet(const ofxSyphonNSObject &o)
{
    return o.mObject;
}
