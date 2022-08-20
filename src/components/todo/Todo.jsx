import React from "react"
import { Button,Typography,ButtonGroup,makeStyles } from '@material-ui/core'
import { Create,Delete,CheckCircle } from '@material-ui/icons'
import {useDispatch} from 'react-redux'
import { toggleItem,deleteItem } from '../../store/actions/todoActions'

const useStyles = makeStyles({
    todoStyle:{
        margin:"20px auto",
        padding:"20px",
        border: "0.5px solid #ccc",
        borderRadius:"9px",
        display:"flex",
        justifyContent:"space-between"
    },
    grayStyle:{
        color:"#8f8f8f"
    },
    isComplete:{
        color:"green",
    },
    checked:{
        textDecoration:"line-through"
    }
})

 const Todo = ({todo,setTodo}) =>{
    const classes = useStyles()
    const dispatch = useDispatch()

    const handleUpdate = (e) =>{
        setTodo(todo)

        window.scrollTo({
            top:0,
            left:0,
            behavior:"smooth"
        })
    }

    const handleToggle = (id) =>{
        dispatch(toggleItem(id))
    }

    const handleDelete = (id) =>{
        dispatch(deleteItem(id))
    }
     return(
        <>
        <div className={classes.todoStyle}>
            <div>
                {
                    todo.isComplete ?
                    (<Typography variant="subtitle1" className={classes.checked}>
                        {todo.name}
                    </Typography>)
                    :
                    (<Typography variant="subtitle1">
                        {todo.name}
                    </Typography>)
                }
                <Typography variant="body2" className={classes.grayStyle}>Author: {todo.author}</Typography>
                <Typography variant="body2" className={classes.grayStyle}>Added: {new Date(todo.date).toLocaleString()}</Typography>
            </div>
            <div>
                <ButtonGroup size="small" aria-label="outlined primary button group">
                    <Button onClick={() => handleToggle(todo._id)}>
                        {todo.isComplete ? 
                        
                            <CheckCircle className={classes.isComplete}/>
                            :
                            <CheckCircle/>
                        }
                    </Button>
                    <Button>
                        <Create onClick={()=>handleUpdate()}/>
                    </Button>
                    <Button>
                        <Delete onClick ={ ()=>handleDelete(todo._id) }/>
                    </Button>
                </ButtonGroup>
            </div>
        </div>
        </>
     )
 }

 export default Todo