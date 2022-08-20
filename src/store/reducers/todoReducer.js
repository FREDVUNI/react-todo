import { toast } from 'react-toastify'

const todoReducer = (state=[],action) =>{
    switch(action.type){
        case "GET_ITEMS":
            return action.toDos.data

        case "ADD_TODO":
            toast.success('The item has been added.',{
                position:toast.POSITION.BOTTOM_RIGHT
            })
            return [action.todo.data,...state]
        
        case "TOGGLE":
            toast.success("Item status has been changed.",{
                position:toast.POSITION.BOTTOM_RIGHT
            })
            return state.map((todo)=> todo._id === action.todo.data._id ? action.todo.data: todo)
            
        case "UPDATE_TODO":
            toast.success('The item has been updated.',{
                position:toast.POSITION.BOTTOM_RIGHT
            })

            return state.map((todo) => todo._id === action.todo.data._id ? action.todo.data : todo)
        
        case "DELETE_ITEM":
            toast.success("Item has been deleted.",{
                position:toast.POSITION.BOTTOM_RIGHT
            })
            return state.filter((todo)=> todo._id !== action.id )
            
        default:
            return state    
    }
}

export default todoReducer