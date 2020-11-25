import React from 'react';
import styled from 'styled-components';

const BoardTitle = styled.li`
    padding: 8px 0;
    margin-bottom: 2px;
    border: ${(props) => props.theme.border};
    font-size: 18px;
    font-weight: 700;
    text-align: center;
    cursor: pointer;
`;

const Board = ({ title }) => {
    return <BoardTitle>{title}</BoardTitle>;
};

export default Board;
