/* eslint-disable no-unused-vars */
/* eslint-disable no-param-reassign */
/* eslint-disable jsx-a11y/no-static-element-interactions */
/* eslint-disable jsx-a11y/click-events-have-key-events */
import React, { useContext, useState, useRef, useCallback } from 'react';
import styled from 'styled-components';
import { useDrag, useDrop } from 'react-dnd';
import { AiOutlineMenu } from 'react-icons/ai';
import { Input } from 'antd';
import update from 'immutability-helper';
import AddListOrCard from './AddListOrCard';
import ListMenuDropdown from './ListMenuDropdown';
import { updateListTitle, modifyListPosition } from '../../utils/listRequest';
import BoardDetailContext from '../../context/BoardDetailContext';
import ListMoveDropdown from './ListMoveDropdown';
import Card from '../common/Card';
import CardModal from '../cardModal/CardModal';

const ListWrapper = styled.div`
    background-color: lightgray;
    position: relative;
    margin-right: 10px;
    width: auto;
    height: fit-content;
    display: flex;
    padding: 5px;
    border-radius: 6px;
    flex-direction: column;
    z-index: 1;
    opacity: ${(props) => props.opacity};
    cursor: ${(props) => props.cursor};
    max-height: 98%;
`;

const ListContentWrapper = styled.div`
    display: flex;
    justify-content: space-between;
`;

const TitleDiv = styled.div`
    margin: 0;
    cursor: pointer;
    height: 30px;
    width: 80%;
`;

const InputTitleDiv = styled.div`
    margin: 0;
    cursor: pointer;
    height: 30px;
`;

const ListTitleInput = styled(Input)`
    z-index: 3;
    position: relative;
`;

const CardsWrapper = styled.div`
    margin: auto;
    margin-top: 5px;
    overflow-y: auto;
    overflow-x: hidden;
`;

const FooterAddBtnDiv = styled.div`
    margin: auto;
`;

const DimmedForInput = styled.div`
    display: ${(props) => (props.inputState ? 'inline-block' : 'none')};
    position: fixed;
    top: 0;
    left: 0;
    bottom: 0;
    right: 0;
    z-index: 2;
    cursor: default;
`;

