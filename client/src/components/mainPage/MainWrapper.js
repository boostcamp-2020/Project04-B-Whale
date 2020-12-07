import React from 'react';
import styled from 'styled-components';
import CalendarProvider from '../provider/CalendarProvider';
import Calendar from './Calendar';
import MeCheckBox from './MeCheckBox';

const Wrapper = styled.div`
    width: 100%;
`;

const MainWrapper = () => {
    return (
        <Wrapper>
            <CalendarProvider>
                <Calendar />
                <MeCheckBox />
                카드 영역
            </CalendarProvider>
        </Wrapper>
    );
};

export default MainWrapper;
