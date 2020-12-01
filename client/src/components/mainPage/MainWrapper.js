import React from 'react';
import styled from 'styled-components';
import Calendar from './Calendar';

const Wrapper = styled.div`
    width: 100%;
`;

const MainWrapper = () => {
    return (
        <Wrapper>
            <Calendar />
            카드 영역
        </Wrapper>
    );
};

export default MainWrapper;
