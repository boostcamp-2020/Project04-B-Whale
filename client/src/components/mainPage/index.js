import React from 'react';
import styled from 'styled-components';
import BoardsProvider from '../provider/BoardsProvider';
import SideBar from './SideBar';
import Header from '../common/header';

const Wrapper = styled.div`
    width: 1100px;
    margin: 0 auto;
`;

const Main = () => {
    return (
        <Wrapper>
            <BoardsProvider>
                <Header />
                <SideBar />
            </BoardsProvider>
        </Wrapper>
    );
};

export default Main;
