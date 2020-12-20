import React, { useState } from 'react';
import BoardDetailContext from '../../context/BoardDetailContext';

const BoardDetailProvider = ({ children }) => {
    const [boardDetail, setBoardDetail] = useState({});

    return (
        <BoardDetailContext.Provider value={{ boardDetail, setBoardDetail }}>
            {children}
        </BoardDetailContext.Provider>
    );
};

export default BoardDetailProvider;
