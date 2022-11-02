fconst express = require("express")
const app = express()
const dotenv = require("dotenv")
const morgan = require("morgan")
const cors = require("cors")
const connectDB = require("./database/connect")

app.use(morgan("tiny"))
 
dotenv.config({path:'env.config'})
app.use(express.urlencoded({extended:true}))
app.use(express.json())

app.use(cors())

app.use('api/users',require('../routes/users'))

const PORT = process.env.PORT || 8080
 
connectDB()
app.listen(PORT,()=>{
    console.log(`server started on http://localhost:${PORT}`)
})

#config.env
PORT = 5000
MONGO_URI = mongodb://localhost:27017/chao?readPreference=primary&appname=MongoDB%20Compass&directConnection=true&ssl=false
SECRET_KEY = ufuDYDGDRH^IFGDKFRWROUYUGD0jhghvcgEDdsFDGH


#connect.js
const mongoose = require("mongoose")
const connectDB = async() =>{
    try{
        const con = mongoose.connect(process.env.MONGO_URI,{
            useFindAndModify:false,
            useCreateIndex:true,
            useUnifiedTopology:true,
            useNewUrlParser:true
        })
    }
    catch(error){
        process.exit(1)
        console.log(`There was a server error.`)
    }
}

module.exports = connectDB

#models.js
const mongoose = require("mongoose")

const userSchema = new mongoose.Schema({
    username:{
        type:String,
        required:true
    },
    age:{
        type:Number,
        required:true
    }
},{timestamps:true})

const user = mongoose.model("users",userSchema)

module.exports = user

#controllers--users
const mongoose = require("mongoose")
const jwt = require("jsonwebtoken")
const joi - require("joi")
const bcrypt - require("bcrypt")
const user = require("../models/user")

export const user = async (req,res)=>{
    const schema = joi.object({
        username:joi.string().required().max(25),
        password:joi.string().required().max(25),
        email:joi.string().required().max(25).email(),
    })
    const {error} = schema.validate(req.body)

    if(error) return res.status(400).send(error.details[0].message)

    const user = user.findOne({email:req.body.email})

    if(user) return res.status(400).send(`user email already exists.`)

    #generate password
    const Saltpassword = bcrypt.genSalt(10)
    const hashPassword = bcrypt.hash(req.body.password,Saltpassword)

    let new_user = new user({
        username:req.body.username,
        password:hashPassword,
        email:req.body.email,
    })
    await new_user.save()
    const token = jwt.sign({_id:new_user.id,username:new_user.username},process.env.SECRET_KEY)
    return res.send(token)

}

exports.Signin = async(req,res) =>{
    const schema = joi.object({
        email:joi.string().required().email().max(25),
        password:joi.string().required()
    })  

    const {error} = schema.validate(req.body)

    if(error) return res.status(400).send(error.details[0].message)

    const user = user.findOne({email:req.body.email})
    if(!user) return res.status(400).send('wrong email password combination.')

    const password_valid = bcrypt.compare(req.body.password,user.password)

    if(!password_valid) return res.status(400).send('wrong email password combination.')

    const token = jwt.sign({_id:user._id,username:user.username,email:user.email},process.env.SECRET_KEY)
    return res.send(token)
}

#middleware -- auth

const auth = async (req,res,next) =>{
    const token = req.header("x-auth-token")
    try{
        if(!token) res.status(400).send('You\'re not authorized.')
        const payload = jwt.verify(token,process.env.SECRET_KEY)
        req.user = payload
        next()
    }catch(error){
        return res.status(500).send('The token is invalid.' || error.message)
    }
}

module.exports = auth


#routes

const userController = require("../controllers/userController")
const auth = require("../middleware/auth")

const express = require("express")
const router = express.Router()

router.post("/login",auth,userController.signIn)

module.exports = router

#index.js
import React from 'react'
import ReactDom from 'react-dom/client'
import {Provider} from 'react-redux'
import {createStore,applyMiddleware} from 'redux'
import thunk from 'redux-thunk'
import App from './App'
import rootReducer from './store/reducers/rootReducer'

const root = ReactDom.createRoot(document.getElementById('root'))
const store = createStore(rootReducer,applyMiddleware(thunk))

root.render(
    <React.StictMode>
        <Provider store={store}>
            <App/>
        </Provider> 
    </React.StictMode>
)

#rootReducer

import {combineReducers} from 'redux'
import todoReducer from './todoReducer'

const rootReducer = combineReducers({
    todos:todoReducer
})

export default rootReducer

