import React from 'react';
import styled from 'styled-components';
import { MdChevronLeft, MdChevronRight } from 'react-icons/md';

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
    return (
        <HeaderWrapper>
            {/* TODO: button 클릭시, 이전 이후달로 이동 */}
            <DateButton>
                <MdChevronLeft size={30} />
            </DateButton>
            {/* TODO: 선택된 달을 기준으로 년, 월을 변경할 것 */}
            <DateTitle>2020.11</DateTitle>
            <DateButton>
                <MdChevronRight size={30} />
            </DateButton>
        </HeaderWrapper>
    );
};

export default CalendarHeader;
