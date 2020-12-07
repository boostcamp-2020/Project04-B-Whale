import React, { useContext } from 'react';
import styled from 'styled-components';
import { CardScrollStatusContext } from '../../context/CardScrollContext';
import Card from '../common/Card';

const CardScrollWrapper = styled.div`
    display: grid;
    width: 100%;
    height: 20rem;
    grid-template-columns: 1fr 1fr;
    grid-auto-rows: 200px;
    overflow: scroll;
`;

const CardScroll = () => {
    const { loading, data, error } = useContext(CardScrollStatusContext);

    if (loading || error !== undefined) {
        return null;
    }

    return (
        <CardScrollWrapper>
            {data?.cards?.map((card) => {
                return (
                    <Card
                        width="10rem"
                        height="1rem"
                        key={card?.id}
                        id={card?.id}
                        cardTitle={card?.title}
                        cardDueDate={card?.dueDate}
                        cardCommentCount={card?.commentCount}
                    />
                );
            })}
        </CardScrollWrapper>
    );
};

export default CardScroll;
