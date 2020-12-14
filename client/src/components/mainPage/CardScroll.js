import React, { useContext } from 'react';
import moment from 'moment-timezone';
import styled from 'styled-components';
import { CardScrollStatusContext } from '../../context/CardScrollContext';
import Card from '../common/Card';

const CardScrollWrapper = styled.div`
    display: grid;
    width: 100%;
    height: 20rem;
    grid-template-columns: 1fr 1fr;
    grid-auto-rows: 10rem;
    grid-row-gap: 0.6rem;
    grid-column-gap: 0.6rem;
    overflow-y: scroll;
    background-color: #ebecf0;
    border-radius: 1rem;
    padding: 0.5rem;
    margin: 10px 0;
`;

const CardScroll = () => {
    const { loading, data, error } = useContext(CardScrollStatusContext);

    if (loading || error !== null) {
        return null;
    }

    return (
        <CardScrollWrapper>
            {data?.cards?.map((card) => {
                return (
                    <Card
                        key={card?.id}
                        cardTitle={card?.title}
                        cardDueDate={moment
                            .tz(card?.dueDate, 'Asia/Seoul')
                            .format('YYYY-MM-DD HH:mm:ss')}
                        cardCommentCount={card?.commentCount}
                    />
                );
            })}
        </CardScrollWrapper>
    );
};

export default CardScroll;
