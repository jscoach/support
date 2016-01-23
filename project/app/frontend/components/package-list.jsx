import React from 'react'
import PureRenderMixin from 'react-addons-pure-render-mixin'

import PackageItem from './package-item.jsx'

import styles from './package-list.css'

const PackageList = React.createClass({
  mixins: [PureRenderMixin],
  propTypes: {
    packages: React.PropTypes.array.isRequired,
    sort: React.PropTypes.string.isRequired
  },
  render () {
    if (!this.props.packages.length) {
      return (
        <div className={styles.empty} ref={ (c) => this._node = c }>
          No packages found.
        </div>
      )
    }

    let packages = this.props.packages.map((item, index) => {
      return (
        <PackageItem key={index} {...item} sort={this.props.sort} />
      )
    })
    return (
      <div ref={ (c) => this._node = c }>
        { packages }
      </div>
    )
  },
  componentDidUpdate () {
    // On update, scroll to top (the scroll is handled by the parent node)
    if (this._node) {
      this._node.parentNode.parentNode.scrollTop = 0
    }
  }
})

export default PackageList
