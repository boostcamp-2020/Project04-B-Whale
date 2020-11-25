import React from 'react';
import styled from 'styled-components';
import Board from './Board';

const Wrapper = styled.div`
    width: 20%;
    padding: 5px;

    @media ${(props) => props.theme.sideBar} {
        display: none;
    }
`;

const BoardTitle = styled.div`
    margin-top: 40px;
    margin-bottom: 15px;
    font-size: 20px;
    font-weight: 700;
`;

const BoardWrapper = styled.ul``;

const AddBoardButton = styled.button`
    width: 100%;
    padding: 3px 0;
    border: ${(props) => props.theme.border};
    font-size: 18px;
    font-weight: 700;
    text-align: center;
`;

const SideBar = () => {
    return (
        <Wrapper>
            <BoardTitle>내가 만든 보드</BoardTitle>
            <BoardWrapper>
                <Board title="보드 1" />
                <Board title="보드 2" />
            </BoardWrapper>
            <AddBoardButton>+ 보드 추가하기</AddBoardButton>
            <BoardTitle>초대 받은 보드</BoardTitle>
            <BoardWrapper>
                <Board title="보드 3" />
                <Board title="보드 4" />
            </BoardWrapper>
        </Wrapper>
    );
};

export default SideBar;
