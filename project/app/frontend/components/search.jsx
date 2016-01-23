import React from 'react'

import QueryString from 'query-string'
import DebounceInput from 'react-debounce-input'

import styles from './search.css'

const Search = React.createClass({
  contextTypes: {
    path: React.PropTypes.string.isRequired,
    query: React.PropTypes.object.isRequired,
    history: React.PropTypes.object.isRequired
  },
  render () {
    return (
      <form className={styles.container} action='' onSubmit={this.handleSubmit}>
        <DebounceInput
          className={styles.input}
          name='search'
          ref='search'
          type='text'
          placeholder='🔍 Search'
          onChange={this.handleChange}
          minLength={0}
          value={this.defaultValue()}
          debounceTimeout={300}
          autoCapitalize='off'
          autoCorrect='off'
          autoComplete='off'
          spellCheck='false'
          tabIndex='1'
        />
      </form>
    )
  },
  defaultValue () {
    let search = this.context.query.search
    return search ? decodeURIComponent(search) : ''
  },
  handleChange (event) {
    let query = Object.assign({}, this.context.query)
    let search = (event.target.value || '').trim()

    // If we just started searching, better to reset the sort option
    if (!query.search && search) delete query.sort

    // Keep only some of the existing query params
    delete query.page
    delete query.search

    // Add the new search value
    if (search) query.search = search

    // Generate the new path and query string
    let location = { pathname: this.context.path }
    let queryString = QueryString.stringify(query)
    if (queryString) location.search = `?${ queryString }`

    this.context.history.push(location)
  },
  handleSubmit (e) {
    // When the user presses <return> nothing should happen
    // The form element is only here for non-javascript users
    e.preventDefault()
  },
  shouldComponentUpdate (nextProps) {
    // Given that this component doesn't accept any props,
    // it currently doesn't need to ever be updated
    return false
  }
})

export default Search
