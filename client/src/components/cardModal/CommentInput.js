import React, { useContext, useState, useRef } from 'react';
import styled from 'styled-components';
import SaveButton from './SaveButton';
import CardContext from '../../context/CardContext';
import { addComment } from '../../utils/commentRequest';

const Wrapper = styled.div`
    display: grid;
    grid-template-columns: 1fr 10fr;
    grid-auto-rows: auto;
    align-items: center;
    width: 100%;
    margin-bottom: 2rem;
`;

const CommentInputTextAreaWrapper = styled.div`
    grid-column-start: 2;
    grid-column-end: 3;
    grid-row-start: 1;
    grid-row-end: 2;
    width: 100%;
    background-color: white;
    border: 0.1rem solid #ebecef;
    border-radius: 0.2rem;
    box-shadow: 0rem 0.15rem 0.5rem -0.4rem gray;
    padding: 0.5rem;
`;

const CommentInputTextArea = styled.textarea`
    display: block;
    width: 100%;
    height: 0.9rem;
    color: #192b4d;
    font-size: 0.9rem;
    font-weight: normal;
    resize: none;
`;

const CommentInputSaveButton = styled(SaveButton)`
    margin-top: 1rem;
`;

const CommentInput = () => {
    const saveButton = useRef();
    const [isOnFocus, setIsOnFocus] = useState(false);
    const [commentInputState, setCommentInputState] = useState('');
    const { cardState, cardDispatch } = useContext(CardContext);
    const card = cardState.data;

    const onFocus = () => {
        if (!isOnFocus) {
            setIsOnFocus(!isOnFocus);
        }
    };
    const onBlur = (e) => {
        if (e.relatedTarget !== saveButton.current && isOnFocus) {
            setIsOnFocus(!isOnFocus);
        }
    };

    const onClick = async () => {
        const response = await addComment({ cardId: card.id, content: commentInputState });
        card.comments.push({
            id: response.data.id,
            createdAt: response.data.createdAt,
            content: response.data.content,
            user: {
                name: response.data.user.name,
            },
        });
        cardDispatch({ type: 'CHANGE_CARD_STATE', data: card });
        setIsOnFocus(!isOnFocus);
        setCommentInputState('');
    };

    const onChange = (e) => {
        setCommentInputState(e.target.value);
    };

    return (
        <Wrapper>
            <CommentInputTextAreaWrapper>
                <CommentInputTextArea
                    placeholder="댓글을 입력해주세요."
                    onFocus={onFocus}
                    onBlur={onBlur}
                    onChange={onChange}
                    value={commentInputState}
                />
                {isOnFocus && (
                    <CommentInputSaveButton
                        width="3.5rem"
                        height="2rem"
                        onClick={onClick}
                        _ref={saveButton}
                    >
                        저장
                    </CommentInputSaveButton>
                )}
            </CommentInputTextAreaWrapper>
        </Wrapper>
    );
};

export default CommentInput;
