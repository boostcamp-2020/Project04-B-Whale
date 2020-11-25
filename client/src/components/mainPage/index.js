import React from 'react';
import styled from 'styled-components';
import SideBar from './SideBar';

const Wrapper = styled.div`
    width: 1100px;
    margin: 0 auto;
`;

const Main = () => {
    return (
        <Wrapper>
            <SideBar />
        </Wrapper>
    );
};

export default Main;
