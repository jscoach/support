/* Development server for react-hot-loader */

var webpack = require('webpack')
var WebpackDevServer = require('webpack-dev-server')
var config = require('./config/webpack/development.config.js')[0]

new WebpackDevServer(webpack(config), {
  publicPath: config.output.publicPath,
  hot: true,
  historyApiFallback: true
}).listen(3000, 'localhost', function (err, result) {
  if (err) console.log(err)
  console.log('Webpack Dev Server is listening on port 3000')
})
