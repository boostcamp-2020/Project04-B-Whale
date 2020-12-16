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
import BoardsProvider from '../provider/BoardsProvider';

const MainContents = styled.div`
    height: 92%;
    width: 100%;
    background-color: ${(props) => props.backgroundColor};
`;

const Wrapper = styled.div`
    display: flex;
    margin-left: 10px;
    max-width: ${(props) => (props.sidebar ? '79' : '100')}%;
    overflow-x: auto;
    height: 93%;
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
        const { data } = await getDetailBoard(id);
        data.lists.forEach((element) => {
            if (!element.cards.length) {
                element.cards.splice(0, 0, { id: 0 });
            }
        });
        setBoardDetail(data);
    }, [id]);

    return (
        <>
            <BoardsProvider>
                <Header />
            </BoardsProvider>
            <MainContents backgroundColor={boardDetail.color}>
                <TopMenu
                    sidebarDisplay={sidebarDisplay}
                    setSidebarDisplay={setSidebarDisplay}
                    setInvitedDropdownDisplay={setInvitedDropdownDisplay}
                    setAskoverDropdownDisplay={setAskoverDropdownDisplay}
                />
                <Wrapper sidebar={sidebarDisplay}>
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
                                            position={list.position}
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
