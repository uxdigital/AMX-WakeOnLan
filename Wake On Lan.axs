MODULE_NAME='Wake On Lan' (DEV controllerDevice, DEV ipDevice)
(*******************************************************************************)
(*                                                                             *)
(*     _____            _              _  ____             _                   *)
(*    |     | ___  ___ | |_  ___  ___ | ||    \  ___  ___ |_| ___  ___  ___    *)
(*    |   --|| . ||   ||  _||  _|| . || ||  |  || -_||_ -|| || . ||   ||_ -|   *)
(*    |_____||___||_|_||_|  |_|  |___||_||____/ |___||___||_||_  ||_|_||___|   *)
(*                                                           |___|             *)
(*                                                                             *)
(*                   © Control Designs Software Ltd (2012)                     *)
(*                         www.controldesigns.co.uk                            *)
(*                                                                             *)
(*      Tel: +44 (0)1753 208 490     Email: support@controldesigns.co.uk       *)
(*                                                                             *)
(*******************************************************************************)
(*                                                                             *)
(*            Written by Mike Jobson (Control Designs Software Ltd)            *)
(*                                                                             *)
(** REVISION HISTORY ***********************************************************)
(*                                                                             *)
(*  v1.0 (release) 29/11/13                                                    *)
(*  Add release info here!                                                     *)
(*      -----------------------------------------------------------------      *)
(*  v1.0 (beta)                                                                *)
(*  First release - Currently in beta development                              *)
(*                                                                             *)
(*******************************************************************************)
(*                                                                             *)
(*  Permission is hereby granted, free of charge, to any person obtaining a    *)
(*  copy of this software and associated documentation files (the "Software"), *)
(*  to deal in the Software without restriction, including without limitation  *)
(*  the rights to use, copy, modify, merge, publish, distribute, sublicense,   *)
(*  and/or sell copies of the Software, and to permit persons to whom the      *)
(*  Software is furnished to do so, subject to the following conditions:       *)
(*                                                                             *)
(*  The above copyright notice and this permission notice and header shall     *)
(*  be included in all copies or substantial portions of the Software.         *)
(*                                                                             *)
(*  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS    *)
(*  OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF                 *)
(*  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.     *)
(*  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY       *)
(*  CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT  *)
(*  OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR   *)
(*  THE USE OR OTHER DEALINGS IN THE SOFTWARE.                                 *)
(*                                                                             *)
(*******************************************************************************)

(*******************************************************************************)
(*  IMPORT CORE LIBRARY HERE                                                   *)
(*  This is includes generic functions and code which can be re-used in main   *)
(*  and other modules. Also includes 'SNAPI' and some add-on functions.        *)
(*                                                                             *)
(*  This is an open source library available from:                             *)
(*  https://github.com/controldesigns/AMX-Core-Library.git                     *)
(*                                                                             *)
(*******************************************************************************)
#DEFINE CORE_LIBRARY
//#DEFINE DEBUG
#INCLUDE 'Core Library'
#INCLUDE 'Core Debug'
#INCLUDE 'SNAPI'


DEFINE_VARIABLE

SINTEGER connectionStatus = 99

CHAR macAddressString[20]
INTEGER header[] = { $FF, $FF, $FF, $FF, $FF, $FF }

DEFINE_FUNCTION OpenSocket() {
    connectionStatus = IP_CLIENT_OPEN(ipDevice.port, '255.255.255.255', 2304, IP_UDP)
}

DEFINE_FUNCTION SendWake() {
    if(connectionStatus == 0) {
	SEND_STRING ipDevice, "header, macAddressString, macAddressString, macAddressString, macAddressString,
			    macAddressString, macAddressString, macAddressString, macAddressString, macAddressString,
			    macAddressString, macAddressString, macAddressString, macAddressString, macAddressString,
			    macAddressString, macAddressString"
    } else {
	OpenSocket()
    }
}

(*******************************************************************************)
(*  DEFINE STARTUP CODE HERE                                                   *)
(*******************************************************************************)
DEFINE_START {
    OpenSocket()
}


(*******************************************************************************)
(*  DEFINE EVENT CODE AFTER HERE                                               *)
(*******************************************************************************)
DEFINE_EVENT

DATA_EVENT[ipDevice] {
    ONLINE: {
	
    }
    OFFLINE: {
	connectionStatus = 99
	IP_CLIENT_CLOSE(ipDevice.port)
	OpenSocket()
    }
}

DATA_EVENT[controllerDevice] {
    COMMAND: {
	STACK_VAR _SNAPI_DATA snapi
	
	SNAPI_InitDataFromString(snapi, data.text)
	
	switch(snapi.cmd) {
	    case 'SET_MAC_ADDRESS': {
		macAddressString = snapi.param[1]
	    }
	    case 'WAKE': {
		SendWake()
	    }
	}
    }
}

(*******************************************************************************)
(*  DEFINE MAIN PROGRAM LOOP HERE                                              *)
(*******************************************************************************)
DEFINE_PROGRAM 