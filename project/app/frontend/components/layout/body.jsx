import React from 'react'
import styles from './body.css'

export default (props) => (
  <div
    {...props}
    className={`${ styles.container } ${ props.className || '' }`}
  />
)
