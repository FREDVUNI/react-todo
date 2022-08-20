import React from 'react'
import { useDispatch } from 'react-redux'
import {TextField,Button} from '@material-ui/core'
import {makeStyles} from '@material-ui/core/styles'
import { Send } from '@material-ui/icons'
import { addTodo,updateTodo } from '../../store/actions/todoActions'

const useStyles = makeStyles({
    formStyle:{
        margin:"0px auto",
        // padding:"30px",
        borderRadius:"9px",
        border:"1px solid rgba(194, 224, 255, 0.08)",  
        display:"flex",
        justifyContent:"space-between"
    },
    inputStyle:{
        backgroundColor:"transparent",
        outline:"none",
        borderColor:"red",
    },
    submitButton:{
        marginLeft:"20px"
    } 
})

const AddTodo = ({todo,setTodo}) =>{
    const classes = useStyles()
    const dispatch = useDispatch()
    
    const submitHandler = (e) =>{
        e.preventDefault()
        if(todo._id){
            const id = todo._id

            const updatedTodo ={
                name:todo.name,  
                isComplete:todo.isComplete,
                date:todo.date,
                author:todo.author,
                uid:todo.uid,
            }
            dispatch(updateTodo(updatedTodo,id))

        }else{
            const newTodo ={
                ...todo,
                date: new Date()
            }
            dispatch(addTodo(newTodo))
        }

        setTodo({
            name:"",
            isComplete:false
        })
    }
    return(
        <>
            <form noValidate autoComplete="off" className={classes.formStyle} onSubmit={submitHandler}>
                <TextField
                 id="enter-todo"
                 variant="outlined"
                 label="Enter todo item"
                 autoFocus  
                 fullWidth
                 className={classes.inputStyle}
                 value={todo.name}
                 onChange={(e)=>{setTodo({...todo,name:e.target.value})}}
                />
                <Button className={classes.submitButton} color="primary" variant="contained" type="submit">
                    <Send/>
                </Button>
            </form>
        </>
    )
}

export default AddTodo
