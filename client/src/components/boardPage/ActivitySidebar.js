import React, { useEffect, useContext, useState } from 'react';
import styled, { keyframes } from 'styled-components';
import { IoIosClose } from 'react-icons/io';
import ActivityDetail from './ActivityDetail';
import BoardDetailContext from '../../context/BoardDetailContext';
import { getMyInfo } from '../../utils/userRequest';

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
    background-color: #f2f2f5;
    position: absolute;
    flex-direction: column;
    top: 80px;
    width: 20%;
    height: 92%;
    margin-left: 100%;
    animation: ${(props) => (props.sidebarDisplay ? boxOpen : boxClose)} ease;
    animation-fill-mode: forwards;
    animation-duration: 0.2s;
    z-index: 9999;
`;

const SidebarTopMenu = styled.div`
    display: flex;
    justify-content: space-between;
    padding: 20px;
`;

const SidebarTitle = styled.div`
    margin: auto;
    display: flex;
    justify-content: center;
`;

const ActivitiesWrapper = styled.div`
    padding: 10px;
    height: 80%;
    max-height: 80%;
    overflow: auto;
`;

const BoardExitButton = styled.button`
    width: 100px;
    height: 40px;
    background-color: red;
`;

const Hr = styled.hr`
    height: 1px;
    margin-bottom: 10px;
    background: #bbb;
    background-image: -webkit-linear-gradient(left, #eee, #777, #eee);
    background-image: -moz-linear-gradient(left, #eee, #777, #eee);
    background-image: -ms-linear-gradient(left, #eee, #777, #eee);
    background-image: -o-linear-gradient(left, #eee, #777, #eee);
`;

const ActivitySidebar = ({ sidebarDisplay, setSidebarDisplay }) => {
    const onClose = () => {
        setSidebarDisplay(false);
    };
    const { boardDetail } = useContext(BoardDetailContext);
    const [myId, setMyId] = useState(0);

    useEffect(async () => {
        const { data } = await getMyInfo();
        setMyId(data.id);
    }, []);

    const activities = [
        { id: 1, boardId: 1, content: '신동훈님이 현재 보드를 생성하였습니다.' },
        { id: 2, boardId: 1, content: '이건홍님이 현재 보드를 생성하였습니다.' },
    ];

    return (
        <Sidebar sidebarDisplay={sidebarDisplay}>
            <SidebarTopMenu>
                <div />
                <SidebarTitle>활동기록</SidebarTitle>
                <IoIosClose size="30" onClick={onClose} style={{ cursor: 'pointer' }} />
            </SidebarTopMenu>
            <Hr />
            <ActivitiesWrapper>
                {activities.map((v) => {
                    return <ActivityDetail key={v.id} content={v.content} />;
                })}
            </ActivitiesWrapper>
            <div style={{ display: 'flex', justifyContent: 'center', marginTop: '20px' }}>
                <BoardExitButton>
                    {myId === boardDetail?.creator?.id ? '보드 지우기' : '보드 나가기'}
                </BoardExitButton>
            </div>
        </Sidebar>
    );
};

export default ActivitySidebar;
