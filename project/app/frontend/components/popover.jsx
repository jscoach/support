import React from 'react'
import PureRenderMixin from 'react-addons-pure-render-mixin'

import styles from './popover.css'

const Popover = React.createClass({
  mixins: [PureRenderMixin],
  propTypes: {
    className: React.PropTypes.string,
    children: React.PropTypes.array.isRequired,
    options: React.PropTypes.array.isRequired
  },
  getInitialState () {
    return {
      open: false
    }
  },
  render () {
    let options = this.props.options.map((item, index) => {
      return (
        <a key={index} href={item.href} className={styles.option}>
          {item.title}
        </a>
      )
    })
    return (
      <div ref={ (c) => this._node = c }>
        <a href='#' className={this.props.className} onClick={this.handleClick}>
          {this.props.children}
        </a>

        { this.state.open &&
          <div className={`${ styles.container } animated bounceIn`}>
            {options}
          </div>
        }
      </div>
    )
  },
  componentDidMount () {
    document.addEventListener('keydown', this.handleEscape)
    document.addEventListener('click', this.handleDocumentClick)
  },
  componentWillUnmount () {
    document.removeEventListener('keydown', this.handleEscape)
    document.removeEventListener('click', this.handleDocumentClick)
  },
  handleClick (e) {
    e.preventDefault()
    this.toggle()
  },
  handleDocumentClick (e) {
    let node = this._node

    if (e.target !== node && !node.contains(e.target)) {
      this.setState({ open: false })
    }
  },
  handleEscape (e) {
    if (e.keyCode === 27) {
      this.toggle()
    }
  },
  toggle () {
    this.setState({ open: !this.state.open })
  }
})

export default Popover
