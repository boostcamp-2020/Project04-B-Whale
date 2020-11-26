import React, { useContext } from 'react';
import styled from 'styled-components';
import { BoardsStatusContext } from '../../context/BoardsContext';
import Board from './Board';

const Wrapper = styled.div`
    position: absolute;
    width: 200px;
    height: 200px;
    margin: 5px;
    background-color: ${(props) => props.theme.whiteColor};
    border: ${(props) => props.theme.border};
    border-radius: ${(props) => props.theme.radiusSmall};
    overflow: auto;
`;

const BoardTitle = styled.div`
    padding: 5px;
    border-bottom: ${(props) => props.theme.border};
    font-size: 17px;
    font-weight: 700;
`;

const BoardWrapper = styled.ul``;

const BoardsDropdown = () => {
    const { myBoards, invitedBoards } = useContext(BoardsStatusContext);

    return (
        <Wrapper>
            <BoardTitle>내가 만든 보드</BoardTitle>
            <BoardWrapper>
                {myBoards.map((board) => {
                    return <Board key={board.id} id={board.id} title={board.title} />;
                })}
            </BoardWrapper>
            <BoardTitle>초대 받은 보드</BoardTitle>
            <BoardWrapper>
                {invitedBoards.map((board) => {
                    return <Board key={board.id} id={board.id} title={board.title} />;
                })}
            </BoardWrapper>
        </Wrapper>
    );
};

export default BoardsDropdown;
