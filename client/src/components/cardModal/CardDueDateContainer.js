import React from 'react';
import styled from 'styled-components';
import CardModalButton from './CardModalButton';

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

const CardDueDateContainer = ({ dueDate }) => {
    return (
        <Wrapper>
            <CardDueDateHeader>마감 기한</CardDueDateHeader>
            <CardDueDate>{dueDate}</CardDueDate>
        </Wrapper>
    );
};

export default CardDueDateContainer;
