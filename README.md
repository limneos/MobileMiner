# MobileMiner
CPU Miner for ARM64 iOS Devices

This is a fork of Lucas Jones's cpuminer-multi, ( https://github.com/lucasjones/cpuminer-multi ) compiled for arm64 iOS devices. Credits go to the initial developers and contributors.

# Compiled iOS App
http://www.mediafire.com/file/f6qzt8jv26wtqm6/MobileMiner.ipa


# Changes

1) The change needed is in cpu-miner.c, where 
        
        int main(int argc, char *arv[])    

has been changed to 
        
    start_mining(int argc,char *argv[])
        
in order for it to compile as a library.

Then you can import the library in an Xcode project and use 

    char *args[]= {path, "-a","cryptonight","-o","url","-u","userAdrress","-p","x"};
    
    start_mining((int)(sizeof(args)/sizeof(char *))-1,args);
    
if you want to keep the same argument formatting and parsing.


2) In order for notifications to be received in the UI, instead of reading from stderr, I am posting notifications from inside cpu-miner.c passing the log message to the UI.

3) I have added a throttle in submit_upstream_work in order to maintain the speed in reasonable limits, since I noticed that some pools might ban you if a) the pool has small startup diff b) the device can cope well at first with this diff and sends hashes very fast.

4) I've added -x objective-c in the Makefile in order to compile with objc.

5) Included necessary CoreFoundation framework for the C functions.

6) In the case of the program being loaded as a library, flags need to be set inside threads in order to be able to stop them, because we don't want them to exit the main thread when done (although its faster to kill and restart the app if you're caught in a processing miner thread)

# Dependencies

Jansson
https://github.com/akheron/jansson

curl for iOS
https://github.com/sinofool/build-libcurl-ios

openssl for iOS
https://github.com/x2on/OpenSSL-for-iPhone



# Instructions

- Compile c files (cpuminer project files) for target arm64
- After compile, run 
                
                ar cru minerd.a minerd-cpu-miner.o minerd-util.o minerd-sha2.o minerd-scrypt.o minerd-keccak.o minerd-heavy.o minerd-quark.o minerd-skein.o minerd-ink.o minerd-blake.o minerd-cryptonight.o minerd-fresh.o minerd-x11.o minerd-x13.o minerd-x14.o minerd-x15.o sha3/minerd-sph_keccak.o sha3/minerd-sph_hefty1.o sha3/minerd-sph_groestl.o sha3/minerd-sph_skein.o sha3/minerd-sph_bmw.o sha3/minerd-sph_jh.o sha3/minerd-sph_shavite.o sha3/minerd-sph_blake.o sha3/minerd-sph_luffa.o sha3/minerd-sph_cubehash.o sha3/minerd-sph_simd.o sha3/minerd-sph_echo.o sha3/minerd-sph_hamsi.o sha3/minerd-sph_fugue.o sha3/minerd-sph_shabal.o sha3/minerd-sph_whirlpool.o crypto/minerd-oaes_lib.o crypto/minerd-c_keccak.o crypto/minerd-c_groestl.o crypto/minerd-c_blake256.o crypto/minerd-c_jh.o crypto/minerd-c_skein.o crypto/minerd-hash.o crypto/minerd-aesb.o   minerd-sha2-arm.o minerd-scrypt-arm.o minerd-aesb-arm.o crypto/minerd-aesb-x86-impl.o

- This will create a "minerd.a" library. Drag minerd.a in Xcode

- Compile openssl for iOS and drag libcrypto.a in Xcode project
- Compile jansson for iOS and drag libjansson.a to Xcode project
- Compile Curl for iOS and drag libcurl.a to Xcode project
- (If you're having problems compiling or prefer precompiled binaries of the cpuminer project and dependencies , I am alternatively including them in Precompiled Binaries folder, just drag them in the Xcode project.)
        
        Other Flags: -all_load 

- Compile Xcode project and run 



