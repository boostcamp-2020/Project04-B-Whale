/* eslint-disable no-unused-vars */
import React, { useContext, useEffect, useState, useCallback } from 'react';
import { DndProvider } from 'react-dnd';
import { HTML5Backend } from 'react-dnd-html5-backend';
import update from 'immutability-helper';
import styled from 'styled-components';
import Header from '../common/header';
import TopMenu from './TopMenu';
import ActivitySidebar from './ActivitySidebar';
import InvitedDropdown from './InvitedUserDropdown';
import { getDetailBoard } from '../../utils/boardRequest';
import BoardDetailContext from '../../context/BoardDetailContext';
import AskOverDropdown from './AskOverDropdown';
import AddListOrCard from './AddListOrCard';
import List from './List';

const MainContents = styled.div`
    height: 92%;
    width: 100%;
    background-color: ${(props) => props.backgroundColor};
`;

const Wrapper = styled.div`
    display: flex;
    margin-left: 10px;
    max-width: 100%;
    overflow-x: scroll;
    height: 90%;
`;

const ListWrapper = styled.div``;

const Board = ({ match }) => {
    const { id } = match.params;
    const [sidebarDisplay, setSidebarDisplay] = useState(false);
    const [invitedDropdownDisplay, setInvitedDropdownDisplay] = useState({
        visible: false,
        offsetY: 0,
        offsetX: 0,
    });

    const [askoverDropdownDisplay, setAskoverDropdownDisplay] = useState({
        visible: false,
        offsetY: 0,
        offsetX: 0,
    });
    const { boardDetail, setBoardDetail } = useContext(BoardDetailContext);

    const moveList = useCallback(
        (dragIndex, hoverIndex) => {
            const dragList = boardDetail.lists[dragIndex];
            setBoardDetail({
                ...boardDetail,
                lists: update(boardDetail.lists, {
                    $splice: [
                        [dragIndex, 1],
                        [hoverIndex, 0, dragList],
                    ],
                }),
            });
        },
        [boardDetail.lists],
    );

    useEffect(async () => {
        const { status, data } = await getDetailBoard(id);
        console.log(status);
        setBoardDetail(data);
    }, []);

    return (
        <>
            <Header />
            <MainContents backgroundColor={boardDetail.color}>
                <TopMenu
                    sidebarDisplay={sidebarDisplay}
                    setSidebarDisplay={setSidebarDisplay}
                    setInvitedDropdownDisplay={setInvitedDropdownDisplay}
                    setAskoverDropdownDisplay={setAskoverDropdownDisplay}
                />
                <Wrapper>
                    {Boolean(boardDetail.lists?.length) && (
                        <DndProvider backend={HTML5Backend}>
                            <ListWrapper style={{ display: 'flex' }}>
                                {boardDetail.lists.map((list, index) => {
                                    return (
                                        <List
                                            key={list.id}
                                            id={list.id}
                                            index={index}
                                            title={list.title}
                                            moveList={moveList}
                                        />
                                    );
                                })}
                            </ListWrapper>
                        </DndProvider>
                    )}
                    <AddListOrCard parent="list" />
                </Wrapper>
                <ActivitySidebar
                    sidebarDisplay={sidebarDisplay}
                    setSidebarDisplay={setSidebarDisplay}
                />
                {invitedDropdownDisplay?.visible && (
                    <InvitedDropdown
                        invitedDropdownDisplay={invitedDropdownDisplay}
                        setInvitedDropdownDisplay={setInvitedDropdownDisplay}
                    />
                )}
                {askoverDropdownDisplay.visible && (
                    <AskOverDropdown
                        askoverDropdownDisplay={askoverDropdownDisplay}
                        setAskoverDropdownDisplay={setAskoverDropdownDisplay}
                    />
                )}
            </MainContents>
        </>
    );
};

export default Board;
