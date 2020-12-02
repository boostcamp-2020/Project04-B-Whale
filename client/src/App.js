import React from 'react';
import { BrowserRouter, Route } from 'react-router-dom';
import Main from './components/mainPage';
import Login from './components/loginPage';
import Board from './components/boardPage';
import BoardDetailProvider from './components/provider/BoardDetailProvider';

const App = () => {
    return (
        <BrowserRouter>
            <Route exact path="/" component={Main} />
            <Route exact path="/login" component={Login} />
            <BoardDetailProvider>
                <Route exact path="/board/:id" component={Board} />
            </BoardDetailProvider>
        </BrowserRouter>
    );
};

export default App;
