//
//  SHWireGuardKit.h
//  SHWireGuardKit
//
//  Created by Alon Blayer-Gat on 18/05/2023.
//

#ifndef SHWireGuardKit_h
#define SHWireGuardKit_h


// Note from ABG 2023-05-23
// The required headers from the WireGuard project to make SHWireGuardKit
// self contained and portable have the imported specifically in the way it is done below
// and all the headers need to be publically exposed in SHWireGuardKit so that the
// importing app can use them
#import "SHWireGuardKit/WireGuardKitC.h"
#import <SHWireGuardKit/wireguard.h>
#import <SHWireGuardKit/ringlogger.h>
#import <SHWireGuardKit/key.h>
#import <SHWireGuardKit/x25519.h>

typedef void(*logger_fn_t)(void *context, int level, const char *msg);
extern void wgSetLogger(void *context, logger_fn_t logger_fn);
extern int wgTurnOn(const char *settings, int32_t tun_fd);
extern void wgTurnOff(int handle);
extern int64_t wgSetConfig(int handle, const char *settings);
extern char *wgGetConfig(int handle);
extern void wgBumpSockets(int handle);
extern void wgDisableSomeRoamingForBrokenMobileSemantics(int handle);
extern const char *wgVersion();

#endif /* SHWireGuardKit_h */




