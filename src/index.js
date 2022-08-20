import React from 'react';
import ReactDOM from 'react-dom/client';
import App from './App';

import { Provider } from 'react-redux'
import { createStore,applyMiddleware } from 'redux'
import thunk from 'redux-thunk'
import rootReducer from './store/reducers/rootReducer'

//redux thunk is a middleware that helps you call action creators as functions and not objects

const store = createStore(rootReducer,applyMiddleware(thunk))

const root = ReactDOM.createRoot(document.getElementById('root'));
root.render(
    <Provider store={store}>
        <App />
    </Provider>
);