import React from 'react';
import styled from 'styled-components';
import CalendarHeader from './CalendarHeader';
import CalendarBody from './CalendarBody';

const CalendarWrapper = styled.div`
    margin: 20px 5px;
    margin-bottom: 10px;
    border: ${(props) => props.theme.border};
    border-radius: ${(props) => props.theme.radius};

    @media ${(props) => props.theme.sideBar} {
        margin: 10px;
    }
`;

const Calendar = () => {
    return (
        <CalendarWrapper>
            <CalendarHeader />
            <CalendarBody />
        </CalendarWrapper>
    );
};

export default Calendar;
