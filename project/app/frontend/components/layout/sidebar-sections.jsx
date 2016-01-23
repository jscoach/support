import React from 'react'
import styles from './sidebar-sections.css'

export default (props) => (
  <div
    {...props}
    className={`${ styles.container } ${ props.className || '' }`}
  />
)
