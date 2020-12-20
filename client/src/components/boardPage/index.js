import React, { useState } from 'react';
import styled from 'styled-components';
import Header from '../common/header';
import TopMenu from './TopMenu';
import ActivitySidebar from './ActivitySidebar';
import InvitedDropdown from './InvitedUserDropdown';
// import { getDetailBoard } from '../../utils/boardRequest';

const MainContents = styled.div`
    height: 100%;
    width: 100%;
    background-color: ${(props) => props.backgroundColor};
`;

const Board = ({ match }) => {
    const { id } = match.params;
    const [sidebarDisplay, setSidebarDisplay] = useState(false);
    const [invitedDropdownDisplay, setInvitedDropdownDisplay] = useState(false);

    return (
        <>
            <Header />
            <MainContents backgroundColor="gray">
                <TopMenu
                    sidebarDisplay={sidebarDisplay}
                    setSidebarDisplay={setSidebarDisplay}
                    invitedDropdownDisplay={invitedDropdownDisplay}
                    setInvitedDropdownDisplay={setInvitedDropdownDisplay}
                />
                보드 상세 페이지 - boardId : {id}
                <ActivitySidebar sidebarDisplay={sidebarDisplay} />
                {invitedDropdownDisplay && (
                    <InvitedDropdown setInvitedDropdownDisplay={setInvitedDropdownDisplay} />
                )}
            </MainContents>
        </>
    );
};

export default Board;
