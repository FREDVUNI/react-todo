import React,{useState} from "react"
import {signUp} from "../../store/actions/authActions"
import {useDispatch,useSelector} from "react-redux"
import {Navigate} from "react-router-dom"
import { Typography,TextField,Button,makeStyles } from "@material-ui/core"

const useStyles = makeStyles({
    formStyle:{
        margin:"0px auto",
        padding:"30px",
    },
    spacing:{
        marginTop:"20px",
    },
    grayStyle:{
        color:"#8f8f8f"
    }
})
 const SignUp = () =>{
    const classes = useStyles()
    const dispatch = useDispatch()

    const [user,setUser] = useState({
        name:"",
        email:"",
        password:""
     })

    const auth = useSelector((state)=>state.auth)
    console.log(auth)

     const handleSubmit = (e) =>{
        e.preventDefault()
        dispatch(signUp(user))

        setUser({
            name:"",
            email:"",
            password:"",
        })
     }
    if(auth._id) return <Navigate to="/"/>
    
     return(
         <>
            <form noValidate autoComplete="off" className={classes.formStyle} onSubmit={handleSubmit}>
                <Typography variant="h5" className={classes.grayStyle}>sign up</Typography>
                <TextField
                    id="enter-name"
                    label="Enter name "
                    variant="outlined"
                    fullWidth
                    autoFocus
                    className={classes.spacing}
                    value={user.name}
                    onChange={(e)=>{setUser({...user,name:e.target.value})}}
                />
                <TextField
                    id="enter-email"
                    label="Enter email address"
                    variant="outlined"
                    fullWidth
                    className={classes.spacing}
                    value={user.email}
                    onChange={(e)=>{setUser({...user,email:e.target.value})}}
                />
                <TextField
                    id="enter-password"
                    type="password"
                    label="Enter password"
                    variant="outlined"
                    fullWidth
                    className={classes.spacing}
                    value={user.password}
                    onChange={(e)=>{setUser({...user,password:e.target.value})}}
                />
                <Button variant="contained" color="primary" type="submit" className={classes.spacing}>sign up</Button>
            </form>
         </>  
     )
 }

 export default SignUp