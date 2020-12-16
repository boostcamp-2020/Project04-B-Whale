/* eslint-disable no-param-reassign */
/* eslint-disable no-unused-vars */
import React, { useContext, useRef } from 'react';
import { useDrag, useDrop } from 'react-dnd';
import styled from 'styled-components';
import BoardDetailContext from '../../context/BoardDetailContext';
import { modifyCardPosition } from '../../utils/cardRequest';

const CardWrapper = styled.div`
    display: flex;
    flex-direction: column;
    justify-content: center;
    opacity: ${(props) => props.opacity};
    cursor: ${(props) => props.cursor};
    width: ${(props) => props.width};
    height: ${(props) => props.height};
    padding-left: 1rem;
    border-radius: 1rem;
    box-shadow: 0 0.2rem 0rem ${(props) => props.theme.lightGrayColor};
    color: #586069;
    background-color: white;
    margin-bottom: 10px;
    &:hover {
        /* background-color: ${(props) => props.theme.lightGrayColor}; */
    }
`;

const CardTitle = styled.div`
    font-size: ${(props) => (props.fontSize?.titleSize ? props.fontSize?.titleSize : '2rem')};
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
    margin: 0 1rem 0 0;
    font-size: ${(props) => (props.fontSize?.dueDateSize ? props.fontSize.dueDateSize : '')};
`;

const CardCommentCount = styled.div`
    display: flex;
    align-items: center;
    justify-content: center;
    width: 2rem;
    height: 1.5rem;
    padding: 0 1rem;
`;

const Card = ({
    id,
    index,
    moveCard,
    width,
    height,
    listId,
    cardTitle,
    cardDueDate,
    cardCommentCount,
    fontSize,
    onClick,
    draggable,
}) => {
    const { boardDetail } = useContext(BoardDetailContext);
    const cardRef = useRef(null);
    const [, drop] = draggable
        ? useDrop({
              accept: 'card',
              hover(item, monitor) {
                  if (!cardRef.current) {
                      return;
                  }
                  const dragIndex = item.index;
                  const hoverIndex = index;
                  const dragListId = item.listId;
                  const hoverListId = listId;
                  if (dragListId === hoverListId && dragIndex === hoverIndex) {
                      return;
                  }
                  const hoverBoundingRect = cardRef.current?.getBoundingClientRect();
                  const hoverMiddleY = (hoverBoundingRect.bottom - hoverBoundingRect.top) / 2;
                  const clientOffset = monitor.getClientOffset();
                  const hoverClientY = clientOffset.y - hoverBoundingRect.top;

                  if (
                      dragListId === hoverListId &&
                      dragIndex < hoverIndex &&
                      hoverClientY < hoverMiddleY
                  ) {
                      return;
                  }
                  if (
                      dragListId === hoverListId &&
                      dragIndex > hoverIndex &&
                      hoverClientY > hoverMiddleY
                  ) {
                      return;
                  }
                  item.index = hoverIndex;
                  item.listId = hoverListId;
                  moveCard(dragIndex, hoverIndex, dragListId, hoverListId);
              },
              async drop(item) {
                  let updatedPosition;
                  const listInd = boardDetail.lists.findIndex((list) => list.id === item.listId);
                  const cardLength = boardDetail.lists[listInd].cards.length;
                  if (cardLength < 2) return;
                  if (item.index === 0) {
                      updatedPosition = boardDetail.lists[listInd].cards[1].position / 2;
                  } else if (item.index === cardLength - 1) {
                      updatedPosition =
                          boardDetail.lists[listInd].cards[cardLength - 2].position + 1;
                  } else {
                      updatedPosition =
                          (boardDetail.lists[listInd].cards[item.index - 1].position +
                              boardDetail.lists[listInd].cards[item.index + 1].position) /
                          2;
                  }
                  if (!updatedPosition) updatedPosition = 1;
                  await modifyCardPosition({
                      cardId: item.id,
                      listId: item.listId,
                      position: updatedPosition,
                  });
              },
          })
        : [];

    const [{ isDragging }, drag] = draggable
        ? useDrag({
              item: { type: 'card', id, index, listId },
              collect: (monitor) => ({
                  isDragging: monitor.isDragging(),
              }),
          })
        : [{ isDragging: null }, null];

    let opacity = isDragging ? 0.3 : 1;
    const cursor = isDragging ? '-webkit-grabbing' : 'pointer';
    if (draggable) {
        drag(drop(cardRef));
    }
    if (id === 0) {
        height = '1px';
        opacity = 0;
    }
    return (
        <CardWrapper
            ref={draggable && cardRef}
            opacity={opacity}
            cursor={cursor}
            width={width}
            height={height}
            onClick={onClick}
        >
            <CardTitle fontSize={fontSize}>{cardTitle}</CardTitle>
            <CardDueDateCommentCountFlexBox>
                <CardDueDate fontSize={fontSize}>{cardDueDate}</CardDueDate>
                <CardCommentCount>{cardCommentCount}</CardCommentCount>
            </CardDueDateCommentCountFlexBox>
        </CardWrapper>
    );
};

export default Card;
