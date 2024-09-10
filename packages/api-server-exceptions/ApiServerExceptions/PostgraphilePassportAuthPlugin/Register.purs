module ApiServerExceptions.PostgraphilePassportAuthPlugin.Register where

import Database.PostgreSQL

import Data.Maybe (Maybe(..))
import Effect.Exception (Error)
import Foreign (MultipleErrors)

data WebRegisterExceptionsServer
  = WebRegisterExceptionsServer__Internal__CannotDecodeInput MultipleErrors
  | WebRegisterExceptionsServer__Internal__CannotCreateDbConnect PGError
  | WebRegisterExceptionsServer__Internal__RegisterFailed PGError -- internal???
  | WebRegisterExceptionsServer__Internal__Register__ExpectedArrayWith1Elem
  | WebRegisterExceptionsServer__RegisterFailed
  | WebRegisterExceptionsServer__Internal__SetId PGError
  | WebRegisterExceptionsServer__Internal__PassportRegisterError Error
  | WebRegisterExceptionsServer__Internal__Output__ExpectedArrayWith1Elem

data WebRegisterExceptionsClient
  = WebRegisterExceptionsClient__Internal
  | WebRegisterExceptionsClient__RegisterFailed

webRegisterExceptionsServer__to__WebRegisterExceptionsClient :: WebRegisterExceptionsServer -> WebRegisterExceptionsClient
webRegisterExceptionsServer__to__WebRegisterExceptionsClient =
  case _ of
       WebRegisterExceptionsServer__Internal__CannotDecodeInput multipleErrors -> WebRegisterExceptionsClient__Internal
       WebRegisterExceptionsServer__Internal__CannotCreateDbConnect pGError    -> WebRegisterExceptionsClient__Internal
       WebRegisterExceptionsServer__Internal__RegisterFailed pGError              -> WebRegisterExceptionsClient__Internal
       WebRegisterExceptionsServer__Internal__Register__ExpectedArrayWith1Elem    -> WebRegisterExceptionsClient__Internal
       WebRegisterExceptionsServer__RegisterFailed                                -> WebRegisterExceptionsClient__RegisterFailed
       WebRegisterExceptionsServer__Internal__SetId pGError                    -> WebRegisterExceptionsClient__Internal
       WebRegisterExceptionsServer__Internal__PassportRegisterError error         -> WebRegisterExceptionsClient__Internal
       WebRegisterExceptionsServer__Internal__Output__ExpectedArrayWith1Elem   -> WebRegisterExceptionsClient__Internal

webRegisterExceptionsClientToString :: WebRegisterExceptionsClient -> String
webRegisterExceptionsClientToString =
  case _ of
       WebRegisterExceptionsClient__Internal -> "internal_error"
       WebRegisterExceptionsClient__RegisterFailed -> "register_failed"

webRegisterExceptionsClientFromString :: String -> Maybe WebRegisterExceptionsClient
webRegisterExceptionsClientFromString =
  case _ of
       "internal_error" -> Just WebRegisterExceptionsClient__Internal
       "register_failed" -> Just WebRegisterExceptionsClient__RegisterFailed
       _ -> Nothing
