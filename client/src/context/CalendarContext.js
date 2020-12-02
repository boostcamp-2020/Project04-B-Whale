import { createContext } from 'react';
import moment from 'moment';

export const initCalendar = {
    today: moment(),
    currentMonth: moment().month(),
    selectedDate: moment(),
};

export const CalendarReducer = (state, action) => {
    switch (action.type) {
        case 'CHANGE_MONTH': {
            const { date } = action;
            return {
                ...state,
                currentMonth: date.clone().month(),
                selectedDate: date.clone(),
            };
        }
        case 'CHANGE_SELECTED_DATE': {
            const { selectedDate } = action;
            return {
                ...state,
                selectedDate,
            };
        }
        default:
            throw new Error(`Unhandled action type: ${action.type}`);
    }
};

export const CalendarStatusContext = createContext();
export const CalendarDispatchContext = createContext();
