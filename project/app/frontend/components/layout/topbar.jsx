import React from 'react'
import styles from './topbar.css'

export default (props) => (
  <div
    {...props}
    className={`${ styles.container } ${ props.className || '' }`}
  />
)
