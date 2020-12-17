import React, { useContext } from 'react';
import styled from 'styled-components';
import { RiContactsFill, RiGroupFill } from 'react-icons/ri';
import { BoardsStatusContext } from '../../context/BoardsContext';
import Board from './Board';
import AddBoardButton from './AddBoardButton';

const Wrapper = styled.div`
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
`;

const DropdownWrapper = styled.div`
    position: relative;
    top: 2.9rem;
    left: 0.6em;
    width: 200px;
    height: 200px;
    background-color: ${(props) => props.theme.whiteColor};
    border: ${(props) => props.theme.border};
    border-radius: ${(props) => props.theme.radiusSmall};
    z-index: 2;
`;

const BoardListWrapper = styled.div`
    max-height: 165px;
    overflow: auto;
`;

const BoardTitle = styled.div`
    display: flex;
    padding: 5px;
    border-bottom: ${(props) => props.theme.border};
    font-size: 17px;
    font-weight: 700;
`;

const BoardWrapper = styled.ul``;

const BoardsDropdown = ({ onClose }) => {
    const { myBoards, invitedBoards } = useContext(BoardsStatusContext);

    const onClickClose = (e) => {
        if (e.target === e.currentTarget) {
            onClose();
        }
    };

    return (
        <Wrapper onClick={onClickClose}>
            <DropdownWrapper>
                <BoardListWrapper>
                    <BoardTitle>
                        <RiContactsFill style={{ marginRight: '5px' }} />
                        내가 만든 보드
                    </BoardTitle>
                    <BoardWrapper>
                        {myBoards.map((board) => {
                            return <Board key={board.id} id={board.id} title={board.title} />;
                        })}
                    </BoardWrapper>
                    <BoardTitle>
                        <RiGroupFill style={{ marginRight: '5px' }} />
                        초대 받은 보드
                    </BoardTitle>
                    <BoardWrapper>
                        {invitedBoards.map((board) => {
                            return <Board key={board.id} id={board.id} title={board.title} />;
                        })}
                    </BoardWrapper>
                </BoardListWrapper>
                <AddBoardButton />
            </DropdownWrapper>
        </Wrapper>
    );
};

export default BoardsDropdown;
