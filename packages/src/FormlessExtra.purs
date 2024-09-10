module Halogen.Hooks.FormlessExtra where

import Protolude
import Halogen.Hooks.Formless as F

isErrorFormFieldResult :: forall error output. F.FormFieldResult output error -> Boolean
isErrorFormFieldResult =
  case _ of
    F.Error _ -> true
    _ -> false

mkHelperText
  :: forall output error id .
  { errorToErrorText :: error -> String
  , id :: id
  , result :: F.FormFieldResult error output
  } ->
  Maybe
  { id :: id
  , persistent :: Boolean
  , text :: String
  , validation :: Boolean
  }
mkHelperText = \config ->
   case config.result of
       F.Validating -> Just
         { id: config.id
         , persistent
         , text: "...Validating" -- TODO: slow down change using "on change: set opacity 0, change text, opacity 1"
         , validation: false
         }
       F.Error error -> Just
         { id: config.id
         , persistent
         , text: config.errorToErrorText error
         , validation: true
         }
       F.NotValidated -> Nothing
       F.Success _ -> Nothing
  where
    persistent = true
