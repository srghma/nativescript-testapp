module FeatureTests.ChromeLunaparkOptions where

import Protolude

import Lunapark as Lunapark
import Lunapark.Types as Lunapark
import FeatureTests.Config as Config
import Unsafe.Coerce

chromeLunaparkOptions :: Config.Config -> Lunapark.CapabilitiesRequest
chromeLunaparkOptions config =
  { alwaysMatch:
    -- based on https://www.w3.org/TR/webdriver1/ "Example 5"
    -- chrome:browserOptions
    [ Lunapark.CustomCapability "goog:chromeOptions" $ unsafeCoerce
      { "binary": config.chromeBinaryPath
      -- | , "debuggerAddress": "127.0.0.1:9222"
      , "args":
        -- disable chrome's wakiness
        [ "--disable-infobars"
        , "--disable-extensions"

        -- allow http
        , "--disable-web-security"

        -- other
        , "--lang=en"
        , "--no-default-browser-check"
        , "--no-sandbox"
        , "--user-data-dir=" <> config.chromeUserDataDirPath
        , "--profile-directory=tester"

        -- CTRL-SHIFT-D to change dock placement
        , "--auto-open-devtools-for-tabs"

        -- not working
        , "--start-maximized"
        ]
      , "prefs":
        -- disable chrome's annoying password manager
        { "profile.password_manager_enabled": false
        , "credentials_enable_service":         false
        , "password_manager_enabled":           false
        , "download":
          { "default_directory":   config.remoteDownloadDirPath
          , "prompt_for_download": false
          , "directory_upgrade":   true
          , "extensions_to_open":  ""
          }
        , "plugins": { "plugins_disabled": ["Chrome PDF Viewer"] } -- disable viewing pdf files after download
        }
      }
    ]
  , firstMatch:
    [ [ Lunapark.BrowserName Lunapark.Chrome
      ]
    ]
  }

