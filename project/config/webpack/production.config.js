var webpack = require('webpack')
var ChunkManifestPlugin = require('chunk-manifest-webpack-plugin')
var ExtractTextPlugin = require('extract-text-webpack-plugin')
var _ = require('lodash')
var path = require('path')

var defaultConfig = require('./default.config.js')
var config = _.clone(defaultConfig, true)

config = _.merge(config, {
  name: 'browser'
})

config.output = _.merge(config.output, {
  // We're also telling it to write these bundles in our public/assets folder,
  // the same thing a rake assets:precompile would do
  path: path.join(config.context, 'public', 'assets'),
  // Override the output configuration to write bundles with digest chunks in the name
  filename: '[name]-bundle-[chunkhash].js',
  chunkFilename: '[id]-bundle-[chunkhash].js'
})

config.plugins = [
  // Add window.fetch polyfill. This will only work on the client-side.
  // Thank you all at gist.github.com/b29676dd1ab8714a818f
  new webpack.ProvidePlugin({
    'Promise': 'exports?global.Promise!es6-promise',
    'window.fetch': 'imports?this=>global!exports?global.fetch!whatwg-fetch'
  }),
  new webpack.optimize.CommonsChunkPlugin('common', 'common-[chunkhash].js'),
  // Outputs a JSON file containing numeric IDs linked to the bundle names
  new ChunkManifestPlugin({
    filename: 'webpack-common-manifest.json',
    manifestVariable: 'webpackBundleManifest'
  }),
  new webpack.optimize.UglifyJsPlugin(),
  new webpack.optimize.OccurenceOrderPlugin(),
  new webpack.DefinePlugin({
    __SERVER__: JSON.stringify(false)
  }),
  new webpack.DefinePlugin({
    'process.env': {
      'NODE_ENV': JSON.stringify('production')
    }
  }),
  // Save file in the assets directory, instead of public, so that
  // `rake assets:precompile` can process existing ERB tags
  new ExtractTextPlugin('../../app/assets/app.css.erb', { allChunks: true })
]

module.exports = [
  config,
  require('./server-rendering.config.js')
]
