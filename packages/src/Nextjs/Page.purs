module Nextjs.Page where

import Protolude

import Affjax as Affjax
import Affjax.RequestHeader as Affjax
import Data.Argonaut.Core as ArgonautCore
import Data.Argonaut.Decode (class DecodeJson, JsonDecodeError, decodeJson) as ArgonautCodecs
import Data.Argonaut.Encode (class EncodeJson, encodeJson) as ArgonautCodecs
import GraphQLClient as GraphQLClient
import Halogen as Halogen
import NextjsApp.AppM (AppM)
import Unsafe.Coerce (unsafeCoerce)
import Web.XHR.XMLHttpRequest (withCredentials)
import NextjsApp.Route as NextjsApp.Route

-- in next.js pages have be 3 types
-- | λ  (Server)  server-side renders at runtime (uses getInitialProps or getServerSideProps)
-- | ○  (Static)  automatically rendered as static HTML (uses no initial props)
-- | ●  (SSG, server site generated)     automatically generated as static HTML + JSON (uses getStaticProps)

data PageData_DynamicRequestOptions
  = PageData_DynamicRequestOptions__Server { sessionHeader :: Maybe (Tuple String String) } -- session header from cookie
  | PageData_DynamicRequestOptions__Client -- should map to { withCredentials = true }
  | PageData_DynamicRequestOptions__Mobile { sessionHeader :: Maybe (Tuple String String) } -- session header from secure storage

pageData_DynamicRequestOptions__To__RequestOptions :: PageData_DynamicRequestOptions -> GraphQLClient.RequestOptions
pageData_DynamicRequestOptions__To__RequestOptions =
  case _ of
       PageData_DynamicRequestOptions__Server { sessionHeader } -> sessionHeaderToHeaders sessionHeader
       PageData_DynamicRequestOptions__Client -> GraphQLClient.defaultRequestOptions { withCredentials = true }
       PageData_DynamicRequestOptions__Mobile { sessionHeader } -> sessionHeaderToHeaders sessionHeader

  where
    sessionHeaderToHeaders =
      case _ of
           Just (Tuple sessionHeaderKey sessionHeaderValue) -> GraphQLClient.defaultRequestOptions { headers = [Affjax.RequestHeader sessionHeaderKey sessionHeaderValue] }
           Nothing -> GraphQLClient.defaultRequestOptions

data PageData_DynamicResponse routes input
  = PageData_DynamicResponse__Error String -- TODO: add purs-hyper response status?
  | PageData_DynamicResponse__Redirect
    { redirectToLocation :: Variant routes
    , logout :: Boolean
    }
  | PageData_DynamicResponse__Success input

data PageData routes input
  = PageData__Dynamic
    { request :: PageData_DynamicRequestOptions -> Aff (PageData_DynamicResponse routes input)
    , codec :: PageData_DynamicCodec input
    }
  | PageData__Static input
  -- | | ServerLoadedPageData (Aff input) -- TODO?

-- on server - used decoder
-- on client - used encoder (on first page load) OR nothing is used
-- on mobile - nothing is used
type PageData_DynamicCodec a
  = { encoder :: a -> ArgonautCore.Json
    , decoder :: ArgonautCore.Json -> Either ArgonautCodecs.JsonDecodeError a
    }

mkPageData_DynamicCodec ::
  forall input.
  ArgonautCodecs.EncodeJson input =>
  ArgonautCodecs.DecodeJson input =>
  PageData_DynamicCodec input
mkPageData_DynamicCodec = { encoder: ArgonautCodecs.encodeJson, decoder: ArgonautCodecs.decodeJson }

type PageSpecRows routes m input
  = ( pageData :: PageData routes input
    , component :: Halogen.Component (Const Void) input Void m
    , title :: String
    )

type PageSpec routes m input
  = Record (PageSpecRows routes m input)

newtype PageSpecBoxed routes m
  = PageSpecBoxed (forall input. PageSpec routes m input)

