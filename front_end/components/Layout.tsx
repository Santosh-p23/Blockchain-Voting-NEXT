import React from 'react'
import Navbar from './Navbar'
import Footer from './Footer'

type Props={
    children: JSX.Element
}

const Layout = ({children}: Props) => {
  return (
    <>
    <Navbar />
     {children}
    <Footer />
    </>
  )
}

export default Layout
