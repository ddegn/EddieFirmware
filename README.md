EddieFirmware
=============

Eddie firmware for both the original Eddie control board and the Propeller Activity Board.

The file "Eddie.spin" is the top object of the code for use with the original Eddie control board. 
The file "EddieActivityBoard.spin" is for use when a robot is to be controlled with a Propeller Activity Board.
The Eddie firmware was modified as part of the Open Propeller Project #8. For more information about this project see the following thread in the Parallax forums.
http://forums.parallax.com/showthread.php/158030
The two different top objects share most of the same child objects. The main exception is the header file. The "Eddie.spin" file uses the header file "HeaderEddieHbridgeEncoders.spin" and the "EddieActivityBoard.spin" oject uses the header file "HeaderEddieAbHb25Encoders".
The two different header files contain objects which are not shared amoung the two versions of firmware.
