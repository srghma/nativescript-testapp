module Cordova.EventTypes.Battery where

import Web.Event.Event (EventType(..))

batterycritical :: EventType
batterycritical = EventType "batterycritical"

batterylow :: EventType
batterylow = EventType "batterylow"

batterystatus :: EventType
batterystatus = EventType "batterystatus"
