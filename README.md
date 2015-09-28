Syphon for Open Frameworks, Public Beta 3
=========================================

About
-----

Syphon is a system for sending video between applications. You can use it to send high resolution and high frame rate video, 3D textures and synthesized content between your openFrameworks application other applications and environments.

Beta 3 adds support for ofGLProgrammableRenderer with OpenGL 3.2 support by swapping the default Syphon.framework with the branch from here: https://github.com/GameClay/syphon-framework/tree/PSW-OpenGL3
Also there is an added function for sharing an FBO directly.

Syphon for openFrameworks includes one add-on with two new objects, ofxSyphonClient & ofxSyphonServer. 

ofxSyphonClient - brings frames from other applications into openFrameworks wrapped in an ofTexture, which can be bound and drawn like any ofTexture.

ofxSyphonServer - allows ofTextures and the whole GLUT scene to be named and published to the system, so that other applications which support Syphon can use them.

ofxSyphonDirectory - lets users browse the shared Syphon directory of all available servers

Licensing
---------

Syphon for Open Frameworks is published under a Simplified BSD license. See the included License.txt file.

Requirements
------------

Mac OS X 10.6.4 or greater
Open Frameworks 008 or better

Installation
------------

Install ofxSyphon in the addons folder of your openFrameworks installation. Examples projects called example-Basic and example-ServerDirectory is included
   
Instructions
------------

Unfortunately the OpenFrameworks Project Generator does not work with ofxSyphon (at the time of writing - OF 0.8.4).

To add ofxSyphon to your project:

 - Drag the ofxSyphon addon folder into your project.
 - Add a Copy Files build phase to new projects to copy the Syphon framework into the Frameworks folder of the built product.
 - Add the location of the Syphon framework (`addons/ofxSyphon/libs/Syphon/lib/osx`) to the `Framework Search Paths` Build Setting in your Xcode project.

The included SyphonExample demonstrates these steps.

Use any Syphon-enabled application to send or receive frames. You can use the [Syphon Demo Apps](http://code.google.com/p/syphon-implementations/downloads/detail?name=Syphon%20Demo%20Apps%20Public%20Beta%202.dmg) to test functionality.

Credits
-------

Syphon for Open Frameworks - Tom Butterworth (bangnoise) and Anton Marini (vade) and Anthony Stellato (astellato) and Ole Kristensen (olekristensen).

Syphon for OpenGL3 - Pat Wilson (ZeroStride)

http://syphon.v002.info 
