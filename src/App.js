import './App.css';
import React,{useEffect} from 'react'
import {BrowserRouter as Router, Route, Routes } from 'react-router-dom';
import {Container,makeStyles} from '@material-ui/core'
import { ToastContainer } from 'react-toastify'
import 'react-toastify/dist/ReactToastify.css'
import {loadUser} from './store/actions/authActions'
import {useDispatch} from 'react-redux'

import SignIn from "./components/auth/SignIn"
import SignUp from "./components/auth/SignUp"
import Navbar from "./components/navbar/NavBar"
import Todos from "./components/todo/Todos"

const useStyles = makeStyles({
  ContentStyle:{
    margin:"30px auto",
  }
})

function App() {
  const classes = useStyles()

  const dispatch = useDispatch()

  useEffect(()=>{
    dispatch(loadUser)
  },[dispatch])

  return (
    <div>
      <Container maxWidth="md">
        <Router>
        <ToastContainer/>
        <Navbar/>      
          <Container maxWidth="sm" className={classes.ContentStyle}>
            <Routes>
              <Route path="/" element={ <Todos/> } />
              <Route path="/sign-in" element={ <SignIn/> } />
              <Route path="/sign-up" element={ <SignUp/> } />
            </Routes>
          </Container>
        </Router>
      </Container>
    </div>
  )
}

export default App;
