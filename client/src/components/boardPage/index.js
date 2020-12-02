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
    height: 100%;
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
        const { status, data } = await getDetailBoard(id);
        console.log(status, data);
        if (status === 404) document.location = '/error';
        const compareData = {
            id: 1,
            title: 'board',
            color: '#009FFF',
            creator: {
                id: 1,
                name: 'user',
            },
            lists: [
                {
                    id: 1,
                    title: 'test to do',
                    position: 1,
                    cards: [
                        {
                            id: 1,
                            title: 'test card',
                            position: 1,
                            dueDate: '2020-01-01T00:00:00.000Z',
                            commentCount: 0,
                        },
                    ],
                },
            ],
            invitedUsers: [
                {
                    id: 1,
                    name: 'user',
                    profileImageUrl: 'https://ssl.pstatic.net/static/pwe/address/img_profile.png',
                },
            ],
        };
        setBoardDetail(compareData);
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
                <ActivitySidebar sidebarDisplay={sidebarDisplay} />
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
