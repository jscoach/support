var path = require('path')
var ExtractTextPlugin = require('extract-text-webpack-plugin')

var config = {
  // The base path used to resolve entry points
  context: path.join(__dirname, '../', '../')
}

config.entry = {
  app: './app/frontend/entry.jsx',
  accounts: './app/frontend/accounts.js'
}

// We override some of these in the production config, to support
// writing out bundles with digests in their filename
config.output = {
  // If the webpack code-splitting feature is enabled, this is the path it'll use to download bundles
  publicPath: '/assets'
}

config.resolve = {
  // Tell webpack which extensions to auto search when it resolves modules. With this,
  // you'll be able to do `require('./utils')` instead of `require('./utils.js')`
  extensions: ['', '.js']
  // By default, webpack will search in `web_modules` and `node_modules`
  // modulesDirectories: [ ... ],
}

config.module = {
  loaders: [
    // Add support for es2015 features and JSX using Babel
    // See `.babelrc` config file in the project root
    {
      test: /\.jsx?$/,
      loader: 'babel-loader',
      include: path.resolve('./app/frontend')
    },
    // Add support for CSS modules
    {
      test: /\.css$/,
      loader: ExtractTextPlugin.extract('style-loader', 'css-loader?modules&importLoaders=1!postcss-loader')
    }
  ]
}

config.postcss = [
  require('autoprefixer'),
  require('postcss-nested'),
  require('postcss-custom-properties'),
  require('postcss-pxtorem')({
    // The properties that can change from px to rem.
    // Set this to an empty array to disable the white list and enable all properties.
    prop_white_list: [],
    minPixelValue: 2
  })
]

module.exports = config
