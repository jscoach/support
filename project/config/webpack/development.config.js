var webpack = require('webpack')
var _ = require('lodash')
var path = require('path')
var ExtractTextPlugin = require('extract-text-webpack-plugin')

var defaultConfig = require('./default.config.js')
var config = _.clone(defaultConfig, true)

config = _.merge(config, {
  name: 'browser',
  debug: true,
  displayErrorDetails: true,
  outputPathinfo: true,
  devtool: 'sourcemap'
})

config.output = _.merge(config.output, {
  // This is our app/assets/javascripts directory, which is part of the Sprockets pipeline
  path: path.join(config.context, 'app', 'assets'),
  // The filename of the compiled bundle, e.g. app/assets/javascripts/bundle.js
  filename: '[name]-bundle.js'
})

config.plugins = [
  // Add window.fetch polyfill. This will only work on the client-side.
  // Thank you all at gist.github.com/b29676dd1ab8714a818f
  new webpack.ProvidePlugin({
    'Promise': 'exports?global.Promise!es6-promise',
    'window.fetch': 'exports?self.fetch!whatwg-fetch'
  }),
  // Create a new file in your output directly called common-bundle.js, which will contain
  // the webpack bootstrap code plus any modules webpack detected are in use by more
  // than one entry point
  new webpack.optimize.CommonsChunkPlugin('common', 'common-bundle.js'),
  new ExtractTextPlugin('app.css.erb', { allChunks: true }),
  new webpack.DefinePlugin({
    __SERVER__: JSON.stringify(false)
  })
]

// Additional changes and additions to setup react-hot-loader
config.output.publicPath = 'http://0.0.0.0:3000/assets/'
config.plugins.push(new webpack.HotModuleReplacementPlugin())
config.entry.app = [ './app/frontend/entry.jsx', 'webpack/hot/only-dev-server' ]
config.entry['dev-client'] = 'webpack-dev-server/client?http://0.0.0.0:3000'
config.module.loaders[0] = {
  test: /\.jsx?$/,
  loaders: ['react-hot', 'babel-loader'],
  include: path.resolve('./app/frontend')
}

module.exports = [
  config,
  require('./server-rendering.config.js')
]
