import React from 'react';
import { Link } from 'react-router-dom';
import styled from 'styled-components';

const BoardTitle = styled.li`
    padding: 7px 10px;
    margin-bottom: 2px;
    border-bottom: ${(props) => props.theme.border};
    font-size: 18px;
    cursor: pointer;
    text-overflow: ellipsis;
    overflow-x: hidden;
`;

const Board = ({ id, title, closeHandler }) => {
    return (
        <Link to={`/board/${id}`}>
            <BoardTitle onClick={closeHandler}>{title}</BoardTitle>
        </Link>
    );
};

export default Board;
