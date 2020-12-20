import React, { useContext, useEffect, useReducer } from 'react';
import moment from 'moment';
import { CalendarStatusContext } from '../../context/CalendarContext';
import { CardScrollStatusContext } from '../../context/CardScrollContext';
import { getCardsByDueDate } from '../../utils/cardRequest';
import { initNotification } from '../../utils/contentScript';

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
        const { data: today } = await getCardsByDueDate({
            dueDate: moment(calendarStatus.selectedDate).format('YYYY-MM-DD'),
            member: calendarStatus.member,
        });
        const { data: tomorrow } = await getCardsByDueDate({
            dueDate: moment(calendarStatus.selectedDate).add(1, 'day').format('YYYY-MM-DD'),
            member: calendarStatus.member,
        });

        if (!Array.isArray(today?.cards) || !Array.isArray(tomorrow?.cards)) {
            return;
        }

        const cards = [...today.cards, ...tomorrow.cards];
        const todayCardCount = today?.cards?.length;
        initNotification({ cards, todayCardCount });
    }, []);

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
    }, [calendarStatus.selectedDate, calendarStatus.member]);

    return (
        <CardScrollStatusContext.Provider value={cardScrollState}>
            {children}
        </CardScrollStatusContext.Provider>
    );
};

export default CardScrollProvider;
