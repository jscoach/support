import React from 'react'
import { Link } from 'react-router'

import styles from './sort-options.css'

const SortOptions = React.createClass({
  propTypes: {
    defaultSortBy: React.PropTypes.string.isRequired
  },
  contextTypes: {
    path: React.PropTypes.string.isRequired,
    query: React.PropTypes.object.isRequired
  },
  render () {
    return (
      <div className={styles.container}>
        <div className={styles.header}>
          Sort by
        </div>

        <ul className={styles.content}>
          <li>{ this.renderSortLink('updated', 'Updated') }</li>
          <li>{ this.renderSortLink('new', 'New') }</li>
          <li>{ this.renderSortLink('popular', 'Popular') }</li>
        </ul>
      </div>
    )
  },
  renderSortLink (type, name) {
    let query = Object.assign({}, this.context.query, { sort: type })
    delete query.page // Since we are reordering, reset pagination

    // If the current sorting option is this one, show a span instead of link
    if (type === (this.context.query.sort || this.props.defaultSortBy)) {
      return (
        <span className={`${ styles.item } ${ styles.isActive }`}>
          {name}
        </span>
      )
    }
    // If this is the default sorting, don't pass the unnecessary sort param
    if (this.props.defaultSortBy === type) {
      delete query.sort
      return (
        <Link to={this.context.path} query={query} className={styles.item}>
          {name}
        </Link>
      )
    }
    return (
      <Link to={this.context.path} query={query} className={styles.item}>
        {name}
      </Link>
    )
  }
})

export default SortOptions
