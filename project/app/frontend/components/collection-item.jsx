import React from 'react'
import { Link } from 'react-router'

import styles from './collection-item.css'

const CollectionItem = React.createClass({
  propTypes: {
    name: React.PropTypes.string.isRequired,
    slug: React.PropTypes.string.isRequired
  },
  contextTypes: {
    params: React.PropTypes.object.isRequired,
    query: React.PropTypes.object.isRequired
  },
  render () {
    let slug = this.props.slug === 'all' ? '' : this.props.slug
    let to = `/${ slug }`

    let query = Object.assign({}, this.context.query)
    delete query.page // Reset pagination
    delete query.filters // Reset filters
    delete query.category // Reset categories

    let linkProps = { to, query, className: styles.link, activeClassName: styles.active }

    // Make `all` also show the active class
    if (this.props.slug === 'all' && this.props.slug === this.context.params.collectionId) {
      linkProps.className += ` ${ styles.active }`
    }
    return (
      <Link {...linkProps}>
        { this.props.name }
      </Link>
    )
  }
})

export default CollectionItem
