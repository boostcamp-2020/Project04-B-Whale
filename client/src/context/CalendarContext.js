import { createContext } from 'react';
import moment from 'moment';

export const initCalendar = {
    today: moment(),
    selectedDate: moment(),
    cardCount: [],
    member: 'me',
};

export const CalendarReducer = (state, action) => {
    switch (action.type) {
        case 'GET_INIT_CARD_COUNT': {
            const { cardCount } = action;
            return {
                ...state,
                cardCount,
            };
        }
        case 'CHANGE_MONTH': {
            const { date, cardCount } = action;
            return {
                ...state,
                selectedDate: date.clone(),
                cardCount,
            };
        }
        case 'CHANGE_SELECTED_DATE': {
            const { selectedDate } = action;
            return {
                ...state,
                selectedDate,
            };
        }
        case 'CHANGE_MEMBER': {
            const { isMember, cardCount } = action;
            return {
                ...state,
                member: isMember,
                cardCount,
            };
        }
        case 'CHANGE_DUEDATE': {
            const { cardCount } = action;
            return {
                ...state,
                cardCount,
            };
        }
        default:
            throw new Error(`Unhandled action type: ${action.type}`);
    }
};

export const CalendarStatusContext = createContext();
export const CalendarDispatchContext = createContext();
