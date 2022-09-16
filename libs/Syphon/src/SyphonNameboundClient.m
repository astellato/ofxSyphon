/*
    SyphonNameboundClient.m
	Syphon (Implementations)
	
    Copyright 2010-2011 bangnoise (Tom Butterworth) & vade (Anton Marini).
    All rights reserved.

    Redistribution and use in source and binary forms, with or without
    modification, are permitted provided that the following conditions are met:

    * Redistributions of source code must retain the above copyright
    notice, this list of conditions and the following disclaimer.

    * Redistributions in binary form must reproduce the above copyright
    notice, this list of conditions and the following disclaimer in the
    documentation and/or other materials provided with the distribution.

    THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
    ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
    WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
    DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS BE LIABLE FOR ANY
    DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
    (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
    LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
    ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
    (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
    SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */
 
#import "SyphonNameboundClient.h"

@interface SyphonNameboundClient (Private)
- (void)setClientFromSearchHavingLock:(BOOL)isLocked;
@end
@implementation SyphonNameboundClient

- (id)initWithContext:(CGLContextObj)context
{
    self = [super init];
	if (self)
	{
		_lock = OS_UNFAIR_LOCK_INIT;
		
        _searchPending = YES;
        _context = CGLRetainContext(context);
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleServerAnnounce:) name:SyphonServerAnnounceNotification object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleServerUpdate:) name:SyphonServerUpdateNotification object:nil];
	}
	return self;
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
    if (_context)
    {
        CGLReleaseContext(_context);
    }
}

- (NSString *)name
{
	NSString *result;
	os_unfair_lock_lock(&_lock);
	result = _name;
	os_unfair_lock_unlock(&_lock);
	return result;
}

- (void)setName:(NSString *)name
{
	os_unfair_lock_lock(&_lock);
	_name = name;
	_searchPending = YES;
	os_unfair_lock_unlock(&_lock);
}

- (NSString *)appName
{
	NSString *result;
	os_unfair_lock_lock(&_lock);
	result = _appname;
	os_unfair_lock_unlock(&_lock);
	return result;
}

- (void)setAppName:(NSString *)app
{
	os_unfair_lock_lock(&_lock);
	_appname = app;
	_searchPending = YES;
	os_unfair_lock_unlock(&_lock);
}

- (void)lockClient
{
	os_unfair_lock_lock(&_lock);
	if (_lockedClient == nil)
	{
		if (_searchPending)
		{
			[self setClientFromSearchHavingLock:YES];
			_searchPending = NO;
		}
		_lockedClient = _client;
	}
	os_unfair_lock_unlock(&_lock);
}

- (void)unlockClient
{
	SyphonOpenGLClient *doneWith;
	os_unfair_lock_lock(&_lock);
	doneWith = _lockedClient;
	_lockedClient = nil;
	os_unfair_lock_unlock(&_lock);
	doneWith = nil; // release outside the lock as it may take time
}

- (SyphonOpenGLClient *)client
{
	return _lockedClient;
}

- (void)setClient:(SyphonOpenGLClient *)client havingLock:(BOOL)isLocked
{
    SyphonOpenGLClient *newClient = client;
    SyphonOpenGLClient *oldClient;
	
	if (!isLocked) os_unfair_lock_lock(&_lock);
	oldClient = _client;
	_client = newClient;
	if (!isLocked) os_unfair_lock_unlock(&_lock);
	
	// If we were registered for notifications and no longer require them
	// remove ourself from the notification center
	
	if (oldClient == nil && newClient != nil)
	{
		[[NSNotificationCenter defaultCenter] removeObserver:self name:SyphonServerAnnounceNotification object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleServerRetire:) name:SyphonServerRetireNotification object:nil];
	}
	
	// If we weren't registered already, but need to register now, do so
	
	if (newClient == nil && oldClient != nil)
	{
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleServerAnnounce:) name:SyphonServerAnnounceNotification object:nil];
		[[NSNotificationCenter defaultCenter] removeObserver:self name:SyphonServerRetireNotification object:nil];
	}
}

