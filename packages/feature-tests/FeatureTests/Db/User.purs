module FeatureTests.Db.User where

import Prelude
import Foreign.Class (class Decode, class Encode)
import Foreign.Generic (defaultOptions, genericDecode, genericEncode)
import Data.Generic.Rep (class Generic)
import Data.Show.Generic (genericShow)
import Database.PostgreSQL
import Data.Either
import Data.Array

newtype UserID
  = UserID Int

derive newtype instance showUserID :: Show UserID
derive instance genericUserID :: Generic UserID _
derive newtype instance decodeUserID :: Decode UserID
derive newtype instance encodeUserID :: Encode UserID

newtype User
  = User
  { id :: UserID
  , name :: String
  }

derive instance genericUser :: Generic User _

instance showUser :: Show User where
  show = genericShow

instance decodeUser :: Decode User where
  decode = genericDecode $ defaultOptions { unwrapSingleConstructors = true }

instance encodeUser :: Encode User where
  encode = genericEncode $ defaultOptions { unwrapSingleConstructors = true }

instance userFromSQLRow :: FromSQLRow User where
  fromSQLRow [ id, name ] = User <$> ({ id: _, name: _ } <$> (map UserID $ fromSQLValue id) <*> fromSQLValue name)
  fromSQLRow xs = Left $ "Row has " <> show (length xs) <> " fields, expecting 2."

instance userToSQLRow :: ToSQLRow User where
  toSQLRow (User { id: UserID id, name }) = [ toSQLValue id, toSQLValue name ]
