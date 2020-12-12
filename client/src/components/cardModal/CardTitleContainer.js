import React from 'react';
import styled from 'styled-components';

const Wrapper = styled.div`
    display: grid;
    grid-template-columns: 1fr 10fr;
    grid-template-rows: repeat(2, 1fr);
    align-items: center;
    width: 100%;
    height: 5rem;
    margin: 0rem 0rem 2rem 0rem;
`;

const CardTitle = styled.div`
    grid-column-start: 2;
    grid-column-end: 3;
    grid-row-start: 1;
    grid-row-end: 2;
    color: #192b4d;
    font-size: 1.25rem;
    font-weight: bold;
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
    return (
        <Wrapper>
            <CardTitle>{cardTitle}</CardTitle>
            <CardListTitle>포함된 리스트: {cardListTitle}</CardListTitle>
        </Wrapper>
    );
};

export default CardTitleContainer;
