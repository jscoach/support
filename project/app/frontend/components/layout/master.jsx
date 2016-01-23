import React from 'react'
import styles from './master.css'

export default (props) => (
  <div
    {...props}
    className={`${ styles.container } ${ props.className || '' }`}
  />
)