export default function List({ title, id, index, moveList, position }) {
    const [titleInputState, setTitleInputState] = useState(false);
    const [listTitle, setListTitle] = useState(title);
    const [cardModalVisible, setCardModalVisible] = useState(false);
    const [cardId, setCardId] = useState(-1);
    const { boardDetail, setBoardDetail } = useContext(BoardDetailContext);
    const { lists } = boardDetail;
    const [listMenuState, setListMenuState] = useState({
        visible: false,
        offsetY: 0,
        offsetX: 0,
    });

    const [listMoveDropdownState, setListMoveDropdownState] = useState({
        visible: false,
        offsetY: 0,
        offsetX: 0,
    });

    const { cards } = boardDetail.lists[index];

    const updateContextListTitle = () => {
        boardDetail.lists[index].title = listTitle;
        setBoardDetail({ ...boardDetail });
    };

    const changeTitleHandler = () => {
        updateContextListTitle();
        setTitleInputState(false);
    };

    const changeListTitle = async (evt) => {
        if (evt.keyCode !== undefined && evt.keyCode !== 13) return;
        await updateListTitle({ listId: id, title: listTitle });
        boardDetail.lists[index].title = listTitle;
        setBoardDetail({ ...boardDetail });
        setTitleInputState(false);
    };

    const menuClickHandler = (evt) => {
        setListMenuState({
            visible: true,
            offsetX: evt.target.getBoundingClientRect().top,
            offsetY: evt.target.getBoundingClientRect().left,
        });
    };
    const moveCard = useCallback(
        (dragIndex, hoverIndex, dragListId, hoverListId) => {
            const dragListIndex = boardDetail.lists.findIndex((list) => {
                return list.id === dragListId;
            });
            const hoverListIndex = boardDetail.lists.findIndex((list) => {
                return list.id === hoverListId;
            });
            if (dragListId !== hoverListId) {
                const dragCard = boardDetail.lists[dragListIndex].cards[dragIndex];
                boardDetail.lists[dragListIndex].cards.splice(dragIndex, 1);
                if (!boardDetail.lists[dragListIndex].cards.length) {
                    boardDetail.lists[dragListIndex].cards.splice(0, 0, { id: 0 });
                }

                if (!boardDetail.lists[hoverListIndex].cards.length) {
                    boardDetail.lists[hoverListIndex].cards.splice(0, 0, dragCard);
                } else {
                    boardDetail.lists[hoverListIndex].cards.splice(hoverIndex, 0, dragCard);
                }
                setBoardDetail({ ...boardDetail });
            } else {
                const dragCard = boardDetail.lists[index].cards[dragIndex];
                boardDetail.lists[index].cards = update(boardDetail.lists[index].cards, {
                    $splice: [
                        [dragIndex, 1],
                        [hoverIndex, 0, dragCard],
                    ],
                });

                setBoardDetail({
                    ...boardDetail,
                });
            }
        },
        [boardDetail.lists],
    );

    const ref = useRef();
    const [, drop] = useDrop({
        accept: 'list',
        hover(item, monitor) {
            if (!ref.current) {
                return;
            }
            const dragIndex = item.index;
            const hoverIndex = index;
            if (dragIndex === hoverIndex) {
                return;
            }
            const hoverBoundingRect = ref.current?.getBoundingClientRect();
            const hoverMiddleX = (hoverBoundingRect.right - hoverBoundingRect.left) / 2;
            const clientOffset = monitor.getClientOffset();
            const hoverClientX = clientOffset.X - hoverBoundingRect.left;

            if (dragIndex < hoverIndex && hoverClientX < hoverMiddleX) {
                return;
            }
            if (dragIndex > hoverIndex && hoverClientX > hoverMiddleX) {
                return;
            }
            moveList(dragIndex, hoverIndex);
            item.index = hoverIndex;
        },
        async drop(item) {
            let updatedPosition;
            const listLength = boardDetail.lists.length;
            if (item.index === 0) {
                updatedPosition = lists[1].position / 2;
            } else if (item.index === listLength - 1) {
                updatedPosition = lists[listLength - 2].position + 1;
            } else {
                updatedPosition = (lists[index - 1].position + lists[index + 1].position) / 2;
            }
            await modifyListPosition({ listId: item.id, position: updatedPosition });
            lists[index].position = updatedPosition;
        },
    });

    const [{ isDragging }, drag] = useDrag({
        item: { type: 'list', id, index, position, title },
        collect: (monitor) => ({
            isDragging: monitor.isDragging(),
        }),
    });
    const opacity = isDragging ? 0.3 : 1;
    const cursor = isDragging ? '-webkit-grabbing' : 'pointer';
    drag(drop(ref));

    return (
        <>
            <ListWrapper ref={ref} opacity={opacity} cursor={cursor}>
                <ListContentWrapper>
                    {!titleInputState && (
                        <TitleDiv onClick={() => setTitleInputState(true)}>{title}</TitleDiv>
                    )}
                    {titleInputState && (
                        <InputTitleDiv>
                            <ListTitleInput
                                value={listTitle}
                                onChange={(evt) => setListTitle(evt.target.value)}
                                onKeyDown={changeListTitle}
                                autoFocus="autoFocus"
                            />
                            <DimmedForInput
                                inputState={titleInputState}
                                onClick={changeListTitle}
                            />
                        </InputTitleDiv>
                    )}
                    <AiOutlineMenu onClick={menuClickHandler} style={{ cursor: 'pointer' }} />
                </ListContentWrapper>
                <CardsWrapper>
                    {boardDetail.lists[index].cards?.map((v, cardInd) => (
                        <Card
                            width="230px"
                            height="60px"
                            id={v.id}
                            key={v.id}
                            index={cardInd}
                            listId={boardDetail.lists[index].id}
                            fontSize={{ titleSize: '1rem', dueDateSize: '11px' }}
                            cardTitle={v.title}
                            cardDueDate={v.dueDate}
                            cardCommentCount={v.commentCount}
                            moveCard={moveCard}
                            onClick={(e) =>
                                ((_e, _cardId) => {
                                    setCardId(_cardId);
                                    setCardModalVisible(true);
                                })(e, v.id)
                            }
                            draggable
                        />
                    ))}
                </CardsWrapper>
                <FooterAddBtnDiv>
                    <AddListOrCard parent="card" id={id} />
                </FooterAddBtnDiv>
            </ListWrapper>
            {listMenuState.visible && (
                <ListMenuDropdown
                    listId={id}
                    listMenuState={listMenuState}
                    setListMenuState={setListMenuState}
                    listMoveDropdownState={listMoveDropdownState}
                    setListMoveDropdownState={setListMoveDropdownState}
                />
            )}
            {listMoveDropdownState.visible && (
                <ListMoveDropdown
                    listId={id}
                    listMenuState={listMenuState}
                    setListMenuState={setListMenuState}
                    listMoveDropdownState={listMoveDropdownState}
                    setListMoveDropdownState={setListMoveDropdownState}
                />
            )}
            {cardModalVisible && (
                <CardModal
                    visible={cardModalVisible}
                    closeModal={() => {
                        setCardModalVisible(false);
                    }}
                    cardId={cardId}
                />
            )}
        </>
    );
}
