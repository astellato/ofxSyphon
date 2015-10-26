Syphon for Open Frameworks
==========================

About
-----

Syphon is a system for sending video between applications. You can use it to send high resolution and high frame rate video, 3D textures and synthesized content between your openFrameworks application other applications and environments.

Syphon for openFrameworks includes one add-on with three new objects, ofxSyphonClient, ofxSyphonServer and ofxSyphonServerDirectory:

 - ofxSyphonClient: brings frames from other applications into openFrameworks wrapped in an ofTexture, which can be bound and drawn like any ofTexture.
 - ofxSyphonServer: allows ofTextures and the whole GLUT scene to be named and published to the system, so that other applications which support Syphon can use them.
 - ofxSyphonDirectory: lets users browse the shared Syphon directory of all available servers

Licensing
---------

Syphon for Open Frameworks is published under a Simplified BSD license. See the included License.txt file.

Requirements
------------

Mac OS X 10.6.4 or greater
Open Frameworks 008 or better

Installation
------------

Clone ofxSyphon to the addons folder of your openFrameworks installation. Examples projects called example-Basic and example-ServerDirectory are included.

The repository has branches for major OpenFrameworks versions. The master branch corresponds to the latest official OpenFrameworks release. An of_head branch roughly follows current OpenFrameworks development. Use the branch which corresponds to the version of OpenFrameworks you are using.
   
Instructions
------------

Use the OpenFrameworks Project Generator to add ofxSyphon to your project.

The two example projects demonstrate usage.

Use any Syphon-enabled application to send or receive frames. You can use the [Syphon Demo Apps](http://code.google.com/p/syphon-implementations/downloads/detail?name=Syphon%20Demo%20Apps%20Public%20Beta%202.dmg) to test functionality.

Credits
-------

Syphon for Open Frameworks - Tom Butterworth (bangnoise) and Anton Marini (vade) and Anthony Stellato (astellato).

http://syphon.v002.info 
