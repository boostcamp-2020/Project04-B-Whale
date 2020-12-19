import React, { useContext, useEffect, useReducer } from 'react';
import styled from 'styled-components';
import CardDescriptionContainer from './CardDescriptionContainer';
import CardDueDateContainer from './CardDueDateContainer';
import CardTitleContainer from './CardTitleContainer';
import CommentContainer from './CommentContainer';
import CardMemberContainer from './CardMemberContainer';
import MemberButton from '../common/MemberButton';
import MoveButton from '../common/MoveButton';
import RemoveButton from '../common/RemoveButton';
import { getCard } from '../../utils/cardRequest';
import CardContext from '../../context/CardContext';
import BoardDetailContext from '../../context/BoardDetailContext';
import { getDetailBoard } from '../../utils/boardRequest';

const DimmedModal = styled.div`
    display: ${(props) => (props.visible ? 'block' : 'none')};
    position: fixed;
    top: 0;
    left: 0;
    bottom: 0;
    right: 0;
    background-color: rgba(0, 0, 0, 0.6);
    z-index: 1;
`;

const ModalWrapper = styled.div`
    display: ${(props) => (props.visible ? 'block' : 'none')};
    position: fixed;
    top: 0;
    right: 0;
    bottom: 0;
    left: 0;
    z-index: 2;
    overflow: auto;
    outline: 0;
`;

const ModalInner = styled.div`
    display: grid;
    grid-template-columns: 3fr 1fr;
    width: 40%;
    height: 80%;
    background-color: #f4f5f7;
    position: absolute;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    padding: 1rem;
    border-radius: 0.2rem;
    overflow-y: scroll;
    min-width: 385px;
`;

const CardModalLeftSideBar = styled.div`
    grid-column-start: 1;
    grid-column-end: 2;
`;

const CardModalRightSideBar = styled.div`
    display: flex;
    flex-direction: column;
    align-items: center;
    grid-column-start: 2;
    grid-column-end: 3;
    button {
        margin: 0.2rem 0rem;
    }
`;

const ButtonList = styled.div`
    display: flex;
    flex-direction: column;
    align-items: center;
    margin-top: 5rem;
`;

const cardReducer = (state, action) => {
    switch (action.type) {
        case 'LOADING':
            return {
                loading: true,
                data: null,
                error: null,
            };
        case 'SUCCESS':
            return {
                loading: false,
                data: action.data,
                error: null,
            };
        case 'CHANGE_MEMBER':
            return {
                ...state,
                data: action.data,
            };
        case 'CHANGE_POSITION':
            return {
                ...state,
                data: action.data,
            };
        case 'CHANGE_DUEDATE':
            return {
                ...state,
                data: action.data,
            };
        case 'CHANGE_CARD_STATE':
            return {
                ...state,
                data: action.data,
            };
        case 'MODIFY_COMMENT':
            const { comments } = state.data;
            const { commentId } = action;
            const { commentContent } = action;
            comments.forEach((comment) => {
                if (comment.id === commentId) {
                    comment.content = commentContent;
                }
            });
            return {
                ...state,
            };
        case 'ERROR':
            return {
                loading: false,
                data: null,
                error: action.error,
            };
        default:
            throw new Error(`Unhandled action type: ${action.type}`);
    }
};

const CardModal = ({ visible, closeModal, cardId, listId }) => {
    if (visible) document.getElementById('root').style.overflow = 'hidden';

    const { boardDetail, setBoardDetail } = useContext(BoardDetailContext);
    const [cardState, cardDispatch] = useReducer(cardReducer, {
        loading: false,
        data: null,
        error: null,
    });

    useEffect(async () => {
        cardDispatch({ type: 'LOADING' });
        try {
            const response = await getCard({ cardId });
            cardDispatch({ type: 'SUCCESS', data: response?.data });
            if (Object.keys(boardDetail).length === 0) {
                const { data } = await getDetailBoard(response.data.board.id);
                setBoardDetail(data);
            }
        } catch (error) {
            cardDispatch({ type: 'ERROR', error });
        }
    }, []);

    if (cardState.loading || cardState.error !== null || cardState.data === null) {
        return null;
    }

    const card = cardState.data;

    const onDimmedClick = (e) => {
        if (e.target === e.currentTarget) {
            closeModal();
        }
    };
    return (
        <>
            <CardContext.Provider value={{ cardState, cardDispatch }}>
                <DimmedModal visible={visible} />
                <ModalWrapper
                    onWheel={(e) => e.stopPropagation()}
                    onClick={onDimmedClick}
                    visible={visible}
                >
                    <ModalInner>
                        <CardModalLeftSideBar>
                            <CardTitleContainer
                                cardTitle={card.title}
                                cardListTitle={card.list.title}
                            />
                            <CardMemberContainer members={card.members} />
                            <CardDueDateContainer dueDate={card.dueDate} />
                            <CardDescriptionContainer cardContent={card.content} />
                            <CommentContainer comments={card.comments} />
                        </CardModalLeftSideBar>
                        <CardModalRightSideBar>
                            <ButtonList>
                                <MemberButton />
                                <MoveButton />
                                <RemoveButton
                                    cardId={cardId}
                                    listId={listId}
                                    closeModal={closeModal}
                                />
                            </ButtonList>
                        </CardModalRightSideBar>
                    </ModalInner>
                </ModalWrapper>
            </CardContext.Provider>
        </>
    );
};

export default CardModal;
