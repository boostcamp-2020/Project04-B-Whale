import React, { useReducer } from 'react';
import {
    initCalendar,
    CalendarReducer,
    CalendarStatusContext,
    CalendarDispatchContext,
} from '../../context/CalendarContext';

export default ({ children }) => {
    const [state, dispatch] = useReducer(CalendarReducer, initCalendar);

    return (
        <CalendarStatusContext.Provider value={state}>
            <CalendarDispatchContext.Provider value={dispatch}>
                {children}
            </CalendarDispatchContext.Provider>
        </CalendarStatusContext.Provider>
    );
};
