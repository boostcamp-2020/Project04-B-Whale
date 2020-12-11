import React, { useContext, useRef, useState } from 'react';
import styled from 'styled-components';
import { IoIosClose } from 'react-icons/io';
import BoardDetailContext from '../../context/BoardDetailContext';
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
    const { boardDetail } = useContext(BoardDetailContext);
    const { lists } = boardDetail;
    // TODO: 현재 카드의 리스트 아이디, 카드 위치로 변경할 것
    const currentListId = 3;
    const currentCardPosition = 1;
    const currentListIndex = lists.findIndex((list) => list.id === currentListId);
    const [selectedList, setSelectedList] = useState(lists[currentListIndex]);
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
        // TODO: context에 저장된 현재 카드 id로 변경할 것
        const cardId = 5;
        const listId = selectedList.id;
        const { selectedIndex } = positionElement.current;
        const { value } = positionElement.current;
        const cardCount = selectedList.cards.length;
        let position = 0;

        if (selectedIndex === 0) {
            position = Number(value) / 2;
        } else if (selectedIndex === cardCount) {
            position = Number(value);
        } else if (selectedList.id !== currentListId) {
            const preValue = positionElement.current[selectedIndex - 1].value;
            position = (Number(value) + Number(preValue)) / 2;
        } else if (selectedIndex + 1 === cardCount) {
            position = Number(value) + 1;
        } else {
            const nextValue = positionElement.current[selectedIndex + 1].value;
            position = (Number(value) + Number(nextValue)) / 2;
        }

        await modifyCardPosition({ cardId, listId, position });
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
                            id="list-select"
                            defaultValue={currentListId}
                            onChange={onChangeList}
                        >
                            {lists.map((list) => (
                                <option key={list.id} value={list.id}>
                                    {list.title}
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
                                    {index + 1}
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
