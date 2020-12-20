import React from 'react';
import styled from 'styled-components';
import queryString from 'query-string';
import BoardsProvider from '../provider/BoardsProvider';
import SideBar from './SideBar';
import Header from '../common/header';
import MainWrapper from './MainWrapper';

const Wrapper = styled.div`
    display: flex;
    width: 100%;
    max-width: 1100px;
    margin: 0 auto;
`;
const Main = ({ location }) => {
    const { token } = queryString.parse(location.search);
    if (token) {
        localStorage.setItem('jwt', token);
    }

    return (
        <BoardsProvider>
            <Header />
            <Wrapper>
                <SideBar />
                <MainWrapper />
            </Wrapper>
        </BoardsProvider>
    );
};
export default Main;
