import React from 'react';
import styled from 'styled-components';
import Header from '../common/header';
import TopMenu from './TopMenu';

const MainContents = styled.div`
    height: 100%;
    width: 100%;
    background-color: ${(props) => props.backgroundColor};
`;

const Board = ({ match }) => {
    const { id } = match.params;

    return (
        <>
            <Header />
            <MainContents backgroundColor="gray">
                <TopMenu />
                보드 상세 페이지 - boardId : {id}
            </MainContents>
        </>
    );
};

export default Board;
