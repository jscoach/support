import React from 'react'

import CollectionItem from './collection-item.jsx'

import styles from './collection-list.css'

const CollectionList = React.createClass({
  propTypes: {
    collections: React.PropTypes.array.isRequired
  },
  render () {
    let collections = this.props.collections.map((item, index) => {
      return (
        <CollectionItem key={index} {...item} />
      )
    })
    return (
      <div className={styles.container}>
        { collections }
      </div>
    )
  }
})

export default CollectionList