#todoReducer
const todoReducer = (action,state=[]) =>{
    switch(action.type){
        case 'GET_ITEMS':
            return action.todo.data
        case 'ADD_TODO':
            return [action.todo.data,...state]
        default:
            return state
    }
}

#todoAction
import {url} from '../url'
import axios from 'axios'

const getItems = (todos) =>{
    return (dispatch)=>{
        axios.get(`${url}/todo`)
        .then((todos)=>{
            dispatch({
                type:'GET_ITEMS',
                todos
            })
        })
        .catch((error)=>{
            console.log(error.response || `something went wrong.`)
        })
    }
}
const todoActions = (todo) =>{ 

    return(dispatch,getState) =>{
        axios.post(`${url}/todos`,todo)
        .then((todo)=>{
            dispatch({
                type:'ADD_TODO',
                todo
            })
        })
        .catch((error)=>{
            return condole.log(error.response || `There was an error.`)
        })
    }
}


const mongoose = require("mongoose")

const connectDB = async() =>{
    try{
        const con = mongoose.connect(process.env.MONGO_URI,{
            useUnifiedTopology:true,
            useCreateIndex:true,
            useNewUrlParser:true,
            useFindAndModify:false
        },process.exit(1))
    }
    catch(error){
        process.exit(1)
        console.log('There was a server error.')
    }
}

module.exports = connectDB


const userSchema = new mongoose.Schema({
    name:{
        type:String,
        required:true
    }
},{timestamps:true})

const user = mongoose.model("users",userSchema)

module.exports = user


#controllers

const jwt = require("jwt")
const joi = require("joi")
const user = require("../models/user")
const bcrypt = require("bcrypt")

exports.SignIn = async(req,res) =>{
    const schema = joi.object({
        email:joi.min(3).max(25).required().email(), 
        password:joi.min(3).max(25).required(),
    })

    const {error} = schema.validate(req.body)

    if(error) return res.status(400).send(error.details[0].message)

    const user = user.findOne({email:req.body.email})

    if(!user) return res.status(400).send('Wrong email password combination.')

    const validPass = bcrypt.compare(req.body.password,user.password)

    if(!validPass) return res.status(400).send('Wrong email password combination.')

    const token = jwt.sign({_id:user._id,email:user.email,username:user.username},process.env.SECRET_KEY)
    res.status(201).send(token)
}

#middleware

const jwt = require("jwt")

const auth = async (req,res,next) =>{
    const token = req.header("x-auth-token")
    try{
        if(!token) return res.status(400).send('You are not authorized.')

        const payload = jwt.verify(token,process.env.SECRET_KEY)
        req.user = payload
        next()
    }
    catch(error){
        return res.status(400).send('something went wrong.' || error.message)
    }
}

#index.js
import React from 'react'
import App from 'App'
import ReactDom from 'react-dom/client'
import {Provider} from 'react-redux'
import thunk from 'redux-thunk'
import {createStore,applyMiddleware} from 'redux'
import rootReducer from '../store/reducer/rootReducer'

const store = createStore(rootReducer,applyMiddleware(thunk))
const root = ReactDom.createRoot(getElementById('root'))

root.render(
    <React.StrictMode>
        <Provider store={store}>
            <App/>
        </Provider>
    </React.StrictMode>
)

#rootReducer
import {combineReducers} from 'redux'
import todo from './todoReducer'

const rootReducer = combineReducers({
    todos:todos
})

export default rootReducer


#todoReducer
import {toast} from 'react-toastify'

const todoReducer = (action,state=[]) =>{
    switch(action.type){
        case "GET_TODO":
            return action.todo.data

        case "ADD_TODO":
            toast.success('item has been added.',{
                position:toast.POSITION.BOTTOM_RIGHT
            })
            return [action.todo.data,...state]

        case "TOGGLE":
            toast.success("item status has been changed.",{
                position:toast.POSITION.BOTTOM_RIGHT
            })
            return state.map((todo)=>todo._id === action.todo.data._id ? action.todo : todo)

        case "DELETE_ITEM":
            toast.success("item status has been changed.",{
                position:toast.POSITION.BOTTOM_RIGHT
            })

            //action._id is from the action creators file
            return state.map((todo)=>todo._id !== action._id)

        case "UPDATE_TODO":
            toast.success('item has been updated.',{
                position:toast.POSITION.BOTTOM_RIGHT
            })
            return state.map((todo)=> todo._id === action.todo.data._id ? action.todo.data : todo) 

        default:
            return state
    }
}

#todoActions
import axios from 'axios'
import {url} from '../api'
import {toast} from 'react-toastify'

