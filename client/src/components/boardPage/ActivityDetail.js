import React from 'react';
import styled from 'styled-components';

const DetailDiv = styled.div`
    margin-bottom: 10px;
`;

const ActivityDetail = (props) => {
    // eslint-disable-next-line react/destructuring-assignment
    return <DetailDiv>{props.content}</DetailDiv>;
};

export default ActivityDetail;
