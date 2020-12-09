import React, { useEffect, useReducer } from 'react';
import {
    initBoards,
    BoardsReducer,
    BoardsStatusContext,
    BoardsDispatchContext,
} from '../../context/BoardsContext';
import { getBoards } from '../../utils/boardRequest';

export default ({ children }) => {
    const [state, dispatch] = useReducer(BoardsReducer, initBoards);

    useEffect(async () => {
        const { data } = await getBoards();

        dispatch({ type: 'GET_BOARDS', data });
    }, []);

    return (
        <BoardsStatusContext.Provider value={state}>
            <BoardsDispatchContext.Provider value={dispatch}>
                {children}
            </BoardsDispatchContext.Provider>
        </BoardsStatusContext.Provider>
    );
};