- (BOOL)parametersMatchDescription:(NSDictionary *)description
{
	NSString *searchName = self.name;
	NSString *searchApp = self.appName;
	
	if ([searchName length] == 0)
	{
		searchName = nil;
	}
	if ([searchApp length] == 0)
	{
		searchApp = nil;
	}

	if ((!searchName || [[description objectForKey:SyphonServerDescriptionNameKey] isEqualToString:searchName])
		&& (!searchApp || [[description objectForKey:SyphonServerDescriptionAppNameKey] isEqualToString:searchApp]))
	{
			return YES;
	}
	return NO;
}

- (void)setClientFromSearchHavingLock:(BOOL)isLocked
{
    SyphonOpenGLClient *newClient = nil;
	
	if (!isLocked) os_unfair_lock_lock(&_lock);
    
    NSArray *matches = [[SyphonServerDirectory sharedDirectory] serversMatchingName:_name appName:_appname];

    if ([matches count] != 0)
    {
        NSString *current = [_client.serverDescription objectForKey:SyphonServerDescriptionUUIDKey];
        NSString *found = [[matches lastObject] objectForKey:SyphonServerDescriptionUUIDKey];
        if (found && [current isEqualToString:found])
        {
            newClient = _client;
        }
        else
        {
            newClient = [[SyphonOpenGLClient alloc] initWithServerDescription:[matches lastObject] context:_context options:nil newFrameHandler:nil];
        }
    }
	[self setClient:newClient havingLock:YES];
	
    if (!isLocked) os_unfair_lock_unlock(&_lock);
}

+ (NSDictionary *)serverInfoFromNotification:(NSNotification *)notification
{
    // This deals with a change in notifications from Syphon.
    // Once all projects using SyphonNameboundClient are updated to newer Syphon.framework
    // we won't need this method and can always use notification.userInfo.
    if ([notification.object isKindOfClass:[SyphonServerDirectory class]])
    {
        return notification.userInfo;
    }
    else
    {
        return notification.object;
    }
}

- (void)handleServerAnnounce:(NSNotification *)notification
{
	NSDictionary *newInfo = [SyphonNameboundClient serverInfoFromNotification:notification];
    // If we don't have a client, or our current client doesn't match our parameters any more
	if ((_client == nil || ![self parametersMatchDescription:[_client serverDescription]])
		&& [self parametersMatchDescription:newInfo])
	{
        SyphonOpenGLClient *newClient = [[SyphonOpenGLClient alloc] initWithServerDescription:newInfo context:_context options:nil newFrameHandler:nil];
		
		[self setClient:newClient havingLock:NO];
	}
}

- (void)handleServerUpdate:(NSNotification *)notification
{
	NSDictionary *newInfo = [SyphonNameboundClient serverInfoFromNotification:notification];
	NSDictionary *currentServer = [_client serverDescription];
	// It's possible our client hasn't received the update yet, so we can't trust its server description
	// so check if the new update is for our client...
	if ([[currentServer objectForKey:SyphonServerDescriptionUUIDKey] isEqualToString:[newInfo objectForKey:SyphonServerDescriptionUUIDKey]])
	{
		// ...and if so, check to see if our parameters no longer describe the server
		if (![self parametersMatchDescription:newInfo])
		{
			[self setClient:nil havingLock:NO];
		}
		
	}
	// If we don't have a matching client but this client's new details match, then set up a new client
	if (_client == nil && [self parametersMatchDescription:newInfo])
	{
        SyphonOpenGLClient *newClient = [[SyphonOpenGLClient alloc] initWithServerDescription:newInfo context:_context options:nil newFrameHandler:nil];
		
		[self setClient:newClient havingLock:NO];
	}
}

- (void)handleServerRetire:(NSNotification *)notification
{
	NSString *retiringUUID = [[SyphonNameboundClient serverInfoFromNotification:notification] objectForKey:SyphonServerDescriptionUUIDKey];
	NSString *ourUUID = [[_client serverDescription] objectForKey:SyphonServerDescriptionUUIDKey];
	
	if ([retiringUUID isEqualToString:ourUUID])
	{
		[self setClientFromSearchHavingLock:NO];
	}
}

@end
