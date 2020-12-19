import React, { useState, useContext } from 'react';
import styled from 'styled-components';
import { Modal, Button } from 'antd';
import BoardDetailContext from '../../context/BoardDetailContext';
import { removeCard } from '../../utils/cardRequest';
import { CardScrollStatusContext } from '../../context/CardScrollContext';
import { CalendarDispatchContext, CalendarStatusContext } from '../../context/CalendarContext';

const Wrapper = styled.div`
    position: relative;
`;

const DeleteButton = styled.button`
    background-color: red;
    color: white;
    padding: 5px 10px;
    width: 7em;
    border: ${(props) => props.theme.border};
`;

const RemoveButton = ({ cardId, listId, closeModal }) => {
    const [isModalDisplay, setIsModalDisplay] = useState(false);
    const { boardDetail, setBoardDetail } = useContext(BoardDetailContext);
    const calendarStatus = useContext(CalendarStatusContext);
    const calendarDispatch = useContext(CalendarDispatchContext);
    const cardScrollState = useContext(CardScrollStatusContext);

    const handleAgree = async () => {
        await removeCard({ cardId });
        setIsModalDisplay(false);

        if (cardScrollState) {
            const { cards } = cardScrollState.data;
            const cardIndex = cards.findIndex((card) => card.id === cardId);
            cards.splice(cardIndex, 1);

            const { cardCount } = calendarStatus;
            const selectedDate = calendarStatus.selectedDate.format('YYYY-MM-DD');
            const oldCount = cardCount.find((item) => item.dueDate === selectedDate)?.count;
            const deleteCardCount = { dueDate: selectedDate, count: oldCount - 1 };
            const newCardCount = cardCount.filter((card) => card.dueDate !== selectedDate);
            calendarDispatch({
                type: 'DELETE_CARD',
                cardCount: [...newCardCount, deleteCardCount],
            });

            closeModal();
            return;
        }

        const listIndex = boardDetail.lists.findIndex((list) => list.id === listId);
        const cardIndex = boardDetail.lists[listIndex].cards.findIndex(
            (card) => card.id === cardId,
        );
        boardDetail.lists[listIndex].cards.splice(cardIndex, 1);
        setBoardDetail(boardDetail);

        closeModal();
    };

    return (
        <Wrapper>
            <DeleteButton onClick={() => setIsModalDisplay(true)}>카드 삭제</DeleteButton>
            <Modal
                visible={isModalDisplay}
                onOk={handleAgree}
                onCancel={() => setIsModalDisplay(false)}
                style={{ top: '40%', zIndex: '9999' }}
                footer={[
                    <Button key="no" onClick={() => setIsModalDisplay(false)}>
                        아니오
                    </Button>,
                    <Button key="yes" type="primary" onClick={handleAgree}>
                        예
                    </Button>,
                ]}
            >
                <p>정말 삭제하시겠습니까?😥</p>
            </Modal>
        </Wrapper>
    );
};

export default RemoveButton;
