import React from 'react'

import styles from './loader.css'

export default (props) => (
  <div {...props} className={styles.container}>
    <div className={`${ styles.loader } zoomIn infinite animated`} />
  </div>
)
