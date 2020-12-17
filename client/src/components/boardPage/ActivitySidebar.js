/* eslint-disable no-unused-vars */
import React, { useEffect, useContext, useState } from 'react';
import styled, { keyframes } from 'styled-components';
import { IoIosClose } from 'react-icons/io';
import ActivityDetail from './ActivityDetail';
import BoardDetailContext from '../../context/BoardDetailContext';
import { getMyInfo } from '../../utils/userRequest';
import { getActivities } from '../../utils/activityRequest';
import { removeBoard, exitBoard } from '../../utils/boardRequest';
import ActivityContext from '../../context/ActivityContext';

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
    display: flex;
    background-color: #f2f2f5;
    position: absolute;
    flex-direction: column;
    box-shadow: -5px 5px 5px gray;
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

const BoardRemoveButton = styled.button`
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
    const { activities, setActivities } = useContext(ActivityContext);

    useEffect(async () => {
        const { data } = await getMyInfo();
        setMyId(data.id);
    }, []);

    useEffect(async () => {
        const { data } = await getActivities(boardDetail.id);
        if (!data.activities) return;
        setActivities([...data.activities]);
    }, [boardDetail]);

    const removeBoardHandler = async () => {
        const { status } = await removeBoard(boardDetail.id);
        console.log(status);
        document.location = '/';
    };

    const exitBoardHandler = async () => {
        const { status } = await exitBoard(boardDetail.id);
        console.log(status);
        document.location = '/';
    };

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
                {myId === boardDetail?.creator?.id ? (
                    <BoardRemoveButton onClick={removeBoardHandler}>보드 지우기</BoardRemoveButton>
                ) : (
                    <BoardExitButton onClick={exitBoardHandler}>보드 나가기</BoardExitButton>
                )}
            </div>
        </Sidebar>
    );
};

export default ActivitySidebar;
