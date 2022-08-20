import {url} from '../../api'
import axios from 'axios'
import {toast} from 'react-toastify'

export const signUp = (user) =>{
    return (dispatch) =>{
        axios.post(`${url}/user/sign-up`,user)
        .then((token)=>{
            localStorage.setItem("token",token.data)
            dispatch({
                type:"SIGN_UP",
                token:token.data
            })
        })
        .catch((error)=>{
            console.log(error.response || `There was an error.`)
            toast.error(error.response?.data,{
                position: toast.POSITION.BOTTOM_RIGHT
            })
        })
    }
}

export const signIn = (cred) =>{
    return(dispatch)=>{
       axios.post(`${url}/user/sign-in`,cred)
       .then((token)=>{
            localStorage.setItem("token",token.data)
            dispatch({
                type:"SIGN_IN",
                token:token.data
            })
       })
        .catch((error)=>{
            console.log(error.response || `something went wrong.`)
            toast.error(error.response?.data,{
                position:toast.POSITION.BOTTOM_RIGHT
            })
            
       })
    }
}

export const signOut = () =>{
    return(dispatch)=>{
       dispatch({
            type:"SIGN_OUT"
       }) 
    }
}

export const loadUser = () =>{
    return(dispatch,getState)=>{
       const token = getState().auth.token
       if(token){
            dispatch({
                type:"LOAD_USER",
                token
            })
       }else{
            return null
       }
    }
}