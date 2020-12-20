import React, { useContext, useState } from 'react';
import moment from 'moment-timezone';
import styled from 'styled-components';
import { CardScrollStatusContext } from '../../context/CardScrollContext';
import Card from '../common/Card';
import CardModal from '../cardModal/CardModal';
import BoardDetailProvider from '../provider/BoardDetailProvider';

const CardScrollWrapper = styled.div`
    display: ${(props) => (props.visible ? 'grid' : 'none')};
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
    @media ${(props) => props.theme.sideBar} {
        grid-template-columns: 1fr;
    }
`;

const CardScroll = () => {
    const [cardId, setCardId] = useState(-1);
    const [cardModalVisible, setCardModalVisible] = useState(false);
    const { loading, data, error } = useContext(CardScrollStatusContext);

    if (loading || error !== null) {
        return null;
    }
    const visible = !!data?.cards?.length;

    return (
        <>
            <CardScrollWrapper visible={visible}>
                {data?.cards?.map((card) => {
                    return (
                        <Card
                            key={card?.id}
                            cardTitle={card?.title}
                            cardDueDate={moment
                                .tz(card?.dueDate, 'Asia/Seoul')
                                .format('YYYY-MM-DD HH:mm:ss')}
                            cardCommentCount={card?.commentCount}
                            onClick={(e) =>
                                ((_e, _cardId) => {
                                    setCardId(_cardId);
                                    setCardModalVisible(true);
                                })(e, card?.id)
                            }
                        />
                    );
                })}
            </CardScrollWrapper>
            {cardModalVisible && (
                <BoardDetailProvider>
                    <CardModal
                        visible={cardModalVisible}
                        closeModal={() => {
                            setCardModalVisible(false);
                            document.getElementById('root').style.overflow = 'auto';
                        }}
                        cardId={cardId}
                    />
                </BoardDetailProvider>
            )}
        </>
    );
};

export default CardScroll;
