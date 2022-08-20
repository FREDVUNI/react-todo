import React,{useEffect} from 'react'
import {useDispatch,useSelector} from 'react-redux'
import { Typography,makeStyles } from "@material-ui/core"
import {getTodo} from '../../store/actions/todoActions'

import Todo from "./Todo"
const useStyles = makeStyles({
    todoStyle:{
        margin:"20px auto",
        padding:"20px",
        borderRadius:"9px",
        border:"1px solid #ccc"
    }
})

const ListTodo = ({setTodo}) => {
    const dispatch = useDispatch()
    const toDos = useSelector((state)=>state.toDos)
    // console.log(toDos)

    useEffect(()=>{
        dispatch(getTodo())
    },[dispatch])

    const classes = useStyles()
    return (
        <>
            <div className={classes.todoStyle}>
                <Typography variant="h5">
                    {toDos.length > 0 ? 'What\'s your main focus today?':'There currently no items available.'}
                </Typography>
                {
                    toDos && toDos.map((todo)=>{
                        return(
                            <Todo todo={todo} key={todo._id} setTodo={setTodo}/>
                        )
                    })
                }
            </div>
        </>
    )
}

export default ListTodo




