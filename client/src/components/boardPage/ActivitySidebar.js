/* eslint-disable no-unused-vars */
import React, { useEffect, useContext, useState, Fragment } from 'react';
import styled, { keyframes } from 'styled-components';
import { IoIosClose } from 'react-icons/io';
import { Modal, Button } from 'antd';
import Media from 'react-media';
import ActivityDetail from './ActivityDetail';
import BoardDetailContext from '../../context/BoardDetailContext';
import { getMyInfo } from '../../utils/userRequest';
import { getActivities } from '../../utils/activityRequest';
import { removeBoard, exitBoard } from '../../utils/boardRequest';
import ActivityContext from '../../context/ActivityContext';

const DimmedModal = styled.div`
    display: ${(props) => (props.visible ? 'block' : 'none')};
    position: fixed;
    top: 0;
    left: 0;
    bottom: 0;
    right: 0;
    background-color: rgba(0, 0, 0, 0.6);
    z-index: 1;
`;

const boxOpen = keyframes`
  to {
    margin-left: 80%;
  }
`;

const mediaBoxOpen = keyframes`
    to {
        margin-left: 29%;
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
    z-index: 999;
    @media ${(props) => props.theme.sideBar} {
        animation: none;
        animation: ${(props) => (props.sidebarDisplay ? mediaBoxOpen : boxClose)} ease;
        width: 70%;
        margin-left: 30%;
    }
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
    height: 76%;
    max-height: 80%;
    overflow: auto;
`;

const BoardRemoveExitButton = styled.button`
    width: 100px;
    height: 40px;
    background-color: red;
    border-radius: 6px;
    color: wheat;
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
    const [deleteBoardModalState, setDeleteModalState] = useState(false);

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
        await removeBoard(boardDetail.id);
        document.location = '/';
    };

    const exitBoardHandler = async () => {
        await exitBoard(boardDetail.id);
        document.location = '/';
    };

    const handleAgree = async () => {
        if (myId === boardDetail.creator.id) {
            await removeBoardHandler();
        } else await exitBoardHandler();
    };

    return (
        <>
            <Media
                queries={{
                    small: '(max-width: 590px)',
                }}
            >
                {(matches) => (
                    <>
                        {matches.small && (
                            <DimmedModal
                                visible={sidebarDisplay}
                                onClick={() => setSidebarDisplay(false)}
                            />
                        )}
                    </>
                )}
            </Media>

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
                        <BoardRemoveExitButton onClick={() => setDeleteModalState(true)}>
                            보드 지우기
                        </BoardRemoveExitButton>
                    ) : (
                        <BoardRemoveExitButton onClick={() => setDeleteModalState(true)}>
                            보드 나가기
                        </BoardRemoveExitButton>
                    )}
                </div>
                <Modal
                    visible={deleteBoardModalState}
                    onOk={handleAgree}
                    onCancel={() => setDeleteModalState(false)}
                    style={{ top: '40%', zIndex: '9999' }}
                    footer={[
                        <Button key="no" onClick={() => setDeleteModalState(false)}>
                            아니오
                        </Button>,
                        <Button key="yes" type="primary" onClick={handleAgree}>
                            예
                        </Button>,
                    ]}
                >
                    <p>정말 {myId === boardDetail.creator.id ? '삭제하' : '나가'}시겠습니까?😥</p>
                </Modal>
            </Sidebar>
        </>
    );
};

export default ActivitySidebar;
