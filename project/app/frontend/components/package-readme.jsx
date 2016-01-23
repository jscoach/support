import React from 'react'
import PureRenderMixin from 'react-addons-pure-render-mixin'

import Icon from './icon.jsx'

import styles from './package-readme.css'

const PackageReadme = React.createClass({
  mixins: [PureRenderMixin],
  propTypes: {
    name: React.PropTypes.string.isRequired,
    readme: React.PropTypes.string.isRequired,
    repo_user: React.PropTypes.string.isRequired,
    repo: React.PropTypes.string.isRequired,
    relative_modified_at: React.PropTypes.string.isRequired,
    relative_published_at: React.PropTypes.string.isRequired,
    humanized_collections: React.PropTypes.string.isRequired
  },
  render () {
    return (
      <div className={styles.container} ref={ (c) => this._node = c }>
        <div className={styles.filedUnder}>Filed under { this.props.humanized_collections }</div>

        <div className={styles.header}>
          <div className={styles.headerTitle}>
            <span className={styles.name}>{ this.props.name } </span>
            <span className={styles.metadata}>
              { this.timestamp() } by { this.props.repo_user }
            </span>
          </div>

          <a className={styles.externalLink} href={this.externalLink()}>
            View on GitHub <Icon type='github' />
          </a>
        </div>

        <div
          className={styles.content}
          dangerouslySetInnerHTML={{ __html: this.props.readme }}
        />
      </div>
    )
  },
  componentDidUpdate () {
    // On update, scroll to top (the scroll is handled by the parent node)
    this._node.parentNode.scrollTop = 0
  },
  externalLink () {
    return `https://github.com/${ this.props.repo }`
  },
  timestamp () {
    // We are comparing relative timestamps, which is fine. For example, if a
    // package was only published and updated a day ago, we still show "published"
    if (this.props.relative_published_at === this.props.relative_modified_at) {
      return `published ${ this.props.relative_published_at }`
    } else {
      return `updated ${ this.props.relative_modified_at }`
    }
  }
})

export default PackageReadme
