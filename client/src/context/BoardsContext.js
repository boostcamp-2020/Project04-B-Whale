import { createContext } from 'react';

export const initBoards = {
    myBoards: [],
    invitedBoards: [],
};

export const BoardsReducer = (state, action) => {
    switch (action.type) {
        case 'GET_BOARDS': {
            const boards = action.data;
            return {
                ...state,
                ...boards,
            };
        }
        case 'MODIFY_BOARD': {
            const boards = action.data;
            return {
                ...state,
                ...boards,
            };
        }
        default:
            throw new Error(`Unhandled action type: ${action.type}`);
    }
};

export const BoardsStatusContext = createContext();
export const BoardsDispatchContext = createContext();
