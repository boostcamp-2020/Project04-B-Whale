import React from 'react';
import styled, { keyframes } from 'styled-components';

const boxOpen = keyframes`
  to {
    margin-left: 80%;
  }
`;

const boxClose = keyframes`
  to {
    margin-left: 100%;
  }
`;

const Sidebar = styled.div`
    display: ${(props) => (props.sidebarDisplay ? 'block' : 'none')};
    width: 30%;
    margin-left: 100%;
    animation: ${(props) => (props.sidebarDisplay ? boxOpen : boxClose)} ease;
    animation-fill-mode: forwards;
    animation-duration: 0.2s;
    width: 30%;
    height: 70%;
    background-color: white;
`;

const ActivitySidebar = (props) => {
    // eslint-disable-next-line react/destructuring-assignment
    return <Sidebar sidebarDisplay={props.sidebarDisplay}>활동기록 상세</Sidebar>;
};

export default ActivitySidebar;
