//
//  ofxSyphonNSObject.hpp
//  ofxSyphon
//
//  Created by Tom Butterworth on 16/09/2022.
//

#ifndef ofxSyphonNSObject_hpp
#define ofxSyphonNSObject_hpp

#ifdef __OBJC__
#include <Foundation/Foundation.h>
#endif

class ofxSyphonNSObject {
public:
#ifdef __OBJC__
    using ObjectType = id<NSObject>;
#else
    using ObjectType = void *;
#endif
    ofxSyphonNSObject();
    ~ofxSyphonNSObject();
    ofxSyphonNSObject(const ofxSyphonNSObject &o);
    ofxSyphonNSObject & operator=(const ofxSyphonNSObject &o);
    operator bool() const;
    // No Objective-C functionality on the class so it can't cause undefined behaviour from pure C++ code
    friend ofxSyphonNSObject ofxSNOMake(ofxSyphonNSObject::ObjectType obj);
    friend void ofxSNOSet(ofxSyphonNSObject &dst, ofxSyphonNSObject::ObjectType obj);
    friend ofxSyphonNSObject::ObjectType ofxSNOGet(const ofxSyphonNSObject &o);
private:
    ObjectType mObject;
};

#ifdef __OBJC__
ofxSyphonNSObject ofxSNOMake(ofxSyphonNSObject::ObjectType obj);
void ofxSNOSet(ofxSyphonNSObject &dst, ofxSyphonNSObject::ObjectType obj);
ofxSyphonNSObject::ObjectType ofxSNOGet(const ofxSyphonNSObject &o);
#endif

#endif /* ofxSyphonNSObject_hpp */
