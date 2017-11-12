import React from 'react'
import QueryString from 'query-string'

import Icon from './icon.jsx'

import styles from './package-item.css'

const PackageItem = React.createClass({
  propTypes: {
    description: React.PropTypes.string.isRequired,
    downloads_svg: React.PropTypes.string.isRequired,
    filters: React.PropTypes.array.isRequired,
    humanized_collections: React.PropTypes.string.isRequired,
    humanized_last_month_downloads: React.PropTypes.string.isRequired,
    humanized_stars: React.PropTypes.string.isRequired,
    last_month_downloads: React.PropTypes.number.isRequired,
    name: React.PropTypes.string.isRequired,
    relative_modified_at: React.PropTypes.string.isRequired,
    relative_published_at: React.PropTypes.string.isRequired,
    repo_user: React.PropTypes.string.isRequired,
    repo: React.PropTypes.string.isRequired,
    slug: React.PropTypes.string.isRequired,
    sort: React.PropTypes.string.isRequired,
    stars: React.PropTypes.number.isRequired
  },
  contextTypes: {
    history: React.PropTypes.object.isRequired,
    location: React.PropTypes.object.isRequired,
    params: React.PropTypes.object.isRequired,
    query: React.PropTypes.object.isRequired,
    isMobile: React.PropTypes.bool.isRequired
  },
  render () {
    let filterWarnings = this.filterWarnings()
    let containerClasses = `${ styles.container } ${ filterWarnings.length ? styles.filtered : '' }`
    let starClasses = `${ styles.stars } ${ this.props.stars >= 25 ? styles.coloredStars : '' }`
    let downloadClasses = `${ styles.downloads } ${ this.props.last_month_downloads >= 50 ? styles.coloredDownloads : '' }`

    return (
      <div className={containerClasses} style={this.bgdChartStyles()}>
        {filterWarnings}

        <a className={styles.link} href={this.githubUrl()} onClick={this.handleClick}>
          <div className={styles.header}>
            { this.currentCollection() === 'all' &&
              <div className={styles.filedUnder}>Filed under { this.props.humanized_collections }</div>
            }
            <span className={styles.name}>{ this.props.name } </span>
            <span className={styles.metadata}>
              { this.timestamp() } by { this.props.repo_user }
            </span>
            <span className={styles.visited}> visited</span>
          </div>
          <div className={styles.body} dangerouslySetInnerHTML={{ __html: this.props.description }} />
          <div className={styles.footer}>
            <span className={starClasses} title={`${ this.props.humanized_stars } on GitHub`}>
              { this.props.humanized_stars } </span>
            <span className={downloadClasses}
              title={`${ this.props.humanized_last_month_downloads } from NPM in the last month`}>
              { this.props.humanized_last_month_downloads }<span className={styles.slash}>/</span>mo
            </span>
            {this.filters()}
          </div>
        </a>
      </div>
    )
  },
  timestamp () {
    // We are comparing relative timestamps, which is fine. For example, if a
    // package was only published and updated a day ago, we still show "published"
    if (this.props.sort === 'new' || this.props.relative_published_at === this.props.relative_modified_at) {
      return `published ${ this.props.relative_published_at }`
    } else {
      return `updated ${ this.props.relative_modified_at }`
    }
  },
  handleClick (e) {
    // On a Mac, if the user clicks a link and the `cmd` key is pressed,
    // it is expected to open on a new tab. So open the GitHub link there.
    if (!e.metaKey && !this.context.isMobile) {
      e.preventDefault()

      this.context.history.push({
        pathname: `/${ this.currentCollection() }/${ this.props.slug }`,
        search: this.context.location.search
      })
    }
  },
  currentCollection (defaultCollectionId = 'all') {
    return this.context.params.collectionId || defaultCollectionId
  },
  githubUrl () {
    // We are using a link to GitHub, although it opens a panel,
    // so we can display the ones that have been `visited`
    return `https://github.com/${ this.props.repo }`
  },
  bgdChartStyles () {
    return { backgroundImage: `url(${ this.props.downloads_svg })` }
  },
  filterWarnings () {
    let packageFilters = this.props.filters.map((item) => item.slug)
    let appliedFilters = (this.context.query.filters || '').split('.')
    let warnings = []

    switch (this.currentCollection()) {
      case 'react-native':
        // We check if it has platform filters because if it hasn't, it's pure JS and may work in both
        let hasPlatformFilters = packageFilters.includes('android') || packageFilters.includes('ios')

        if (hasPlatformFilters && !packageFilters.includes('android') && appliedFilters.includes('android')) {
          warnings.push(
            <div className={styles.filterWarning} key='filter-android'>
              May not support Android
            </div>
          )
        }
        if (hasPlatformFilters && !packageFilters.includes('ios') && appliedFilters.includes('ios')) {
          warnings.push(
            <div className={styles.filterWarning} key='filter-ios'>
              May not support iOS
            </div>
          )
        }
        break
      case 'react':
        if (!packageFilters.includes('inline-styles') && appliedFilters.includes('inline-styles')) {
          let githubQuery = { q: 'language:css language:sass language:scss language:less' }
          let githubSearch = `${ this.githubUrl() }/search?${ QueryString.stringify(githubQuery) }`

          warnings.push(
            <a href={githubSearch} className={styles.filterWarning} target='_blank'>
              Some CSS files were found <Icon type='help' />
            </a>
          )
        }
    }
    return warnings
  },
  filters () {
    // Only display the filter names for React Native
    if (this.currentCollection() !== 'react-native') {
      return null
    }
    return this.props.filters.map((item, index) => (
      <span className={styles.filters} key={index}>{item.name}</span>
    ))
  }
})

export default PackageItem
