import {toast} from 'react-toastify'
import jwtDecode from 'jwt-decode'

const initialState = {
    token:localStorage.getItem("token"),
    name:null,
    email:null,
    _id:null
}

const authReducer = (state=initialState,action) =>{
    
    switch(action.type){
        case "LOAD_USER":    
        case "SIGN_IN":      
        case "SIGN_UP":
            toast.success("Welcome to the todo app.",{
                position:toast.POSITION.BOTTOM_RIGHT
            })   
            const user = jwtDecode(action.token)
            return {
                ...initialState,
                token:action.token,
                name:user.name,
                email:user.email,
                _id:user._id,
            }
            
        case "SIGN_OUT":
            localStorage.removeItem("token")

            toast.success("until next time .... Goodbye ...",{
                position:toast.POSITION.BOTTOM_RIGHT
            })
            return{
                token:null,
                name:null,
                email:null,
                _id:null,
            }
        default:
            return state;
    }
}

export default authReducer