mkPageSpecBoxed ::
  forall input routes m.
  ArgonautCodecs.EncodeJson input =>
  ArgonautCodecs.DecodeJson input =>
  PageSpec routes m input ->
  PageSpecBoxed routes m
mkPageSpecBoxed = unsafeCoerce

unPageSpecBoxed ::
  forall r routes m.
  (forall input. PageSpec routes m input -> r) ->
  PageSpecBoxed routes m ->
  r
unPageSpecBoxed f (PageSpecBoxed r) = f r

---------------
type PageSpecWithInput m input
  = { input :: input
    , component :: Halogen.Component (Const Void) input Void m
    , title :: String
    }

newtype PageSpecWithInputBoxed m
  = PageSpecWithInputBoxed (forall input. PageSpecWithInput m input)

mkPageSpecWithInputBoxed ::
  forall input m.
  PageSpecWithInput m input ->
  PageSpecWithInputBoxed m
mkPageSpecWithInputBoxed = unsafeCoerce

unPageSpecWithInputBoxed ::
  forall r m.
  (forall input. PageSpecWithInput m input -> r) ->
  PageSpecWithInputBoxed m ->
  r
unPageSpecWithInputBoxed f (PageSpecWithInputBoxed r) = f r

data PageSpecBoxed_To_PageSpecWithInputBoxed_Response routes m
  = PageSpecBoxed_To_PageSpecWithInputBoxed_Response__Error String
  | PageSpecBoxed_To_PageSpecWithInputBoxed_Response__Success (PageSpecWithInputBoxed m)
  | PageSpecBoxed_To_PageSpecWithInputBoxed_Response__Redirect
    { redirectToLocation :: Variant routes
    -- on client - ignored
    -- on server - Set-Cookie sessionId "" is set
    -- on mobile - jwt is removed from secure storage
    , logout :: Boolean
    }

pageSpecBoxed_to_PageSpecWithInputBoxed_request
  :: forall routes m
   . PageData_DynamicRequestOptions
  -> PageSpecBoxed routes m
  -> Aff (PageSpecBoxed_To_PageSpecWithInputBoxed_Response routes m)
pageSpecBoxed_to_PageSpecWithInputBoxed_request requestOptions =
  unPageSpecBoxed
    ( \page ->
        case page.pageData of
             PageData__Dynamic { request } ->
               request requestOptions
                 <#> case _ of
                         PageData_DynamicResponse__Error error -> PageSpecBoxed_To_PageSpecWithInputBoxed_Response__Error error
                         PageData_DynamicResponse__Redirect x -> PageSpecBoxed_To_PageSpecWithInputBoxed_Response__Redirect x
                         PageData_DynamicResponse__Success input ->
                           PageSpecBoxed_To_PageSpecWithInputBoxed_Response__Success
                           $ mkPageSpecWithInputBoxed
                             { input
                             , component: page.component
                             , title: page.title
                             }
             PageData__Static input ->
               pure
               $ PageSpecBoxed_To_PageSpecWithInputBoxed_Response__Success
               $ mkPageSpecWithInputBoxed
                 { input
                 , component: page.component
                 , title: page.title
                 }
    )

pageSpecBoxed_to_PageSpecWithInputBoxed_givenInitialJson
  :: forall routes m
   . Aff ArgonautCore.Json
  -> PageSpecBoxed routes m
  -> Aff (Either ArgonautCodecs.JsonDecodeError (PageSpecWithInputBoxed m))
pageSpecBoxed_to_PageSpecWithInputBoxed_givenInitialJson loadJson =
  unPageSpecBoxed
    ( \page ->
        case page.pageData of
          PageData__Dynamic { codec } -> do
            loadJson
            <#> \json -> codec.decoder json
            <#> \input ->
              mkPageSpecWithInputBoxed
                { input
                , component: page.component
                , title: page.title
                }
          PageData__Static input ->
            pure $ Right $ mkPageSpecWithInputBoxed
                  { input
                  , component: page.component
                  , title: page.title
                  }
    )
