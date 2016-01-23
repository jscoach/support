import React from 'react'

import Body from './body.jsx'
import Details from './details.jsx'
import Master from './master.jsx'
import Sidebar from './sidebar.jsx'
import SidebarSections from './sidebar-sections.jsx'
import Topbar from './topbar.jsx'

import styles from './layout.css'

const Layout = (props) => (
  <div
    {...props}
    className={`${ styles.container } ${ props.className || '' }`}
  />
)

export {
  Layout,
  Body,
  Details,
  Master,
  Sidebar,
  SidebarSections,
  Topbar
}

export default Layout
