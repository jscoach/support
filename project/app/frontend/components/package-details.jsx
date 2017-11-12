import React from 'react'
import PureRenderMixin from 'react-addons-pure-render-mixin'
import DocumentTitle from 'react-document-title'

import { Details } from './layout/layout.jsx'
import Loader from './loader.jsx'
import PackageReadme from './package-readme.jsx'

import styles from './package-details.css'

const PackageDetails = React.createClass({
  mixins: [PureRenderMixin],
  propTypes: {
    params: React.PropTypes.object.isRequired,
    name: React.PropTypes.string,
    readme: React.PropTypes.string,
    repo_user: React.PropTypes.string,
    repo: React.PropTypes.string,
    relative_modified_at: React.PropTypes.string,
    relative_published_at: React.PropTypes.string,
    humanized_collections: React.PropTypes.string,
    slug: React.PropTypes.string
  },
  getInitialState () {
    return {
      hasContent: !!this.props.name,
      loading: false,
      name: this.props.name,
      readme: this.props.readme,
      repo_user: this.props.repo_user,
      repo: this.props.repo,
      relative_modified_at: this.props.relative_modified_at,
      relative_published_at: this.props.relative_published_at,
      humanized_collections: this.props.humanized_collections,
      slug: this.props.slug
    }
  },
  render () {
    if (this.state.hasContent) {
      let props = Object.assign({}, this.state)
      delete props.hasContent
      delete props.loading

      return (
        <DocumentTitle title={this.title()}>
          <Details id='details' className={`${styles.container} ${this.state.loading ? styles.loading : ''}`}>
            <PackageReadme {...props} />
            { this.state.loading && <Loader /> }
          </Details>
        </DocumentTitle>
      )
    }
    return (
      <Details className={styles.container}>
        <Loader />
      </Details>
    )
  },
  componentWillUpdate (nextProps) {
    let before = this.props.params.packageId
    let after = nextProps.params.packageId

    if (before !== after) {
      this.fetchPackageDetails(nextProps.params.collectionId, after)
    }
  },
  componentWillMount () {
    // When the user changes collections, the component is remounted
    if (this.state.slug !== this.props.params.packageId) {
      this.setState({ loading: true, hasContent: false })
      this.fetchPackageDetails(this.props.params.collectionId, this.props.params.packageId)
    }
  },
  fetchPackageDetails (collectionId, packageId) {
    let options = { credentials: 'same-origin' } // Send cookies
    let url = `/${ collectionId }/${ packageId }.json`

    window.fetch(url, options)
      .then((response) => {
        return response.json()
      }).then((json) => {
        let state = Object.assign({ loading: false, hasContent: true }, json)
        this.setState(state)
      }).catch((error) => {
        console.log('Request failed', error)
      })

    this.setState({ loading: true })
  },
  title () {
    return this.state.name ? `${ this.state.name } / JS.coach` : 'JS.Coach'
  }
})

export default PackageDetails
