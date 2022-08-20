import React from "react"
import {useSelector,useDispatch} from "react-redux"
import {AppBar,Typography,Toolbar,Button} from "@material-ui/core"
import { makeStyles } from "@material-ui/core" 
import { Link,useNavigate } from "react-router-dom"
import {signOut} from "../../store/actions/authActions"

const useStyles = makeStyles({
    root:{
        flexGrow:1,
    },
    linkStyle:{
        color:"#555",
        textDecoration:"none"
    },
    back:{
        background: "rgba(255,255,255,0.95)",
        borderBottom:"rgba(194, 224, 255, 0.08)",
        boxShadow:"none" 
    }
})

 const NavBar = () =>{
    const classes = useStyles()
    const state = useSelector(state=>state)
    const auth = useSelector(state=>state.auth)
    console.log(state)

    const navigate = useNavigate()
    const dispatch = useDispatch()  

    const handleLogout = () =>{
        dispatch(signOut())
        navigate("/sign-in")
    }   

     return(
         <>
            <AppBar position="static" className={classes.back}>
                <Toolbar>
                    <Typography variant="h4" className={classes.root}>
                        <Link className={classes.linkStyle} to="/">Todo app</Link>
                    </Typography>
                    {auth._id ? (
                        <>
                            <Typography variant="subtitle2" className={classes.root} style={{color:"#555"}}>
                                Logged in as {auth.name}
                            </Typography>
                            <Button onClick={()=>handleLogout()} className={classes.linkStyle}>sign out</Button>
                        </>
                    ):(
                        <>
                            <Button>
                                <Link to="/sign-in" className={classes.linkStyle}>sign in</Link>
                            </Button>
                            <Button>
                                <Link to="/sign-up" className={classes.linkStyle}>sign up</Link>
                            </Button>
                        </>
                    )}
                    
                </Toolbar>
            </AppBar>
         </>
     )
 }

 export default NavBar