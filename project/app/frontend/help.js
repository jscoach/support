/* globals __SERVER__ */

if (!__SERVER__ && window.console) {
  console.log('Hello, nice to see you here. How can I `help` you?')

  window.help = {
    colophon () {
      console.log("JS.coach wouldn't be possible without the following open source projects:")
      return {
        'babel': 'https://babeljs.io/',
        'css-modules': 'https://github.com/css-modules/css-modules',
        'd3': 'http://d3js.org/',
        'jsdom': 'https://github.com/tmpvar/jsdom',
        'node': 'https://nodejs.org/',
        'npm': 'https://www.npmjs.com/',
        'postcss': 'https://github.com/postcss/postcss',
        'postcss-plugins': 'https://github.com/himynameisdave/postcss-plugins',
        'react': 'https://facebook.github.io/react/',
        'webpack': 'https://webpack.github.io/'
      }
    },
    version () {
      return (
        'v0.0.0 Hello, World!'
      )
    }
  }
}
