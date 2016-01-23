import React from 'react'

import { Details } from './layout/layout.jsx'

import styles from './welcome.css'

const Welcome = React.createClass({
  propTypes: {
    sheet: React.PropTypes.object.isRequired
  },
  contextTypes: {
    params: React.PropTypes.object.isRequired
  },
  shouldComponentUpdate (nextProps, nextState, nextContext) {
    return this.context.params.collectionId !== nextContext.params.collectionId
  },
  render () {
    let currentCollection = this.context.params.collectionId
    let html = this.props.sheet[currentCollection] || this.props.sheet['welcome']

    return (
      <Details className={styles.container}>
        <div
          ref={ (c) => this._node = c }
          className={`markdown-body ${styles.content}`}
          dangerouslySetInnerHTML={{ __html: html }}
        />
      </Details>
    )
  },
  componentDidUpdate () {
    // On update, scroll to top (the scroll is handled by the parent node)
    this._node.parentNode.scrollTop = 0
  }
})

export default Welcome
