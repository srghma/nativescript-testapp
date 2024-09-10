var webdriver = require("selenium-webdriver")
var chrome = require('selenium-webdriver/chrome')

function cancelNoop(_cancelError, cancelerError, cancelerSuccess) {
  cancelerSuccess()
}

// TODO: use nonCanceller function?
exports._buildSeleniumChromeDriver = function(chromedriverPath, chromeBinaryPath, remoteDownloadDir) {
  return function(onError, onSuccess) {
    // var chromeCapabilities = webdriver.Capabilities.chrome()

    // https://stackoverflow.com/a/27733960/3574379
    var service = new chrome.ServiceBuilder(chromedriverPath).build()

    chrome.setDefaultService(service)

    var chromeOptions = new chrome.Options()

    // chromeOptions.options_["debuggerAddress"] = "127.0.0.1:9222"

    chromeOptions.setChromeBinaryPath(chromeBinaryPath)

    chromeOptions.addArguments(
      // disable chrome's wakiness
      'disable-infobars',
      'disable-extensions',

      // allow http
      'disable-web-security',

      // other
      'lang=en',
      'no-default-browser-check',
      'no-sandbox'

      // not working
      // 'start-maximized',
    )

    chromeOptions.setUserPreferences({
      // disable chrome's annoying password manager
      'profile.password_manager_enabled': false,
      credentials_enable_service:         false,
      password_manager_enabled:           false,
      download: {
        default_directory:   remoteDownloadDir,
        prompt_for_download: false,
        directory_upgrade:   true,
        extensions_to_open:  '',
      },
      plugins: {
        plugins_disabled: ['Chrome PDF Viewer'], // disable viewing pdf files after download
      },
    })

    var builder = new webdriver.Builder()

    builder.setChromeOptions(chromeOptions)

    builder.forBrowser('chrome')

    var driver = builder.build()

    driver.then(onSuccess, onError)

    return cancelNoop
  }
}
