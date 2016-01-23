import React from 'react'
import { Link } from 'react-router'

import styles from './pagination.css'

const Pagination = React.createClass({
  propTypes: {
    perPage: React.PropTypes.number.isRequired,
    totalItems: React.PropTypes.number.isRequired
  },
  contextTypes: {
    path: React.PropTypes.string.isRequired,
    query: React.PropTypes.object.isRequired
  },
  render () {
    return (
      <div className={styles.container}>
        { this.renderPreviousLink() }
        { this.renderNextLink() }
      </div>
    )
  },
  renderPreviousLink () {
    if (this.currentPage() <= 1) {
      return (
        <span className={`${styles.link} ${styles.isDisabled}`}>
          Previous
        </span>
      )
    }
    let page = this.previousPage()
    let query = Object.assign({}, this.context.query, { page })
    if (page === 1) delete query.page
    return (
      <Link to={this.context.path} query={query} className={styles.link}>
        Previous
      </Link>
    )
  },
  renderNextLink () {
    if (this.currentPage() >= this.lastPage()) {
      return (
        <span className={`${styles.link} ${styles.isDisabled}`}>
          Next
        </span>
      )
    }
    let page = this.nextPage()
    let query = Object.assign({}, this.context.query, { page })
    return (
      <Link to={this.context.path} query={query} className={styles.link}>
        Next
      </Link>
    )
  },
  lastPage () {
    return Math.ceil(this.props.totalItems / this.props.perPage)
  },
  previousPage () {
    // Math.min is only done to deal with tempered page numbers (such as -1)
    return Math.min(this.lastPage(), this.currentPage() - 1)
  },
  nextPage () {
    // Math.max is only done to deal with tempered page numbers (such as -1)
    return Math.max(1, this.currentPage() + 1)
  },
  currentPage () {
    let page = this.context.query.page
    return Math.max(1, parseInt(page, 10) || 1)
  }
})

export default Pagination
