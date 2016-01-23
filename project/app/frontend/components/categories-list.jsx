import React from 'react'
import { Link } from 'react-router'

import styles from './categories-list.css'

const CategoriesList = React.createClass({
  propTypes: {
    categories: React.PropTypes.array.isRequired
  },
  contextTypes: {
    path: React.PropTypes.string.isRequired,
    query: React.PropTypes.object.isRequired
  },
  render () {
    let categories = this.props.categories.map((item, index) => {
      return (
        <li key={index}>
          { this.renderCategoryLink(item.slug, item.name) }
        </li>
      )
    })

    if (categories.length === 0) {
      return <div />
    }
    return (
      <div className={styles.container}>
        <div className={styles.header}>
          Categories
        </div>

        <ul className={styles.content}>
          {categories}
        </ul>
      </div>
    )
  },
  renderCategoryLink (slug, name) {
    let query = Object.assign({}, this.context.query)
    delete query.page // Since we are filtering, reset pagination

    let isActive = query.category === slug || (!query.category && slug === 'all')
    let className = `${ styles.item } ${ isActive ? styles.isActive : '' }`

    // Make `all` the default category
    if (slug === 'all') {
      delete query.category
    } else {
      query.category = slug
    }
    return (
      <Link to={this.context.path} query={query} className={className}>
        { name }
      </Link>
    )
  }
})

export default CategoriesList
