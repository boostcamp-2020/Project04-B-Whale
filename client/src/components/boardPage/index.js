import React, { useContext, useEffect, useState } from 'react';
import styled from 'styled-components';
import Header from '../common/header';
import TopMenu from './TopMenu';
import ActivitySidebar from './ActivitySidebar';
import InvitedDropdown from './InvitedUserDropdown';
import { getDetailBoard } from '../../utils/boardRequest';
import BoardDetailContext from '../../context/BoardDetailContext';
import AskOverDropdown from './AskOverDropdown';

const MainContents = styled.div`
    height: 92%;
    width: 100%;
    background-color: ${(props) => props.backgroundColor};
`;

const Board = ({ match }) => {
    const { id } = match.params;
    const [sidebarDisplay, setSidebarDisplay] = useState(false);
    const [invitedDropdownDisplay, setInvitedDropdownDisplay] = useState({
        visible: false,
        offsetY: 0,
    });
    const [askoverDropdownDisplay, setAskoverDropdownDisplay] = useState({
        visible: false,
        offsetY: 0,
    });
    const { boardDetail, setBoardDetail } = useContext(BoardDetailContext);

    useEffect(async () => {
        const { data } = await getDetailBoard(id);
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
