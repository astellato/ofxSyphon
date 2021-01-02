linux64:
	ADDON_SOURCES_EXCLUDE = libs/%
	ADDON_INCLUDES_EXCLUDE = libs/%
	ADDON_SOURCES =

vs:
	ADDON_SOURCES_EXCLUDE = libs/%
	ADDON_INCLUDES_EXCLUDE = libs/%
	ADDON_SOURCES =

linuxarmv6l:
	ADDON_SOURCES_EXCLUDE = libs/%
	ADDON_INCLUDES_EXCLUDE = libs/%
	ADDON_SOURCES =

linuxarmv7l:
	ADDON_SOURCES_EXCLUDE = libs/%
	ADDON_INCLUDES_EXCLUDE = libs/%
	ADDON_SOURCES =

android/armeabi:
	ADDON_SOURCES_EXCLUDE = libs/%
	ADDON_INCLUDES_EXCLUDE = libs/%
	ADDON_SOURCES =

android/armeabi-v7a:
	ADDON_SOURCES_EXCLUDE = libs/%
	ADDON_INCLUDES_EXCLUDE = libs/%
	ADDON_SOURCES =

osx:
	ADDON_CFLAGS = -F$(OF_ROOT)/addons/ofxSyphon/libs/Syphon/lib/osx/
	ADDON_LDFLAGS = -F$(OF_ROOT)/addons/ofxSyphon/libs/Syphon/lib/osx/ -framework Syphon

ios:
	ADDON_SOURCES_EXCLUDE = libs/%
	ADDON_INCLUDES_EXCLUDE = libs/%
	ADDON_SOURCES =

tvos:
	ADDON_SOURCES_EXCLUDE = libs/%
	ADDON_INCLUDES_EXCLUDE = libs/%
	ADDON_SOURCES =
