import React, { useContext, useState } from 'react';
import styled from 'styled-components';
import { DatePicker } from 'antd';
import moment from 'moment';
import CardModalButton from './CardModalButton';
import CloseButton from './CloseButton';
import CardContext from '../../context/CardContext';
import BoardDetailContext from '../../context/BoardDetailContext';
import { modifyCardDueDate } from '../../utils/cardRequest';
import { addNotification, removeNotification } from '../../utils/contentScript';
import { CalendarDispatchContext, CalendarStatusContext } from '../../context/CalendarContext';

const Wrapper = styled.div`
    display: grid;
    grid-template-columns: 1fr 10fr;
    grid-template-rows: repeat(2, 1fr);
    place-items: center start;
    width: 100%;
    height: 5rem;
    margin: 0rem 0rem 2rem 0rem;
`;

const CardDueDateHeader = styled.div`
    grid-column-start: 2;
    grid-column-end: 3;
    grid-row-start: 1;
    grid-row-end: 2;
    color: #192b4d;
    font-weight: bold;
`;

const CardDueDate = styled(CardModalButton)`
    height: 2rem;
    padding: 0rem 1rem;
    font-size: 0.9rem;
    grid-column-start: 2;
    grid-column-end: 3;
    grid-row-start: 2;
    grid-row-end: 3;
`;

const DatePickerWrapper = styled.div`
    height: 2rem;
    font-size: 0.9rem;
    grid-column-start: 2;
    grid-column-end: 3;
    grid-row-start: 2;
    grid-row-end: 3;
`;

const CardCloseButton = styled(CloseButton)`
    grid-column-start: 2;
    grid-column-end: 3;
    grid-row-start: 3;
    grid-row-end: 4;
`;

const CardDueDateContainer = ({ dueDate }) => {
    const [isDisplay, setIsDisplay] = useState(false);
    const calendarStatus = useContext(CalendarStatusContext);
    const calendarDispatch = useContext(CalendarDispatchContext);
    const { boardDetail, setBoardDetail } = useContext(BoardDetailContext);
    const { lists } = boardDetail;
    const { cardState, cardDispatch } = useContext(CardContext);
    const card = cardState.data;
    const listId = card.list.id;
    const dateFormat = 'YYYY-MM-DD HH:mm:ss';

    const onClickChangeDueDate = async (value) => {
        const cardCount = calendarStatus?.cardCount;
        const cardId = card.id;
        const newDueDate = moment(new Date(value)).format('YYYY-MM-DD HH:mm:ss');
        await modifyCardDueDate({ cardId, dueDate: newDueDate });

        removeNotification(cardId);

        const data = { ...card, dueDate: newDueDate };

        cardDispatch({ type: 'CHANGE_DUEDATE', data });
        addNotification(data);

        if (cardCount) {
            const oldDate = moment(dueDate).format('YYYY-MM-DD');
            const newDate = moment(value).format('YYYY-MM-DD');
            const oldCount = cardCount.find((item) => item.dueDate === oldDate)?.count;
            const newCount = cardCount.find((item) => item.dueDate === newDate)?.count;
            const oldCardCount = { dueDate: oldDate, count: oldCount ? oldCount - 1 : 0 };
            const newCardCount = { dueDate: newDate, count: newCount ? newCount + 1 : 1 };
            const newCardCounts = cardCount.filter(
                (item) => item.dueDate !== oldDate && item.dueDate !== newDate,
            );

            calendarDispatch({
                type: 'CHANGE_DUEDATE',
                cardCount: [...newCardCounts, oldCardCount, newCardCount],
            });
        } else {
            const newBoardDetail = { ...boardDetail };
            const listIndex = lists.findIndex((list) => list.id === listId);
            const cardIndex = lists[listIndex].cards.findIndex(
                (cardInfo) => cardInfo.id === card.id,
            );
            const currentCard = lists[listIndex].cards[cardIndex];
            const newCard = { ...currentCard, dueDate: newDueDate };
            newBoardDetail.lists[listIndex].cards[cardIndex] = newCard;

            setBoardDetail(newBoardDetail);
        }

        setIsDisplay(false);
    };

    return (
        <Wrapper>
            <CardDueDateHeader>마감 기한</CardDueDateHeader>
            <CardDueDate onClick={() => setIsDisplay(true)}>{dueDate}</CardDueDate>
            {isDisplay && (
                <DatePickerWrapper>
                    <DatePicker
                        showTime
                        defaultValue={moment(dueDate, dateFormat)}
                        format={dateFormat}
                        onOk={onClickChangeDueDate}
                        clearIcon={false}
                        autoFocus="autoFocus"
                        inputReadOnly
                    />
                    <CardCloseButton width="2rem" onClick={() => setIsDisplay(false)}>
                        X
                    </CardCloseButton>
                </DatePickerWrapper>
            )}
        </Wrapper>
    );
};

export default CardDueDateContainer;
