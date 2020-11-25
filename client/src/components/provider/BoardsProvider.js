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
        const { status, data } = await getBoards();

        switch (status) {
            case 200:
                dispatch({ type: 'GET_BOARDS', data });
                break;
            case 400:
            case 401:
                window.location.href = '/login';
                break;
            default:
                throw new Error(`Unhandled status type : ${status}`);
        }
    }, []);

    return (
        <BoardsStatusContext.Provider value={state}>
            <BoardsDispatchContext.Provider value={dispatch}>
                {children}
            </BoardsDispatchContext.Provider>
        </BoardsStatusContext.Provider>
    );
};
