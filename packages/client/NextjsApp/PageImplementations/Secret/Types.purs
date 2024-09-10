module NextjsApp.PageImplementations.Secret.Types where

import Protolude
import Data.Argonaut (class DecodeJson, class EncodeJson)
import Data.Argonaut.Decode.Generic (genericDecodeJson)
import Data.Argonaut.Encode.Generic (genericEncodeJson)

newtype SecretPageUserData = SecretPageUserData
  { id :: String
  , name :: Maybe String
  , username :: String
  }

derive instance genericSecretPageUserData :: Generic SecretPageUserData _

instance encodeJsonSecretPageUserData :: EncodeJson SecretPageUserData where
  encodeJson = genericEncodeJson

instance decodeJsonSecretPageUserData :: DecodeJson SecretPageUserData where
  decodeJson = genericDecodeJson
