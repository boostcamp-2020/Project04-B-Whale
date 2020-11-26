import React from 'react';
import styled from 'styled-components';
import BoardsProvider from '../provider/BoardsProvider';
import SideBar from './SideBar';

const Wrapper = styled.div`
    width: 1100px;
    margin: 0 auto;
`;

const Main = () => {
    return (
        <Wrapper>
            <BoardsProvider>
                <SideBar />
            </BoardsProvider>
        </Wrapper>
    );
};

export default Main;
