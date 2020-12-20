import React from 'react';
import styled from 'styled-components';

const DetailDiv = styled.div``;

const DueDateDiv = styled.div`
    font-size: 14px;
    margin-bottom: 10px;
    color: gray;
`;

const ActivityDetail = ({ content, createdAt }) => {
    return (
        <>
            <DetailDiv>{content}</DetailDiv>
            <DueDateDiv>{createdAt}</DueDateDiv>
        </>
    );
};

export default ActivityDetail;
