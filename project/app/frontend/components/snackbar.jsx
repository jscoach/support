import React from 'react'
import PureRenderMixin from 'react-addons-pure-render-mixin'

import styles from './snackbar.css'

const Snackbar = React.createClass({
  mixins: [PureRenderMixin],
  propTypes: {
    message: React.PropTypes.string
  },
  getInitialState () {
    return {
      fade: false,
      hide: false
    }
  },
  render () {
    if (this.state.fade) {
      setTimeout(() => {
        this.setState({ hide: true })
      }, 1000)
    }
    if (this.props.message && !this.state.hide) {
      let animationClass = this.state.fade ? 'slideOutDown' : 'bounceInUp'
      return (
        <div
          onClick={this.handleClick}
          className={`animated ${ animationClass } ${ styles.container }`}
          dangerouslySetInnerHTML={{ __html: this.props.message }}
          title='Dismiss'
        />
      )
    } else {
      return <div />
    }
  },
  handleClick () {
    this.setState({ fade: true })
  },
  componentDidMount () {
    setTimeout(() => {
      this.setState({ fade: true })
    }, 9000)
  }
})

export default Snackbar
