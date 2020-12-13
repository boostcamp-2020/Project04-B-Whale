import React, { useState } from 'react';
import styled from 'styled-components';
import SaveButton from './SaveButton';

const Wrapper = styled.div`
    display: grid;
    grid-template-columns: 1fr 10fr;
    grid-auto-rows: auto;
    align-items: center;
    width: 100%;
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
    display: ${(props) => (props.visible ? 'inline-block' : 'none')};
    margin-top: 1rem;
`;

const CommentInput = () => {
    const [isOnFocus, setIsOnFocus] = useState(false);

    const onFocus = () => {
        if (!isOnFocus) {
            setIsOnFocus(!isOnFocus);
        }
    };
    const onBlur = () => {
        if (isOnFocus) {
            setIsOnFocus(!isOnFocus);
        }
    };

    return (
        <Wrapper>
            <CommentInputTextAreaWrapper>
                <CommentInputTextArea
                    placeholder="댓글을 입력해주세요."
                    onFocus={onFocus}
                    onBlur={onBlur}
                />
                <CommentInputSaveButton width="3.5rem" height="2rem" visible={isOnFocus}>
                    저장
                </CommentInputSaveButton>
            </CommentInputTextAreaWrapper>
        </Wrapper>
    );
};

export default CommentInput;