const getTodo = async () =>{
    return (dispatch) =>{
        axios.get(`${url}/todos`)
        .then((todos)=>{
            dispatch({
                type:"GET_TODO",
                todos
            })
        })
        .catch((error)=>{
            toast.error(error.response?.data,{
                position:toast.POSTION.BOTTOM_RIGHT
            })
            console.log(error.response || `something went wrong.`)
        })
    }
}
const addTodo = async(todo) =>{
    return (getState,dispatch)=>{
        axios.post(`${url}/todos`,todo)
        .then(todo=>{
            dispatch({
                type:"ADD_TODO",
                todo
            })
        })
        .catch(error)=>{
            toast.error(error.response?.data,{
                position:toast.POSTION.BOTTOM_RIGHT
            })
            console.log(error.response || `something went wrong.`)
        }
    }
}

const updateTodo = (id,updatedTodo) =>{
    return (dispatch) =>{
        axios.put(`${url}/todo/${id}`,updatedTodo)
        .then((todo)=>{
            dispatch({
                type:"UPDATE_TODO",
                todo 
            })
        })
        .catch((error)=>{
            toast.error(error.response?.data,{
                position:toast.POSTION.BOTTOM_RIGHT
            })
            console.log(error.response)
        })
    }
}

const completeTodo = (id) =>{
    return(dispatch) =>{
        axios.put(`${url}/todo/${id}`,{})
        .then((todo)=>{
            dispatch({
                type:"TOGGLE":
                todo
            })
        })
        .catch((error)=>{
            toast.error(error.response?.data,{
                position:toast.POSITION.BOTTOM_RIGHT
            })
            console.log(error.response || `There was an error.`)
        })
    }
}

const deleteTodo = (id) =>{
    return(dispatch) =>{
        axios.delete(`${url}/todo/${id}`)
        .then(()=>{
            type:"DELETE_ITEM",
            id
        })
        .catch((error)=>{
            toast.error(error.response?.data,{
                position:toast.POSITION.BOTTOM_RIGHT
            })
            console.log(error.response || `There was an error.`)
        })
    }
}

import { createStyles, makeStyles } from '@material-ui/core';

export const useStyles = makeStyles(() => createStyles({
  calendarHeading:{
    position: 'sticky',
    top: 0,
    paddingTop: '20px',
    paddingBottom: '20px',
    left: 'auto',
    zIndex: 1,
    background: '#fff',
    color: '#263238',
  }
}));


#using it in add component
#todoActions is the name of the action file
import React,{useState} from 'react'
import useDispatch from 'react-redux'
import addTodo from './store/actions/todoActions' 

const [todo,setTodo] = useSate({
    name:"",
    date:""
})

const submitHandler = (e) =>{
    const dispatch = useDispatch()
    e.preventDefault()
    dispatch(addTodo(todo))

    setTodo({
        name:"",
        date:""
    })

}

#perfume
#the legend of el cid
#13 reasons why
#the last kingdom
#the 5 juanas
#the innocent

#Hollywood,the office,icarly-japan
#cloudinary --- Freddyvuni#809

import axios from 'axios'
import { useNavigate } from 'react-router-dom'

const [inputs,setInputs] = useState({
    username:"",
    email:"",
    password:"",
})
const [error,setError] = useState(false)
const navigate = useNavigate()

const handleChange = (e) =>{
    setInputs( prev =>({ ...prev,[e.target.name]:e.target.value }))
}

const handleSubmit = async(e) =>{
    e.preventDefault()
    try{
        await axios.post("api/signup",inputs)
        navigate("/")
    }
    catch(error){
        setError(error.response.data)
        console.log((error))
    }
}

<form onSubmit={handleSubmit}>
{ error && <span>{error}</span>  }
{ error ? <span>{error}</span>:"" }
<input type="text" name="username" value={inputs.username} onChange={handleChange}/>
<input type="email" name="email" value={inputs.email} onChange={handleChange}/>
<input type="password" name="password" value={inputs.password} onChange={handleChange}/>
<button type="submit">submit</button>
</form>

const [posts,setPosts] = useState([])
useEffect(()=>{
    const getPosts = async() =>{
        try{
            const res = await axios.get("api/posts")
            setPosts(res.data)
        }
        catch(error){
            console.log(error)
            #can use toast notification
        }
    }
    getPosts()
},[])

import mysql from 'mysql'
import dotenv from 'dotenv' 
dotenv.config({path:'.env'})

const db = mysql.createConnection({
    port:process.env.DATABASE_PORT,
    host:process.env.DATABASE_HOST,
    password:process.env.DATABASE_PASSWORD,
    user:process.env.DATABASE_USER,
    database:process.env.DATABASE_NAME
    connectionLimit:10
})

