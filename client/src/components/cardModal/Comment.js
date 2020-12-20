import React, { useContext, useRef, useState } from 'react';
import styled from 'styled-components';
import { decode } from 'jsonwebtoken';
import CardContext from '../../context/CardContext';
import { deleteComment, modifyComment } from '../../utils/commentRequest';
import CloseButton from './CloseButton';
import SaveButton from './SaveButton';

const CommentWrapper = styled.div`
    display: grid;
    grid-template-columns: 1fr 10fr;
    align-items: auto;
    width: 100%;
    margin: 1rem 0rem;
`;

const CommentUserProfileImage = styled.img`
    grid-column-start: 1;
    grid-column-end: 2;
    grid-row-start: 1;
    grid-row-end: 2;
    width: 2rem;
    height: 2rem;
    border-radius: 70%;
    overflow: hidden;
`;

const CommentRightContainer = styled.div`
    grid-column-start: 2;
    grid-column-end: 3;
    grid-row-start: 1;
    grid-row-end: 2;
    display: flex;
    flex-direction: column;
    align-items: flex-start;
`;

const CommentTitleContainer = styled.div`
    display: flex;
    align-items: center;
    margin: 0rem 0rem 0.3rem 0.3rem;
`;

const CommentUserName = styled.span`
    color: #192b4d;
    font-weight: bold;
    font-size: 0.9rem;
    margin-right: 0.5rem;
`;

const CommentCreatedAt = styled.span`
    color: #5e6d84;
    font-size: 0.8rem;
`;

const CommentContentContainer = styled.div`
    width: ${(props) => (props.editOpen ? '100%' : 'auto')};
    background-color: white;
    border: 0.1rem solid #ebecef;
    border-radius: 0.2rem;
    box-shadow: 0rem 0.15rem 0.5rem -0.4rem gray;
    padding: 0.5rem;
`;

const CommentContentTextArea = styled.textarea`
    height: 0.9rem;
    color: #192b4d;
    font-size: 0.9rem;
    font-weight: normal;
    resize: none;
`;

const CommentEditDeleteContainer = styled.span`
    margin-left: 0.3rem;
`;

const CommentActionButton = styled.a`
    color: #5e6d84;
    font-size: 0.7rem;
    margin-right: 0.5rem;
    text-decoration: underline;
    &: hover {
        color: #192b4d;
    }
`;

const CommentSaveCloseButtonContainer = styled.div`
    display: ${(props) => (props.visible ? 'flex' : 'none')};
    align-items: center;
`;

const Comment = ({
    commentId,
    userId,
    userName,
    commentCreatedAt,
    commentContent,
    profileImageUrl,
}) => {
    const [editOpen, setEditOpen] = useState(false);
    const [contentState, setContentState] = useState(commentContent);
    const { cardDispatch } = useContext(CardContext);
    const contentTextArea = useRef();

    const userIdFromAccessToken = parseInt(
        decode(localStorage.getItem('jwt').replace(/Bearer /gi, ''))?.userId,
        10,
    );

    const onChange = (e) => {
        if (editOpen) {
            setContentState(e.target.value);
        }
    };

    const onClickEditButton = () => {
        contentTextArea.current.value = contentState;
        setEditOpen(true);
    };

    const onClickCloseButton = () => {
        contentTextArea.current.value = commentContent;
        setEditOpen(false);
    };

    const onClickSaveButton = async () => {
        const response = await modifyComment({ commentId, commentContent: contentState });
        if (response.status !== 200) {
            alert('댓글을 수정할 수 없습니다.');
            return;
        }

        cardDispatch({ type: 'MODIFY_COMMENT', commentId, commentContent: contentState });
        setEditOpen(false);
        contentTextArea.current.value = contentState;
    };

    const onClickDeleteButton = async () => {
        const response = await deleteComment({ commentId });
        if (response.status !== 204) {
            alert('댓글을 삭제할 수 없습니다.');
            return;
        }

        cardDispatch({ type: 'DELETE_COMMENT', commentId });
    };

    return (
        <CommentWrapper>
            <CommentUserProfileImage src={profileImageUrl} />
            <CommentRightContainer>
                <CommentTitleContainer>
                    <CommentUserName>{userName}</CommentUserName>
                    <CommentCreatedAt>{commentCreatedAt}</CommentCreatedAt>
                </CommentTitleContainer>
                <CommentContentContainer editOpen={editOpen}>
                    <CommentContentTextArea
                        defaultValue={commentContent}
                        onChange={onChange}
                        ref={contentTextArea}
                    />
                    <CommentSaveCloseButtonContainer visible={editOpen}>
                        <SaveButton width="3.5rem" height="2rem" onClick={onClickSaveButton}>
                            저장
                        </SaveButton>
                        <CloseButton width="2rem" onClick={onClickCloseButton} />
                    </CommentSaveCloseButtonContainer>
                </CommentContentContainer>
                {!editOpen && userIdFromAccessToken === userId && (
                    <CommentEditDeleteContainer>
                        <CommentActionButton onClick={onClickEditButton}>수정</CommentActionButton>
                        <CommentActionButton onClick={onClickDeleteButton}>
                            삭제
                        </CommentActionButton>
                    </CommentEditDeleteContainer>
                )}
            </CommentRightContainer>
        </CommentWrapper>
    );
};

export default Comment;
