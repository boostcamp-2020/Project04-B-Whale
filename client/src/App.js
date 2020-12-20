import React from 'react';
import { BrowserRouter, Route } from 'react-router-dom';
import Main from './components/mainPage';
import Login from './components/loginPage';
import Board from './components/boardPage';

const App = () => {
    return (
        <BrowserRouter>
            <Route exact path="/" component={Main} />
            <Route exact path="/login" component={Login} />
            <Route exact path="/board/:id" component={Board} />
        </BrowserRouter>
    );
};

export default App;
