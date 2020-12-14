import React, { useContext, useRef, useState } from 'react';
import styled from 'styled-components';
import { IoIosClose } from 'react-icons/io';
import BoardDetailContext from '../../context/BoardDetailContext';
import CardContext from '../../context/CardContext';
import { modifyCardPosition } from '../../utils/cardRequest';

const Wrapper = styled.div`
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
`;

const ModalWrapper = styled.div`
    position: absolute;
    top: 2.2em;
    left: 0.6em;
    width: 300px;
    padding: 5px;
    background-color: ${(props) => props.theme.whiteColor};
    border: ${(props) => props.theme.border};
    border-radius: ${(props) => props.theme.radiusSmall};
    z-index: 2;
`;

const ModalHeader = styled.div`
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding-bottom: 5px;
    border-bottom: ${(props) => props.theme.border};
`;

const ModalTitle = styled.div`
    font-size: 18px;
    font-weight: 700;
`;

const ModalBody = styled.div`
    margin-top: 5px;
    padding: 10px;
`;

const SelectWrapper = styled.div`
    display: flex;
    flex-flow: column;
    margin-top: 10px;
    padding: 5px 8px;
    border: ${(props) => props.theme.border};
    border-radius: ${(props) => props.theme.radiusSmall};
    background-color: ${(props) => props.theme.lightGrayColor};
`;

const SelectLabel = styled.label`
    font-weight: 700;
`;

const Select = styled.select`
    background: none;
    font-family: inherit;
    cursor: pointer;
`;

const Button = styled.button.attrs({ type: 'button' })`
    margin-top: 10px;
    padding: 5px 20px;
    border: ${(props) => props.theme.border};
    border-radius: ${(props) => props.theme.radiusSmall};
    background-color: ${(props) => props.theme.redColor};
    color: ${(props) => props.theme.whiteColor};
`;

const MoveModal = ({ onClose }) => {
    const { boardDetail, setBoardDetail } = useContext(BoardDetailContext);
    const { lists } = boardDetail;
    const { cardState, cardDispatch } = useContext(CardContext);
    const cardInfo = cardState.data;
    const currentListId = cardInfo.list.id;
    const currentListIndex = lists.findIndex((list) => list.id === currentListId);
    const cardId = cardInfo.id;
    const currentCardIndex = lists[currentListIndex].cards.findIndex((card) => card.id === cardId);
    const currentCard = lists[currentListIndex].cards[currentCardIndex];
    const currentCardPosition = cardInfo.position;
    const [selectedList, setSelectedList] = useState(lists[currentListIndex]);
    const listElement = useRef();
    const positionElement = useRef();

    const onClickClose = (e) => {
        if (e.target === e.currentTarget) {
            onClose();
        }
    };

    const onChangeList = (e) => {
        const index = e.target.selectedIndex;
        setSelectedList(lists[index]);
    };

    const onClickMoveCard = async () => {
        const listId = selectedList.id;
        const selectedListIndex = listElement.current.selectedIndex;
        const selectedCardIndex = positionElement.current.selectedIndex;
        const value = Number(positionElement.current.value);
        const cardCount = selectedList.cards.length;
        let position = 0;

        if (currentCardPosition === value) {
            onClose();
            return;
        }

        if (selectedCardIndex === 0) {
            position = value / 2;
        } else if (selectedCardIndex === cardCount) {
            position = value;
        } else if (selectedList.id === currentListId && selectedCardIndex + 1 === cardCount) {
            position = value + 1;
        } else {
            const preValue = Number(positionElement.current[selectedCardIndex - 1].value);
            position = (value + preValue) / 2;
        }

        await modifyCardPosition({ cardId, listId, position });
        const newList = { id: selectedList.id, title: selectedList.title };
        const data = { ...cardInfo, position, list: newList };
        cardDispatch({ type: 'CHANGE_POSITION', data });

        const newCard = { ...currentCard, position };
        const newLists = [...lists];
        newLists[currentListIndex].cards.splice(currentCardIndex, 1);
        newLists[selectedListIndex].cards.splice(selectedCardIndex, 0, newCard);
        setBoardDetail({ ...boardDetail, lists: newLists });

        onClose();
    };

    return (
        <>
            <Wrapper onClick={onClickClose} />
            <ModalWrapper>
                <ModalHeader>
                    <div />
                    <ModalTitle>카드 이동</ModalTitle>
                    <IoIosClose size={24} cursor="pointer" onClick={onClose} />
                </ModalHeader>
                <ModalBody>
                    <ModalTitle>목적지 선택</ModalTitle>
                    <SelectWrapper>
                        <SelectLabel htmlFor="list-select">리스트</SelectLabel>
                        <Select
                            ref={listElement}
                            id="list-select"
                            defaultValue={currentListId}
                            onChange={onChangeList}
                        >
                            {lists.map((list) => (
                                <option key={list.id} value={list.id}>
                                    {list.id === currentListId
                                        ? `${list.title} (current)`
                                        : list.title}
                                </option>
                            ))}
                        </Select>
                    </SelectWrapper>
                    <SelectWrapper>
                        <SelectLabel htmlFor="position-select">위치</SelectLabel>
                        <Select
                            ref={positionElement}
                            id="position-select"
                            defaultValue={currentCardPosition}
                        >
                            {selectedList.cards.map((card, index) => (
                                <option key={card.id} value={card.position}>
                                    {card.id === cardId ? `${index + 1} (current)` : index + 1}
                                </option>
                            ))}
                            {currentListId !== selectedList.id && (
                                <option value={selectedList.cards.length + 1}>
                                    {selectedList.cards.length + 1}
                                </option>
                            )}
                        </Select>
                    </SelectWrapper>
                    <Button onClick={onClickMoveCard}>이동</Button>
                </ModalBody>
            </ModalWrapper>
        </>
    );
};

export default MoveModal;