export default db


import { db } from './database.js'
import bcrypt from 'bcryptjs'
import jwt from 'jsonwebtoken'

const signUp = async(req,res) =>{
    try{
        const q = "SELECT * FROM users WHERE username = ? AND email = ?"

        db.query(q,[req.body.username,req.body.email],(err,data)=>{
            if(data.length) res.status(409).json('Email or username already exists.')

            const saltPassword = bcrypt.genSaltSync(10)
            const PasswordHash = bcrypt.hashSync(req.body.password,saltPassword)

            const q = "INSERT INTO users(`username`,`email`,`password`) VALUES(?) "

            const VALUES = [
                req.body.username,
                req.body.email,
                passwordHash
            ]
            db.query(q,[VALUES],(err,data) =>{
                if(err) res.status(409).json(err)

                res.status(200).json('user has been created.')
            })

        })
        
    }
    catch(error){
        res.status(500).json(error)
    }    
}

const signIn = aync(req,res)=>{
    try{
        const q = "SELECT * FROM users WHERE email = ?"

        db.query(q,[req.body.email],(err,data)=>{
            if(err) res.status(409).json(err)
            if(data.length === 0) res.status(400).json('wrong password email combination.')

            const verifyPassword = bcryt.compareSync(req.body.password,data[0].password)
            if(!verifyPassword) res.status(400).json('wrong password email combination.')

            const { password,...other } = data[0]
            const token = jwt.sign({
                id:data[0].id,
                other
            },process.env.SECRET_KEY)

            res.status(200).json(token)
        })
    }
    catch(error){
        res.status(500).json(error)   
    }
}

#AuthContext --context API

import React,{ createContext,useState,useEffect } from 'react'
import axios from 'axios'

export const AuthContext = createContext()

export const AuthProvider = ({ children }) =>{
    const [currentUser,setCurrentUser] = useState({
        JSON.parse(localStorge.getItem("user")) || null
    })
    const login = async(inputs) =>{
        const res = await axios.post("/login",inputs)
        setCurrentUser(res.data)
    }

    useEffect(() =>{
        localStorage.setItem("user",JSON.stringify(currentUser))
    },[currentUser])

    return(
        <AuthContext.Provider value={{ login }}>
            {children}
        </AuthContext.Provider>
    )
}
#wrap components in the return App.js
import { AuthProvider } from './context/AuthContext'

<AuthProvider>
    <Components/>
</AuthProvider>

#Login component
import React,{ useContext,useState } from 'react'
import { AuthContext } from './context/AuthContext'
import { useNavigate } from 'react-router-dom'

const Login = () =>{
    const [ inputs, setInputs] = useState("")
    const { login } = useContext(AuthContext)
    const navigate = useNavigate()

    const handleSubmit = async(e) =>{
        e.preventDefault()
        try{
            await login(inputs)
            navigate("/")
        }
        catch(error){
            console.log(error)
        }
    }

    const handleChange = (e) =>{
        setInputs(prev =>({ ...prev,[e.target.name]:e.target.value }))
    }

    return(
        <form onSubmit={handleSubmit}>
            <input type="text" name="username" value={inputs.username} onChange={handleChange}/>
            <input type="password" name="password" value={inputs.password} onChange={handleChange}/>
            <button type="submit">submit</button>
        </form>
    )
}

import { createSlice,configureStore } from '@reduxjs/toolkit'
import axios from 'axios'

const authSlice = createSlice({
    name:'auth',
    initialState:'',
    reducers:{
        login(inputs){
            await axios.post("api/login")
        }
    }
})

export const authActions = authSlice.actions
export const store = configureStore({
    reducer: authSlice.reducer
})

#index.js
import { Provider } from 'react-redux'
import { store } from './context/index'

<Provider store={ store }>
    <App/>
</Provider>    

#Login component
import { useDispatch } from 'react-redux'
import { authActions } from './context/index'

const dispatch = useDispatch()
const handleSubmit = async(e) =>{
    e.preventDefault()
        await dispatch(authActions.login(inputs))
    try{
        await
    }
    catch(error){
        console.log(error)
    }
}

const bcrypt = require('bcryptjs')
const jwt = require('jsonwebtoken')
const {PrismaClient} = require('@prisma/Client')
const Prisma = new PrismaClient()
const joi = require("joi")

