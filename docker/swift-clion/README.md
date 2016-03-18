#### Container provides a CLion-based development environment for Swift on Ubuntu 15.10.

It consists of:
1. Dependencies for Swift for Linux and swift-corelibs-libdispatch
2. Swift for Linux (currently swift-DEVELOPMENT-SNAPSHOT-2016-03-01-a)
3. swift-corelibs-libdispatch
4. Jetbrains IDE: CLion-145.256.37 (2016.1 RC) EAP (with Open JDK 8)
5. Jetbrains Swift plugin for CLion-145.256.37 EAP
6. VNC (x11vnc)

On launch, the default configuration ensures that:
1. VNC is started in foreground mode and keeps the container running.
2. CLion is started when VNC client connects.

**The password to VNC is 1234.** 
**Port is 5900, please remember to expose it on run.**
**The actual project to work on should be linked as volume from outside the container.**
