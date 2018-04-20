# Java Install

Install Java Development Kit on workstation.

1. Download Java SE Development Kit (JDK) installation from [java.oracle.com](https://java.oracle.com/), e.g. "jdk-8u112-windows-x64.exe"
1. Execute the file.<br />![Java SDK - Setup](.\JavaSDK.setup.png)
   1. Change the path away fra "C:\Program Files\", e.g. "C:\Java\jdk1.8.0_112"<br />![Java SDK - Custom Setup](.\JavaSDK.custom-setup.png)
   1. Also change the destination folder for Java Runtime Engine (JRE) away from "C:\Program Files\". You can not use the same folder as given to JDK above, e.g. "C:\Java\jre1.8.0_112".<br />![Java Setup - Destination Folder](.\JavaJRE.destination.png)
1. If you choose to click "Next steps" you will get a web page on the internet with a lot of different links to Java tools and documentation.<br />![Java SDK - Complete](.\JavaSDK.complete.png)

If you install JDK on a server like a build server you should place it on a different drive than the system drive (C-drive).
