import React from 'react';

const Board = ({ match }) => {
    const { id } = match.params;
    return <div>보드 상세 페이지 - boardId : {id}</div>;
};

export default Board;
