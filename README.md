# MobileMiner
CPU Miner for ARM64 iOS Devices

This is a fork of LucasJones's cpuminer-multi, ( https://github.com/lucasjones/cpuminer-multi ) compiled for arm64 iOS devices

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


  

