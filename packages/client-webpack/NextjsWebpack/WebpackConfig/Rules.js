exports.scssAndImagesRules = function({ production }) {
  return [
    // ...(require('webpack-spago-loader/rules')({ spagoAbsoluteOutputDir: require('../lib/spago-options').output })),

    // from https://github.com/material-components/material-components-web/blob/master/docs/getting-started.md
    {
      test: /\.scss$/i,
      use: [
        require('mini-css-extract-plugin').loader,
        {
          loader: 'css-loader',
          options: {
            modules: {
              auto: true,
              localIdentName: production ? undefined : '[path][name]__[local]',
            },
          },
        },
        { loader: 'postcss-loader' },
        {
          loader: 'sass-loader',
          options: {
            // Prefer Dart Sass
            implementation: require('sass'),

            // See https://github.com/webpack-contrib/sass-loader/issues/804
            webpackImporter: false,

            sassOptions: {
              includePaths: ['./node_modules'],
            },
          },
        },
      ]
    },

    // images
    {
      test: /\.(png|jpg|gif|svg)$/i,
      use: [
        {
          loader: 'url-loader',
          options: {
            limit: 8192,
          },
        },
      ],
    },
  ]
}
