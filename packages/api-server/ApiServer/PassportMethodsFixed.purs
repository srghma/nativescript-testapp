module ApiServer.PassportMethodsFixed where

import Node.Express.Handler
import Node.Express.Passport
import Node.Express.Types
import Protolude

import Data.Argonaut (Json)
import Data.NonEmpty (NonEmpty(..))
import Data.String.NonEmpty (NonEmptyString)
import Data.String.NonEmpty as NonEmptyString
import Data.Time.Duration (Days(..))
import Data.Time.Duration as Duration
import Database.PostgreSQL (Pool)
import Node.Express.Passport as Passport
import Node.Express.Response as Express
import PassportGithub as PassportGithub
import Type.Prelude (Proxy(..))

newtype UserUUID = UserUUID String

userUUIDToString :: UserUUID → String
userUUIDToString (UserUUID s) = s

proxyUser :: Proxy UserUUID
proxyUser = Proxy

proxyInfo :: Proxy Void
proxyInfo = Proxy

serializeUser :: Passport → (Request → UserUUID → Aff SerializedUser) → Effect Unit
serializeUser = Passport.serializeUser proxyUser

deserializeUser :: Passport → (Request → Json → Aff (DeserializedUser UserUUID)) → Effect Unit
deserializeUser = Passport.deserializeUser proxyUser

authenticate :: Passport → StrategyId → Passport.AuthenticateOptions → Maybe (Authenticate__CustomCallback Void UserUUID) → HandlerM Unit
authenticate = Passport.authenticate proxyUser proxyInfo

getUser :: Request → Effect (Maybe UserUUID)
getUser = Passport.getUser proxyUser

login :: UserUUID → Passport.LoginOptions → Request → Aff (Maybe Error)
login = Passport.login proxyUser

passportStrategyGithub :: PassportGithub.PassportStrategyGithubOptions → PassportGithub.PassportStrategyGithub__Verify UserUUID Void → PassportStrategy
passportStrategyGithub = PassportGithub.passportStrategyGithub proxyUser proxyInfo
