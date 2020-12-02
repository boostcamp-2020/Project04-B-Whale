import React, { useContext } from 'react';
import styled from 'styled-components';
import { MdChevronLeft, MdChevronRight } from 'react-icons/md';
import { CalendarDispatchContext, CalendarStatusContext } from '../../context/CalendarContext';

const HeaderWrapper = styled.div`
    display: flex;
    justify-content: center;
    align-items: center;
    padding: 12px 8px;
`;

const DateTitle = styled.span`
    padding: 0 12px;
    font-size: 35px;
    font-weight: 700;
`;

const DateButton = styled.button.attrs({ type: 'button' })`
    display: inline-flex;
    background: transparent;
`;

const CalendarHeader = () => {
    const { selectedDate } = useContext(CalendarStatusContext);
    const calendarDispatch = useContext(CalendarDispatchContext);

    const onClickMoveMonth = (next) => {
        const changeDate = selectedDate.clone();
        const date = next ? changeDate.add(1, 'month') : changeDate.subtract(1, 'month');
        calendarDispatch({ type: 'CHANGE_MONTH', date });
    };

    return (
        <HeaderWrapper>
            <DateButton onClick={() => onClickMoveMonth(false)}>
                <MdChevronLeft size={30} />
            </DateButton>
            <DateTitle>{selectedDate.format('YYYY.MM')}</DateTitle>
            <DateButton onClick={() => onClickMoveMonth(true)}>
                <MdChevronRight size={30} />
            </DateButton>
        </HeaderWrapper>
    );
};

export default CalendarHeader;
