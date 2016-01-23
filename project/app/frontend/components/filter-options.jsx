import React from 'react'
import { Link } from 'react-router'

import styles from './filter-options.css'

const FilterOptions = React.createClass({
  propTypes: {
    filters: React.PropTypes.array.isRequired
  },
  contextTypes: {
    path: React.PropTypes.string.isRequired,
    query: React.PropTypes.object.isRequired
  },
  render () {
    let filters = this.props.filters.map((item, index) => {
      return (
        <li key={index}>
          { this.renderFilterLink(item.slug, item.name) }
        </li>
      )
    })

    if (filters.length === 0) {
      return <div />
    }
    return (
      <div className={styles.container}>
        <div className={styles.header}>
          Filters
        </div>

        <ul className={styles.content}>
          {filters}
        </ul>
      </div>
    )
  },
  renderFilterLink (slug, name) {
    let query = Object.assign({}, this.context.query)
    let filters = query.filters ? query.filters.split('.') : []
    let isActive = filters.indexOf(slug) !== -1
    let className = `${ styles.item } ${ isActive ? styles.isActive : '' }`

    // We cloned the query but the nested filters array is the original,
    // so instead of mutating it, override it
    if (isActive) {
      filters = filters.filter((i) => i !== slug)
    } else {
      filters = filters.concat([ slug ])
    }

    query.filters = filters.join('.')
    if (!query.filters) delete query.filters
    delete query.page // Since we are filtering, reset pagination

    return (
      <Link to={this.context.path} query={query} className={className}>
        { name }
      </Link>
    )
  }
})

export default FilterOptions
