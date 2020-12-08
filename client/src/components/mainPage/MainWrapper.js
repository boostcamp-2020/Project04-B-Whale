import React from 'react';
import styled from 'styled-components';
import CalendarProvider from '../provider/CalendarProvider';
import CardScrollProvider from '../provider/CardScrollProvider';
import Calendar from './Calendar';
import CardScroll from './CardScroll';
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
                <CardScrollProvider>
                    <CardScroll />
                </CardScrollProvider>
            </CalendarProvider>
        </Wrapper>
    );
};

export default MainWrapper;
