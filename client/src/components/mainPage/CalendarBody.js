import React from 'react';
import styled from 'styled-components';
import moment from 'moment';
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
    & > .grayed {
        background-color: ${(props) => props.theme.lightGrayColor};
        color: ${(props) => props.theme.grayColor};
    }
    & > .selected {
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
    const makeCalendar = () => {
        const today = moment();
        const startWeek = today.clone().startOf('month').week();
        const endWeek =
            today.clone().endOf('month').week() === 1 ? 53 : today.clone().endOf('month').week();
        const calendar = [];
        for (let week = startWeek; week <= endWeek; week += 1) {
            calendar.push(
                <Row key={week}>
                    {Array(7)
                        .fill(0)
                        .map((_, i) => {
                            const current = today.clone().week(week).startOf('week').add(i, 'day');
                            const isToday =
                                today.format('YYYYMMDD') === current.format('YYYYMMDD')
                                    ? 'today'
                                    : '';
                            const isGrayed =
                                current.format('MM') === today.format('MM') ? '' : 'grayed';
                            return (
                                <CalendarDate
                                    key={current.format('YYYY-MM-DD')}
                                    className={`${isToday} ${isGrayed}`}
                                    date={current.format('D')}
                                />
                            );
                        })}
                </Row>,
            );
        }
        return calendar;
    };

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
            {makeCalendar()}
        </BodyWrapper>
    );
};

export default CalendarBody;
