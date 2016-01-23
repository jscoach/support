import React from 'react'
import PureRenderMixin from 'react-addons-pure-render-mixin'
import QueryString from 'query-string'
import DocumentTitle from 'react-document-title'

import { Body, Master, Sidebar, SidebarSections } from './layout/layout.jsx'
import CategoriesList from './categories-list.jsx'
import CollectionList from './collection-list.jsx'
import FilterOptions from './filter-options.jsx'
import Loader from './loader.jsx'
import PackageList from './package-list.jsx'
import Pagination from './pagination.jsx'
import SortOptions from './sort-options.jsx'

import styles from './packages.css'

const Packages = React.createClass({
  mixins: [PureRenderMixin],
  propTypes: {
    location: React.PropTypes.object.isRequired,
    params: React.PropTypes.object.isRequired,
    categories: React.PropTypes.array.isRequired,
    collections: React.PropTypes.array.isRequired,
    filters: React.PropTypes.array.isRequired,
    packages: React.PropTypes.array.isRequired,
    packagesCount: React.PropTypes.number.isRequired,
    packagesPerPage: React.PropTypes.number.isRequired,
    packagesSort: React.PropTypes.string.isRequired,
    packagesDefaultSort: React.PropTypes.string.isRequired,
    children: React.PropTypes.object.isRequired
  },
  getInitialState () {
    return {
      categories: this.props.categories,
      filters: this.props.filters,
      packages: this.props.packages,
      packagesCount: this.props.packagesCount,
      packagesSort: this.props.packagesSort,
      // Default sorting must be stored on state because it's diferent if you are searching
      packagesDefaultSort: this.props.packagesDefaultSort
    }
  },
  render () {
    return (
      <DocumentTitle title={this.title()}>
        <Body className={styles.container}>
          <Sidebar className={styles.sidebar}>
            <CollectionList collections={this.props.collections} />
            <SidebarSections className={styles.sidebarSections}>
              <SortOptions defaultSortBy={this.state.packagesDefaultSort} />
              <FilterOptions filters={this.state.filters} />
              <CategoriesList categories={this.state.categories} />
            </SidebarSections>
          </Sidebar>

          <Master className={`${styles.master} ${this.state.loading ? styles.loading : ''}`}>
            <div className={this.state.packages.length ? styles.list : styles.emptyList}>
              <PackageList
                packages={this.state.packages}
                sort={this.state.packagesSort}
                totalItems={this.state.packagesCount}
                perPage={this.props.packagesPerPage}
              />
              <Pagination
                totalItems={this.state.packagesCount}
                perPage={this.props.packagesPerPage}
              />
            </div>
            { this.state.loading && <Loader /> }
          </Master>
          {this.props.children}
        </Body>
      </DocumentTitle>
    )
  },
  componentDidUpdate (prevProps) {
    if (prevProps.params.collectionId !== this.props.params.collectionId ||
        prevProps.location.search !== this.props.location.search) {
      // If we opened a readme in the all section, prevent fetch & scroll of same collection
      if (!prevProps.params.collectionId && this.props.params.collectionId === 'all' &&
        prevProps.location.search === this.props.location.search) { return }

      this.fetchPackages(this.props.params.collectionId)
    }
  },
  fetchPackages (collectionId) {
    let options = { credentials: 'same-origin' } // Send cookies
    let url = `/${ collectionId || 'all' }.json`
    let query = this.props.location.query

    if (query) {
      url += `?${ QueryString.stringify(query) }`
    }

    window.fetch(url, options)
      .then((response) => {
        return response.json()
      }).then((json) => {
        let state = Object.assign({ loading: false }, json)
        this.setState(state)
      }).catch((error) => {
        console.log('Request failed', error)
      })

    this.setState({ loading: true })
  },
  title () {
    let collections = this.props.collections
    let currentId = this.props.params.collectionId
    let current = collections.filter((collection) => collection.slug === currentId)[0]

    return current ? `${ current.name } / JS.coach` : 'JS.coach'
  }
})

export default Packages
