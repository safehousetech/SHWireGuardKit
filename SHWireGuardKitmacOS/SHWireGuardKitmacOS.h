//
//  SHWireGuardKitmacOS.h
//  SHWireGuardKitmacOS
//
//  Created by Alon Blayer-Gat on 18/05/2023.
//

#import <Foundation/Foundation.h>

//! Project version number for SHWireGuardKit.
FOUNDATION_EXPORT double SHWireGuardKitVersionNumber;

//! Project version string for SHWireGuardKit.
FOUNDATION_EXPORT const unsigned char SHWireGuardKitVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <SHWireGuardKit/PublicHeader.h>

// Note from ABG 2023-05-23
// The required headers from the WireGuard project to make GRDWireGuardKit
// self contained and portable have the imported specifically in the way it is done below
// and all the headers need to be publically exposed in GRDWireGuardKit so that the
// importing app can use them
#import "SHWireGuardKitmacOS/WireGuardKitC.h"
#import <SHWireGuardKitmacOS/wireguard.h>
#import <SHWireGuardKitmacOS/ringlogger.h>
#import <SHWireGuardKitmacOS/key.h>
#import <SHWireGuardKitmacOS/x25519.h>
