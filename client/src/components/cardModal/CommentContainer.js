import React from 'react';
import styled from 'styled-components';
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

const CommentContainer = () => {
    return (
        <>
            <CardCommentHeaderContainer>
                <CardCommentHeader>댓글</CardCommentHeader>
            </CardCommentHeaderContainer>
            <CommentInput />
        </>
    );
};

export default CommentContainer;
