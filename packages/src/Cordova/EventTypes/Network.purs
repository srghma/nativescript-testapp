module Cordova.EventTypes.Network where

import Web.Event.Event (EventType(..))

online :: EventType
online = EventType "online"

offline :: EventType
offline = EventType "offline"
