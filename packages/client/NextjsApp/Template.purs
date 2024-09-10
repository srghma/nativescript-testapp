module NextjsApp.Template where

import Protolude
import Data.String.Yarn (unlines) as String
import Data.String.Common (joinWith) as String
import SimpleXMLWithIndentation as SimpleXMLWithIndentation
import Data.Array as Array

data TargetData
  = TargetData__Mobile
  | TargetData__Server
    { prerenderedHtml :: String
    , prerenderedPagesManifest :: String
    , prerenderedPageData :: Maybe String
    , livereloadPort :: Maybe Int
    , faviconsHtml :: Array String
    }

type TemplateConfig
  = { title :: String
    , targetData :: TargetData
    , headTags :: Array String
    , bodyTags :: Array String
    }

template :: TemplateConfig -> String
template { targetData, title, headTags, bodyTags } =
  let
    meta = case targetData of
      TargetData__Server _ -> """<meta name="viewport" content="initial-scale=1,width=device-width"/>"""
      TargetData__Mobile ->
        let
          cordovaSecurityPolicyContent =
            -- Customize this policy to fit your own app's needs. For more guidance, see:
            --     https://github.com/apache/cordova-plugin-whitelist/blob/master/README.md#content-security-policy
            -- Some notes:
            --     * gap: is required only on iOS (when using UIWebView) and is needed for JS->native communication
            --     * https://ssl.gstatic.com is required only on Android and is needed for TalkBack to function properly
            --     * Disables use of inline scripts in order to mitigate risk of XSS vulnerabilities. To change this:
            --         * Enable inline JS: add 'unsafe-inline' to default-src
            String.joinWith "; "
              [ "default-src 'self' data: gap: https://ssl.gstatic.com 'unsafe-eval'"
              , "style-src 'self' 'unsafe-inline'"
              , "media-src *"
              , "img-src 'self' data: content:"
              , "connect-src *" -- connect-src * allows to fetch() any url
              ]

          cordovaSecurityPolicy = "<meta http-equiv=\"Content-Security-Policy\" content=\"" <> cordovaSecurityPolicyContent <> "\">"
        in
          String.unlines
            [ cordovaSecurityPolicy
            , """<meta name="format-detection" content="telephone=no">"""
            , """<meta name="msapplication-tap-highlight" content="no">"""
            , """<meta name="viewport" content="initial-scale=1,width=device-width,viewport-fit=cover">"""
            ]
  in
    String.unlines
      [ "<!DOCTYPE html>"
      , SimpleXMLWithIndentation.tagMultiLine "html" []
          [ SimpleXMLWithIndentation.tagMultiLine "head" []
              $ [ meta
                , """<meta charset="utf-8"/>"""
                , SimpleXMLWithIndentation.tagOneline "title" [] title
                , """<link href="https://fonts.googleapis.com/css?family=Roboto:300,400,500" rel="stylesheet">"""
                , """<link href="https://fonts.googleapis.com/css?family=Material+Icons&display=block" rel="stylesheet">"""
                ]
              <> Array.catMaybes
                  [ case targetData of
                      TargetData__Server { livereloadPort } ->
                        flip map livereloadPort \livereloadPort' ->
                          """<script src="http://localhost:""" <> show livereloadPort' <> """/reload/reload.js"></script>"""
                      TargetData__Mobile -> Nothing
                  ]
              <> case targetData of
                  TargetData__Server { faviconsHtml } -> faviconsHtml
                  TargetData__Mobile -> []
              <> headTags
          , SimpleXMLWithIndentation.tagMultiLine "body" [ "class" /\ "mdc-typography mdc-theme--background" ]
              $ [ SimpleXMLWithIndentation.tagOneline "div" [ "id" /\ "root" ]
                    $ case targetData of
                        TargetData__Server serverData -> serverData.prerenderedHtml
                        TargetData__Mobile -> ""
                , case targetData of
                    TargetData__Server serverData ->
                      String.unlines
                        [ """<script id="__PAGES_MANIFEST__" type="application/json">""" <> serverData.prerenderedPagesManifest <> "</script>"
                        , case serverData.prerenderedPageData of
                            Nothing -> ""
                            Just prerenderedPageData -> """<script id="__PAGE_DATA__" type="application/json">""" <> prerenderedPageData <> "</script>"
                        ]
                    TargetData__Mobile -> """<script type="text/javascript" src="cordova.js"></script>"""
                ]
              <> bodyTags
          ]
      ]
