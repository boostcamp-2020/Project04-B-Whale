import React from 'react';
import styled from 'styled-components';
import Comment from './Comment';
import CommentInput from './CommentInput';

const CardCommentHeaderContainer = styled.div`
    display: grid;
    grid-template-columns: 1fr 10fr;
    grid-auto-rows: auto;
    align-items: center;
    width: 100%;
    margin: 0rem 0rem 0.3rem 0rem;
`;

const CardCommentHeader = styled.div`
    grid-column-start: 2;
    grid-column-end: 3;
    grid-row-start: 1;
    grid-row-end: 2;
    color: #192b4d;
    font-weight: bold;
`;

const CommentContainer = ({ comments }) => {
    return (
        <>
            <CardCommentHeaderContainer>
                <CardCommentHeader>댓글</CardCommentHeader>
            </CardCommentHeaderContainer>
            <CommentInput />
            {comments.map((comment) => {
                return (
                    <Comment
                        key={comment.id}
                        commentId={comment.id}
                        userId={comment.user.id}
                        userName={comment.user.name}
                        commentCreatedAt={comment.createdAt}
                        commentContent={comment.content}
                        profileImageUrl={comment.user.profileImageUrl}
                    />
                );
            })}
        </>
    );
};

export default CommentContainer;
