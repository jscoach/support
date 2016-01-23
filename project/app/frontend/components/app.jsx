import React from 'react'
import { Link } from 'react-router'
import PureRenderMixin from 'react-addons-pure-render-mixin'

import { Layout, Topbar } from './layout/layout.jsx'
import Icon from './icon.jsx'
import Popover from './popover.jsx'
import Search from './search.jsx'
import Snackbar from './snackbar.jsx'

import styles from './app.css'

const App = React.createClass({
  mixins: [PureRenderMixin],
  propTypes: {
    location: React.PropTypes.object.isRequired,
    params: React.PropTypes.object.isRequired,
    history: React.PropTypes.object.isRequired,
    children: React.PropTypes.object.isRequired,
    notification: React.PropTypes.string
  },
  childContextTypes: {
    path: React.PropTypes.string,
    params: React.PropTypes.object,
    query: React.PropTypes.object,
    history: React.PropTypes.object, // Used for navigation
    isMobile: React.PropTypes.bool
  },
  getChildContext () {
    return {
      path: this.props.location.pathname,
      params: this.props.params,
      query: this.props.location.query,
      history: this.props.history,
      isMobile: this.isMobile()
    }
  },
  render () {
    let menuOptions = [{
      title: 'Submit a Package',
      href: 'https://github.com/dmfrancisco/JS.coach/blob/master/CONTRIBUTING.md'
    }, {
      title: 'Feedback',
      href: 'https://github.com/dmfrancisco/JS.coach'
    }, {
      title: 'Changelog',
      href: 'http://blog.js.coach'
    }, {
      title: 'Twitter',
      href: 'https://twitter.com/_jscoach'
    }]

    return (
      <Layout className={styles.container}>
        <Topbar className={styles.topbar}>
          <h1 className={styles.title}>
            <Link to='/' className={styles.link}>JS.coach</Link>
          </h1>
          <Search />
          <div className={styles.actions}>
            <Popover options={menuOptions} className={styles.link}>
              Menu <Icon type='menu' />
            </Popover>
          </div>
        </Topbar>
        {this.props.children}

        <Snackbar message={this.notifications()} />
      </Layout>
    )
  },
  // Custom CSS for `:focus` is also applied when an element is clicked using the mouse,
  // so this code enables us to customize the `:focus` styles only when `tab` is used.
  // Based on: http://stackoverflow.com/a/32047108/543293
  componentDidMount () {
    let tabbing = false

    document.addEventListener('keydown', function (e) {
      if (e.keyCode === 9) {
        tabbing = true
      }
    })
    document.addEventListener('focusin', function (e) {
      if (tabbing) {
        document.body.classList.add('a11y')
      }
    })
    document.addEventListener('click', function (e) {
      document.body.classList.remove('a11y')
      tabbing = false
    })
  },
  isMobile () {
    // NOTE: Make sure the media query matches the one in CSS files
    return (typeof window !== 'undefined' && window.matchMedia('(max-width: 519px)').matches)
  },
  notifications () {
    if (this.isMobile()) {
      return 'At the moment some features are not available for your screen size.'
    }
    if (this.props.notification) {
      return this.props.notification
    }
  }
})

export default App
