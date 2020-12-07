import React from 'react';
import styled, { keyframes } from 'styled-components';
import closeBtn from '../../image/close.svg';
import ActivityDetail from './ActivityDetail';

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
    display: ${(props) => (props.sidebarDisplay ? 'flex' : 'none')};
    position: absolute;
    flex-direction: column;
    top: 80px;
    width: 20%;
    height: 92%;
    margin-left: 100%;
    animation: ${(props) => (props.sidebarDisplay ? boxOpen : boxClose)} ease;
    animation-fill-mode: forwards;
    animation-duration: 0.2s;
    background-color: white;
`;

const SidebarTopMenu = styled.div`
    display: flex;
    justify-content: space-between;
    padding: 20px;
    border-bottom: 1px solid gray;
`;

const SidebarTitle = styled.div`
    display: flex;
    justify-content: center;
`;

const CloseBtn = styled.img`
    width: 15px;
    cursor: pointer;
`;

const ActivitiesWrapper = styled.div`
    padding: 10px;
`;

const ActivitySidebar = ({ sidebarDisplay, setSidebarDisplay }) => {
    const onClose = () => {
        setSidebarDisplay(false);
    };

    const activities = [
        { id: 1, boardId: 1, content: '신동훈님이 현재 보드를 생성하였습니다.' },
        { id: 2, boardId: 1, content: '이건홍님이 현재 보드를 생성하였습니다.' },
        { id: 3, boardId: 1, content: '박수연님이 현재 보드를 생성하였습니다.' },
    ];

    return (
        <Sidebar sidebarDisplay={sidebarDisplay}>
            <SidebarTopMenu>
                <div />
                <SidebarTitle>활동기록</SidebarTitle>
                <CloseBtn src={closeBtn} alt="close" onClick={onClose} />
            </SidebarTopMenu>
            <ActivitiesWrapper>
                {activities.map((v) => {
                    return <ActivityDetail key={v.id} content={v.content} />;
                })}
            </ActivitiesWrapper>
        </Sidebar>
    );
};

export default ActivitySidebar;