export const signUp = async(req,res) =>{
    try{
        const schema = joi.object({
            username: joi.string().required(),
            email:joi.email().required(),
            password:joi.min(8).max(16).required()
        })

        const {error} = schema.validate(req.body)
        if(error) res.status(400).json(error.details[0].message)

        let user = await prisma.user.findUnique({
            where:{
                email:req.body.email
            }
        })
        if(user) res.status(409).json('Email address already exists.')

        let salt = await bcrypt.genSalt(10)
        let hash = await bcrypt.hash(req.body.password,salt)

        const new_user = await prisma.user.create({
            data:{
                username:req.body.username,
                email:req.body.email,
                password:hash,
            }
        })
        const token = jwt.sign({
            _id:user._id,
            username:user.username,
            email:user.email,
        })
        res.status(200).json({
            message:"user has been created.",
            token
        },process.env.SECRET_KEY)
    } catch(error){
        console.log(error)
    }
}


const joi = require("joi")
const {PrismaClient} = require("@prisma/client")
const prisma = new PrismaClient()
const jwt = require("jsonwebtoken")
const bcrypt = require("bcryptjs")

const logIn = async(req,res) =>{
    try{
        const schema = joi.object({
            username: joi.string().max(15).min(1).required(),
            password: joi.string().max(15).min(8).required(),
        })

        const { error } = schema.validate(req.body)
        if(error) res.status(400).json(error.details[0].message)

        const user = await prisma.user.findUnique({
            where:{
                username:req.body.username
            }
        })

        if(!user) res.status(409).json('wrong username password combination.')

        const verifyPassword = await bcrypt.compareSync(req.body.password,user.password)
        if(!verifyPassword) res.status(409).json('wrong username password combination.')

        const token = await jwt.sign({
            _id: user._id,
            username: user.username,
            email: user.email,
        },process.env.SECRET_KEY)
        res.status(200).json(token)

    }
    catch(error){
        res.status(500).json(error)
        console.log(error)
    }
}

module.exports = { logIn }

<input value={todo.name} onChange={e => setTodo({...todo,name:e.target.value,date:new Date()})}/>

const multer = require("multer")

const storage = multer.diskStorage({
    destination:(req,cb,file) =>{
        cb(null,"/images/uploads")
    }
    filename:(req,cb,file) =>{
        cb(null,Date.now(path.extname(file.originalname)))
    }
})

const filter = (req,file,cb) =>{
    if(file.mimetype==="image/jpg" || file.mimetype==="image/png"){
        cb(null,true)
    }else{
        cb(null,false)
    }
}

const upload = multer({storage,filter})

#showing todo items
import {useDispatch,useSelector} from 'react-redux'
import {useEffect},React from 'react'
import getTodos from '../store/actions/TodoActions'
 
const dispatch = useDispatch()
const todos = useSelector((state)=>state.todos)

useEffect(()=>{
    dispatch(getTodos())
},[dispatch])


const express = require("express")
const app = express()

app.get("/",(req,res)=>{
    res.send("Hello world")
})

const port = 3000 
app.listen(()=>{
    console.log(`server started on port ${port}`)
})


const jwt = require('jsonwebtoken')

const auth = async (req,res,next) =>{
    let token = req.header('x-auth-token')
    try{
        if(!token) return res.status(400).send('You are not authorized.')

        let payload = jwt.verify(token,process.env.SECRET_KEY)
        req.user = payload
        next()
    }
    catch(error=>{
        res.status(500).send(error || 'The was a server error.')
    })
}


https://res.cloudinary.com/dvcj2fbjt/image/upload/v1658515128/i0ll1qlmqggtwkbvj76z.jpg
https://res.cloudinary.com/dvcj2fbjt/image/upload/v1658514939/lps1u4vaewfrpv6k1oet.jpg
https://res.cloudinary.com/dvcj2fbjt/image/upload/v1658344813/bcx8o2jdf9o2uarnwbuj.jpg
https://res.cloudinary.com/dvcj2fbjt/image/upload/v1658308833/zy7kwnwelovb1rufrmnd.png
https://res.cloudinary.com/dvcj2fbjt/image/upload/v1658054194/cld-sample-3.jpg
https://res.cloudinary.com/dvcj2fbjt/image/upload/v1658139688/qakyhahowfculvumrou0.jpg
https://res.cloudinary.com/dvcj2fbjt/image/upload/v1658139529/cvu5nt55tohc7tld325v.jpg
https://res.cloudinary.com/dvcj2fbjt/image/upload/v1658054194/cld-sample-3.jpg
https://res.cloudinary.com/dvcj2fbjt/image/upload/v1658054193/cld-sample.jpg
https://res.cloudinary.com/dvcj2fbjt/image/upload/v1658054195/cld-sample-4.jpg
https://res.cloudinary.com/dvcj2fbjt/image/upload/v1658054169/sample.jpg