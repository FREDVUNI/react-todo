const express = require("express")
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
        username:joi().string().required().max(25),
        password:joi().string().required().max(25),
        email:joi().string().required().max(25).email(),
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

    const password_valid = bcrypt.compare(user.password,req.body.password)

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

    const validPass = bcrypt.compare(user.password,req.body.password)

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


<input value={todo.name} onChnage={e => setTodo({...todo,name:e.target.value,date:new Date()})}/>

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