EddieFirmware
=============

Eddie firmware for both the original Eddie Control Board and the Propeller Activity Board.

If you're using the original Eddie Control Board, download the archive "Eddie - Archive [Date ...."
If you're using a Propeller Activity Board with HB-25 motor controllers then download "EddieActivityBoard - Archive [Date ...."
Unzip the archive in an appropriate folder. After installing the Propeller Tool or other programming environment capable of compiling Spin code, double click the top object of the archive. The top object will either be "Eddie.spin" or "EddieActivityBoard.spin" depending on which archive you downloaded.
Press F11 to load the program into your board's EEPROM. The robot should then be ready to receive commands as explained in the comments of the top object. Additional instructions are available from Eddie Wiki.
http://wiki.ros.org/eddiebot
The GitHub link at on the Wiki points to the old version of the firmware. I need to figure out how to get this link updated.

The file "Eddie.spin" is the top object of the code for use with the original Eddie control board. 
The file "EddieActivityBoard.spin" is for use when a robot is to be controlled with a Propeller Activity Board.
The Eddie firmware was modified as part of the Open Propeller Project #8. For more information about this project see the following thread in the Parallax forums.
http://forums.parallax.com/showthread.php/158030
The two different top objects share most of the same child objects. The main exception is the header file. The "Eddie.spin" file uses the header file "HeaderEddieHbridgeEncoders.spin" and the "EddieActivityBoard.spin" oject uses the header file "HeaderEddieAbHb25Encoders."
The two different header files contain objects which are not shared amoung the two versions of firmware.
