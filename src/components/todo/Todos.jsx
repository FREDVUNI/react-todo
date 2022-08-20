import React,{useState} from 'react'
import AddTodo from './AddTodo'
import ListTodo from './ListTodo'
import { Navigate } from 'react-router-dom'
import {useSelector} from 'react-redux'

const Todos = () => {
    const [todo,setTodo] = useState({
        name:"",
        isComplete:false
    })

    const auth = useSelector(state => state.auth)

    if(!auth._id) return <Navigate to ='/sign-in'/>

    return (
        <>
            <AddTodo todo={todo} setTodo={setTodo}/>
            <ListTodo setTodo={setTodo}/>
        </>
    )
}

export default Todos
