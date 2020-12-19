/* eslint-disable no-unused-vars */
import React, { useContext, useState } from 'react';
import styled from 'styled-components';
import CardContext from '../../context/CardContext';
import { modifyCardTitle } from '../../utils/cardRequest';
import boardDetailContext from '../../context/BoardDetailContext';

const Wrapper = styled.div`
    display: grid;
    grid-template-columns: 1fr 10fr;
    grid-template-rows: repeat(2, 1fr);
    align-items: center;
    width: 100%;
    height: 5rem;
    margin: 0rem 0rem 2rem 0rem;
`;

const CardTitle = styled.input`
    grid-column-start: 2;
    grid-column-end: 3;
    grid-row-start: 1;
    grid-row-end: 2;
    width: 100%;
    color: #192b4d;
    font-size: 1.25rem;
    font-weight: bold;
    background-color: transparent;
    border-radius: 0.2rem;
    &: focus {
        background-color: white;
        border: 0.15rem solid #0379bf;
        margin: -0.15rem;
    }
`;

const CardListTitle = styled.div`
    grid-column-start: 2;
    grid-column-end: 3;
    grid-row-start: 2;
    grid-row-end: 3;
    padding-bottom: 1rem;
    color: #5e6d84;
    font-size: 0.9rem;
`;

const CardTitleContainer = ({ cardTitle, cardListTitle }) => {
    const { cardState, cardDispatch } = useContext(CardContext);
    const [cardTitleInput, setCardTitleInput] = useState(cardTitle);
    const card = cardState.data;
    const { boardDetail, setBoardDetail } = useContext(boardDetailContext);

    const onChange = (e) => {
        setCardTitleInput(e.target.value);
    };

    const onBlur = async () => {
        await modifyCardTitle({ cardId: card.id, cardTitle: cardTitleInput });
        cardDispatch({
            type: 'CHANGE_CARD_STATE',
            data: {
                ...card,
                title: cardTitleInput,
            },
        });
        const listIndex = boardDetail.lists.findIndex((list) => list.id === card.list.id);
        const cardIndex = boardDetail.lists[listIndex].cards.findIndex((c) => c.id === card.id);
        boardDetail.lists[listIndex].cards[cardIndex].title = cardTitleInput;
        setBoardDetail({ ...boardDetail });
    };

    return (
        <Wrapper>
            <CardTitle defaultValue={cardTitle} onChange={onChange} onBlur={onBlur} />
            <CardListTitle>포함된 리스트: {cardListTitle}</CardListTitle>
        </Wrapper>
    );
};

export default CardTitleContainer;
