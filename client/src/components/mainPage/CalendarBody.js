import React from 'react';
import styled from 'styled-components';
import CalendarDate from './CalendarDate';

const BodyWrapper = styled.div`
    padding: 8px;
`;

const Row = styled.div`
    display: flex;
    justify-content: space-around;

    & > .today {
        background-color: ${(props) => props.theme.lightRedColor};
        color: ${(props) => props.theme.whiteColor};
    }
    & > .past {
        background-color: ${(props) => props.theme.lightGrayColor};
    }
    & > .clickedDate {
        background-color: ${(props) => props.theme.blueColor};
        color: ${(props) => props.theme.whiteColor};
    }
`;

const Day = styled.div`
    display: felx;
    justify-content: center;
    align-items: center;
    width: calc(100% / 7);
    margin: 5px;
    padding: 5px 0;
    border: ${(props) => props.theme.border};
    font-size: 35px;
    font-weight: 700;

    &:first-child {
        color: ${(props) => props.theme.redColor};
    }
    &:last-child {
        color: ${(props) => props.theme.blueColor};
    }
`;

const CalendarBody = () => {
    return (
        <BodyWrapper>
            <Row>
                <Day>일</Day>
                <Day>월</Day>
                <Day>화</Day>
                <Day>수</Day>
                <Day>목</Day>
                <Day>금</Day>
                <Day>토</Day>
            </Row>
            {/* TODO: 선택된 달을 기준으로 달력을 변경할 것 */}
            <Row>
                <CalendarDate className="past" date={1} />
                <CalendarDate className="past" date={2} />
                <CalendarDate className="today" date={3} />
                <CalendarDate date={4} />
                <CalendarDate date={5} />
                <CalendarDate className="clickedDate" date={6} />
                <CalendarDate date={7} />
            </Row>
            <Row>
                <CalendarDate date={8} />
                <CalendarDate date={9} />
                <CalendarDate date={10} count={2} />
                <CalendarDate date={11} />
                <CalendarDate date={12} />
                <CalendarDate date={13} />
                <CalendarDate date={14} count={1} />
            </Row>
        </BodyWrapper>
    );
};

export default CalendarBody;
