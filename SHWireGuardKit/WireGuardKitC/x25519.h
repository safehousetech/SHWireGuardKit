//
//  x25519.h
//  SHWireGuardKit
//
//  Created by Abhishek Choudhary on 26/12/23.
//

#ifndef X25519_H
#define X25519_H

void curve25519_derive_public_key(unsigned char public_key[32], const unsigned char private_key[32]);
void curve25519_generate_private_key(unsigned char private_key[32]);

#endif
