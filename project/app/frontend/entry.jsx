/* globals __SERVER__ */

import 'babel-polyfill'
import React from 'react'
import { Router, Route, IndexRoute } from 'react-router'

import App from './components/app.jsx'
import PackageDetails from './components/package-details.jsx'
import Packages from './components/packages.jsx'
import Welcome from './components/welcome.jsx'
import './help.js'

const createRoutes = function (initialData, history) {
  let app = (props) => <App {...props} {...initialData} />
  let packages = (props) => <Packages {...props} {...initialData} />
  let welcome = (props) => <Welcome {...props} {...initialData} />
  let packageDetails = (props) => <PackageDetails {...props} {...initialData} />

  return (
    <Router history={history}>
      <Route path='' component={app}>
        <Route path='(:collectionId)' component={packages}>
          <IndexRoute component={welcome} />
          <Route path=':packageId' component={packageDetails} />
        </Route>
      </Route>
    </Router>
  )
}

if (__SERVER__) {
  const ReactDOMServer = require('react-dom/server')
  const { match, RoutingContext } = require('react-router')
  const createMemoryHistory = require('history/lib/createMemoryHistory')
  const DocumentTitle = require('react-document-title')

  global.serverRender = function (location, initialData) {
    let output = ''
    let routes = createRoutes(initialData, createMemoryHistory())

    match({ routes, location }, (_, redirectLocation, renderProps) => {
      output = ReactDOMServer.renderToString(<RoutingContext {...renderProps} />)
    })
    // Return the rendered component and the current document title
    return [ output, DocumentTitle.rewind() ]
  }
} else {
  const ReactDOM = require('react-dom')
  const createBrowserHistory = require('history/lib/createBrowserHistory')

  let mountNode = document.getElementById('root')
  let routes = createRoutes(window.initialData, createBrowserHistory())

  ReactDOM.render(routes, mountNode)
}
