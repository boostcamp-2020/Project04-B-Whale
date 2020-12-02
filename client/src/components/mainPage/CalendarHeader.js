import React, { useContext } from 'react';
import styled from 'styled-components';
import { MdChevronLeft, MdChevronRight } from 'react-icons/md';
import { CalendarStatusContext } from '../../context/CalendarContext';

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

    return (
        <HeaderWrapper>
            {/* TODO: button 클릭시, 이전 이후달로 이동 */}
            <DateButton>
                <MdChevronLeft size={30} />
            </DateButton>
            <DateTitle>{selectedDate.format('YYYY.MM')}</DateTitle>
            <DateButton>
                <MdChevronRight size={30} />
            </DateButton>
        </HeaderWrapper>
    );
};

export default CalendarHeader;
