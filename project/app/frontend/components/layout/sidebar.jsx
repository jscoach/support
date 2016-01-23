import React from 'react'
import styles from './sidebar.css'

export default (props) => (
  <div
    {...props}
    className={`${ styles.container } ${ props.className || '' }`}
  />
)
