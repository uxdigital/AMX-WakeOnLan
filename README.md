AMX-WakeOnLan
=============

Wake On Lan module to send magic packet from AMX controller

This requires Core Library functions
https://github.com/controldesigns/AMX-Core-Library.git

To use:
-------------
Send the "'SET_MAC_ADDRESS-', $FF, $FF, $FF, $FF, $FF, $FF" command to the virtual device controller
Send a 'WAKE' command to the controller to send the magic packet

Version 1.0
-------------
- Initial release
