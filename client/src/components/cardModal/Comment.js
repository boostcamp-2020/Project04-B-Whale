import React, { useState } from 'react';
import styled from 'styled-components';
import CloseButton from './CloseButton';
import SaveButton from './SaveButton';

const CommentWrapper = styled.div`
    display: grid;
    grid-template-columns: 1fr 10fr;
    align-items: auto;
    width: 100%;
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
    display: ${(props) => (props.visible ? 'inline-block' : 'none')};
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

const Comment = ({ userName, commentCreatedAt, commentContent }) => {
    const [editOpen, setEditOpen] = useState(false);

    const inverseEditOpen = () => {
        setEditOpen(!editOpen);
    };

    return (
        <CommentWrapper>
            <CommentRightContainer>
                <CommentTitleContainer>
                    <CommentUserName>{userName}</CommentUserName>
                    <CommentCreatedAt>{commentCreatedAt}</CommentCreatedAt>
                </CommentTitleContainer>
                <CommentContentContainer editOpen={editOpen}>
                    <CommentContentTextArea defaultValue={commentContent} />
                    <CommentSaveCloseButtonContainer visible={editOpen}>
                        <SaveButton width="3.5rem" height="2rem">
                            저장
                        </SaveButton>
                        <CloseButton width="2rem" onClick={inverseEditOpen} />
                    </CommentSaveCloseButtonContainer>
                </CommentContentContainer>
                <CommentEditDeleteContainer visible={!editOpen}>
                    <CommentActionButton onClick={inverseEditOpen}>수정</CommentActionButton>
                    <CommentActionButton>삭제</CommentActionButton>
                </CommentEditDeleteContainer>
            </CommentRightContainer>
        </CommentWrapper>
    );
};

export default Comment;
