let pageCache = undefined

exports.readPageCache = function () {
  return pageCache || []
}

// registerPage will be called at least once for each page
exports._setRegisterEventOnPageCacheBus = function (registerPage) {
  if (pageCache) { throw new Error('cannot call _setRegisterEventOnPageCacheBus several times') }

  pageCache = window.__PAGE_CACHE_BUS || []

  const new_ = {
    push: function (pageInfo) {
      pageCache.push(pageInfo)
      registerPage(pageInfo)
    }
  }

  window.__PAGE_CACHE_BUS = new_

  pageCache.map(registerPage)
}

///////////////////////

// from https://github.com/vercel/next.js/blob/eead55cbaf278dfaa4eda9d055eb1042ec5dc535/packages/next/client/page-loader.js#L7-L27

function hasRel(rel) {
  try {
    var link = document.createElement('link')
    return link.relList.supports(rel)
  } catch (_) { }
}

// when browser supports both "preload" and "prefetch" - will use "prefetch"
//
// preload:
// https://caniuse.com/#feat=link-rel-preload
// macOS and iOS (Safari does not support prefetch)
//
// prefetch:
// https://caniuse.com/#feat=link-rel-prefetch
// IE 11, Edge 12+, nearly all evergreen
exports.supportedPrefetchRel =
  hasRel('preload') && !hasRel('prefetch')
    ? 'preload'
    : 'prefetch'

