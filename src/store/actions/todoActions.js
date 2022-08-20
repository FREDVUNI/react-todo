import { url,setHeaders } from '../../api'
import axios from 'axios'
import { toast } from 'react-toastify'

export const getTodo = () =>{
    return (dispatch)=>{
        //returning the dispatch is possible because of redux thunk
        axios
        .get(`${url}/todo`,setHeaders())
        .then((toDos)=>{
            dispatch({
                type:'GET_ITEMS',
                toDos
            })
        })
        .catch((error)=>{
            // console.log(error.response || `There was an error.`)
            toast.error(error.response?.data,{
                position:toast.POSITION.BOTTOM_RIGHT
            })
        })
    }
}

export const addTodo = (newTodo) =>{
    return (dispatch,getState) =>{

        const author = getState().auth.name
        const uid = getState().auth._id

        axios
        .post(`${url}/todo`,{...newTodo,author,uid},setHeaders())
        .then((todo)=>{
            dispatch({
                type:'ADD_TODO',
                todo
            })
        })
        .catch((error)=>{
            // console.log(error.response || `There was an error.`)
            toast.error(error.response?.data,{
                position:toast.POSITION.BOTTOM_RIGHT
            })
        })
    }
}

export const updateTodo = (updatedTodo,id) =>{
    return (dispatch) =>{
        axios
        .patch(`${url}/todo/${id}`,updatedTodo,setHeaders())
        .then((todo)=>{
            dispatch({
                type:"UPDATE_TODO",
                todo
            })
        })
        .catch((error)=>{
            // console.log(error.response || `There was an error.`)
            toast.error(error.response?.data,{
                position:toast.POSITION.BOTTOM_RIGHT
            })
        })
    }
}

export const toggleItem = (id) =>{
    return (dispatch) =>{
        axios.put(`${url}/todo/${id}`,{},setHeaders())
        .then((todo)=>{
            dispatch({
                type:"TOGGLE",
                todo
            })
        })
        .catch((error)=>{
            toast.error(error.response?.data,{
                position:toast.POSITION.BOTTOM_RIGHT
            })
            // console.log(error.response || `There was an error.`)
        })
    }
}

export const deleteItem = (id) =>{
    return(dispatch) =>{
        axios.delete(`${url}/todo/${id}`,setHeaders())
        .then(()=>{
            dispatch({
                type:"DELETE_ITEM",
                id
            })
        })
        .catch((error)=>{
            toast.error(error.response?.data,{
                position:toast.POSITION.BOTTOM_RIGHT
            })
            // console.log(error.response || `There was an error.`)
        })
    }
}