import React, { useContext, useEffect, useReducer } from 'react';
import moment from 'moment';
import { CalendarStatusContext } from '../../context/CalendarContext';
import { CardScrollStatusContext } from '../../context/CardScrollContext';
import { getCardsByDueDate } from '../../utils/cardRequest';

const cardScrollReducer = (state, action) => {
    switch (action.type) {
        case 'LOADING':
            return {
                loading: true,
                data: null,
                error: null,
            };
        case 'SUCCESS':
            return {
                loading: false,
                data: action.data,
                error: null,
            };
        case 'ERROR':
            return {
                loading: false,
                data: null,
                error: action.error,
            };
        default:
            throw new Error(`Unhandled action type: ${action.type}`);
    }
};

const CardScrollProvider = ({ children }) => {
    const calendarStatus = useContext(CalendarStatusContext);
    const [cardScrollState, cardScrollDispatch] = useReducer(cardScrollReducer, {
        loading: false,
        data: null,
        error: null,
    });

    useEffect(async () => {
        cardScrollDispatch({ type: 'LOADING' });
        try {
            const response = await getCardsByDueDate({
                dueDate: moment(calendarStatus.selectedDate).format('YYYY-MM-DD'),
                member: calendarStatus.member,
            });
            cardScrollDispatch({ type: 'SUCCESS', data: response?.data });
        } catch (error) {
            cardScrollDispatch({ type: 'ERROR', error });
        }
    }, [calendarStatus]);

    return (
        <CardScrollStatusContext.Provider value={cardScrollState}>
            {children}
        </CardScrollStatusContext.Provider>
    );
};

export default CardScrollProvider;
