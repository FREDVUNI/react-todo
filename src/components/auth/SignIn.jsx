import React,{useState} from "react"
import {Navigate} from "react-router-dom"
import {useDispatch,useSelector} from "react-redux"
import { Typography,TextField,Button,makeStyles } from "@material-ui/core"
import {signIn} from "../../store/actions/authActions"

const useStyles = makeStyles({
    formStyle:{
        margin:"0px auto",
        padding:"30px"
    },
    spacing:{
        marginTop:"20px",
    },
    grayStyle:{
        color:"#8f8f8f"
    }
})
 const SignIn = () =>{
    const classes = useStyles()

    const dispatch = useDispatch()
    const auth = useSelector(state => state.auth)

    const [cred,setCred] = useState({
        email:"",
        password:""  
    })

    const handleSubmit = (e) =>{
        e.preventDefault()
        dispatch(signIn(cred))

        setCred({
            email:"",
            password:""
        })
    }
    if(auth._id) return <Navigate to="/"/>
    return(
         <>
            <form noValidate autoComplete="off" className={classes.formStyle} onSubmit={handleSubmit}>
                <Typography variant="h5" className={classes.grayStyle}>sign in</Typography>
                <TextField
                    id="enter-email"
                    label="Enter email address"
                    variant="outlined"
                    fullWidth
                    autoFocus
                    className={classes.spacing}
                    value={cred.email}
                    onChange = {(e)=>setCred({...cred,email:e.target.value})}
                />
                <TextField
                    id="enter-password"
                    type="password"
                    label="Enter password"
                    variant="outlined"
                    fullWidth
                    className={classes.spacing}
                    value={cred.password}
                    onChange = {(e)=>setCred({...cred,password:e.target.value})}
                />
                <Button variant="contained" color="primary" type="submit" className={classes.spacing}>sign in</Button>
            </form>
         </>
     )
 }

 export default SignIn