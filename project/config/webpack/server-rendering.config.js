var webpack = require('webpack')
var _ = require('lodash')
var path = require('path')
var ExtractTextPlugin = require('extract-text-webpack-plugin')

var defaultConfig = require('./default.config.js')
var config = _.clone(defaultConfig, true)

config = _.merge(config, {
  name: 'server',
  target: 'web'
})

config.output = {
  path: path.join(config.context, 'app', 'assets'),
  filename: '../../server-bundle.js',
  publicPath: '/assets',
  library: 'App',
  libraryTarget: 'var',
  loaders: config.module.loaders.concat([{
    test: /\.css$/,
    loader: path.join(__dirname, 'server', 'style-collector') + '!css-loader'
  }])
}

config.plugins = [
  new ExtractTextPlugin('app.css.erb', { allChunks: true }),
  new webpack.DefinePlugin({ __SERVER__: JSON.stringify(true) })
]

module.exports = config
