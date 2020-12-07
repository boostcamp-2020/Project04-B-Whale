import React from 'react';
import styled from 'styled-components';

const CardWrapper = styled.div`
    display: flex;
    flex-direction: column;
    justify-content: center;
    width: ${(props) => props.cardWidth};
    height: ${(props) => props.cardHeight};
    border: 0.1rem solid ${(props) => props.theme.blackColor};
    padding-left: 1rem;
`;

const CardTitle = styled.div`
    font-size: 2rem;
    margin-bottom: 0.5rem;
`;

const CardDueDateCommentCountFlexBox = styled.div`
    display: flex;
`;

const CardDueDate = styled.div`
    display: flex;
    align-items: center;
    justify-content: center;
    height: 1.5rem;
    padding: 0 1rem 0 1rem;
    border: 0.1rem solid ${(props) => props.theme.lightGrayColor};
    margin: 0 1rem 0 0;
`;

const CardCommentCount = styled.div`
    display: flex;
    align-items: center;
    justify-content: center;
    width: 2rem;
    height: 1.5rem;
    padding: 0 1rem 0 1rem;
    border: 0.1rem solid ${(props) => props.theme.lightGrayColor};
`;

const Card = ({ cardWidth, cardHeight, cardTitle, cardDueDate, cardCommentCount }) => {
    return (
        <CardWrapper cardWidth={cardWidth} cardHeight={cardHeight}>
            <CardTitle>{cardTitle}</CardTitle>
            <CardDueDateCommentCountFlexBox>
                <CardDueDate>{cardDueDate}</CardDueDate>
                <CardCommentCount>{cardCommentCount}</CardCommentCount>
            </CardDueDateCommentCountFlexBox>
        </CardWrapper>
    );
};

export default Card;
