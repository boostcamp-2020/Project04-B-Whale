import React from 'react';
import styled from 'styled-components';

const DetailDiv = styled.div`
    margin-bottom: 10px;
`;

const ActivityDetail = ({ content }) => {
    return <DetailDiv>{content}</DetailDiv>;
};

export default ActivityDetail;
