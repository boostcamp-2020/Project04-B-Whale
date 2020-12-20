import React, { useContext } from 'react';
import styled from 'styled-components';
import CalendarDate from './CalendarDate';
import { CalendarDispatchContext, CalendarStatusContext } from '../../context/CalendarContext';
import { getCardCount } from '../../utils/cardRequest';

const BodyWrapper = styled.div`
    padding: 8px;
`;

const Row = styled.div`
    display: flex;
    justify-content: space-around;

    & > .grayed {
        background-color: ${(props) => props.theme.lightGrayColor};
        color: ${(props) => props.theme.grayColor};
    }
    & > .today {
        background-color: ${(props) => props.theme.lightRedColor};
        color: ${(props) => props.theme.whiteColor};
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
    const { today, selectedDate, cardCount, member } = useContext(CalendarStatusContext);
    const calendarDispatch = useContext(CalendarDispatchContext);

    const onClickChangeSelectedDate = async (date) => {
        if (selectedDate.format('MM') !== date.format('MM')) {
            const startDate = date.clone().startOf('month').startOf('week').format('YYYY-MM-DD');
            const endDate = date.clone().endOf('month').endOf('week').format('YYYY-MM-DD');
            const { data } = await getCardCount({ startDate, endDate, member });
            calendarDispatch({ type: 'CHANGE_MONTH', date, data, cardCount: data.cardCounts });
        }
        calendarDispatch({ type: 'CHANGE_SELECTED_DATE', selectedDate: date });
    };

    const makeCalendar = () => {
        const startWeek = selectedDate.clone().startOf('month').week();
        const endWeek =
            selectedDate.clone().endOf('month').week() === 1
                ? 53
                : selectedDate.clone().endOf('month').week();
        const calendar = [];
        for (let week = startWeek; week <= endWeek; week += 1) {
            calendar.push(
                <Row key={week}>
                    {Array(7)
                        .fill(0)
                        .map((_, i) => {
                            const current = selectedDate
                                .clone()
                                .startOf('month')
                                .week(week)
                                .startOf('week')
                                .add(i, 'day');
                            const isToday =
                                current.format('YYYYMMDD') === today.format('YYYYMMDD')
                                    ? 'today'
                                    : '';
                            const isSelected =
                                current.format('MMDD') === selectedDate.format('MMDD')
                                    ? 'selected'
                                    : '';
                            const isGrayed =
                                current.format('MM') === selectedDate.format('MM') ? '' : 'grayed';
                            const existCard = cardCount.find(
                                (ele) => ele.dueDate === current.format('YYYY-MM-DD'),
                            );
                            return (
                                <CalendarDate
                                    key={current.format('YYYY-MM-DD')}
                                    className={`${isToday} ${isSelected} ${isGrayed}`}
                                    onClick={onClickChangeSelectedDate}
                                    date={current}
                                    count={existCard && existCard.count}
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
