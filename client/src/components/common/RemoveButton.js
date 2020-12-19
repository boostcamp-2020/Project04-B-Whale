/* eslint-disable no-unused-vars */
import React, { useState, useContext } from 'react';
import styled from 'styled-components';
import { Modal, Button } from 'antd';
import BoardDetailContext from '../../context/BoardDetailContext';
import { removeCard } from '../../utils/cardRequest';
import CardContext from '../../context/CardContext';

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
    const { cardState, cardDispatch } = useContext(CardContext);
    const cardData = cardState.data;

    const handleAgree = async () => {
        await removeCard({ cardId });
        setIsModalDisplay(false);
        if (!listId) {
            // cardDispatch({ type: 'REMOVE_CARD', data: null });
            document.location = '/';
            return;
        }
        const listIndex = boardDetail.lists.findIndex((list) => list.id === listId);
        const cardIndex = boardDetail.lists[listIndex].cards.findIndex(
            (card) => card.id === cardId,
        );
        boardDetail.lists[listIndex].cards.splice(cardIndex, 1);
        closeModal();
        setBoardDetail(boardDetail);
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
