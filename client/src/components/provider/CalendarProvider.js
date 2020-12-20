import React, { useEffect, useReducer } from 'react';
import {
    initCalendar,
    CalendarReducer,
    CalendarStatusContext,
    CalendarDispatchContext,
} from '../../context/CalendarContext';
import { getCardCount } from '../../utils/cardRequest';

export default ({ children }) => {
    const [state, dispatch] = useReducer(CalendarReducer, initCalendar);

    useEffect(async () => {
        const startDate = state.today.clone().startOf('month').startOf('week').format('YYYY-MM-DD');
        const endDate = state.today.clone().endOf('month').endOf('week').format('YYYY-MM-DD');
        const { member } = state;
        const { data } = await getCardCount({ startDate, endDate, member });

        dispatch({ type: 'GET_INIT_CARD_COUNT', cardCount: data.cardCounts });
    }, []);

    return (
        <CalendarStatusContext.Provider value={state}>
            <CalendarDispatchContext.Provider value={dispatch}>
                {children}
            </CalendarDispatchContext.Provider>
        </CalendarStatusContext.Provider>
    );
};
