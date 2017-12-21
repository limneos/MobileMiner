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


Compile with -march=arm64

 
