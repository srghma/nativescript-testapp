const favicons = require('favicons')

exports._favicons = function(buffer) {
  return function(config) {
    return function (onError, onSuccess) {
      favicons(buffer, config, function (err, res) {
        if (err) {
          onError(err)
        } else {
          onSuccess(res)
        }
      })

      return function (cancelError, onCancelerError, onCancelerSuccess) {
        onCancelerSuccess();
      };
    };
  }
}
