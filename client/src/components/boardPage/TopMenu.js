import React, { useContext } from 'react';
import styled from 'styled-components';
import BoardDetailContext from '../../context/BoardDetailContext';

const MenuDiv = styled.div`
    display: flex;
    justify-content: space-between;
    line-height: 40px;
    width: 100%;
    min-height: 30px;
    padding-left: 200px;
`;

const BoardTitle = styled.span`
    margin-right: 5%;
`;

const ButtonForGettingInvitedUser = styled.button`
    opacity: 0.3;
    border-radius: 4px;
    padding: 5px 10px;
    margin-right: 5%;
`;

const InviteButton = styled.button`
    opacity: 0.3;
    border-radius: 4px;
    padding: 5px 10px;
`;

const MenuButton = styled.button`
    opacity: 0.3;
    border-radius: 4px;
    padding: 5px 10px;
`;

const TopMenu = (props) => {
    const { boardDetail } = useContext(BoardDetailContext);

    return (
        <MenuDiv>
            <div style={{ width: '50%' }}>
                <BoardTitle>{boardDetail.title}</BoardTitle>
                <ButtonForGettingInvitedUser
                    onClick={(evt) =>
                        props.setInvitedDropdownDisplay({
                            visible: true,
                            offsetY: evt.target.getBoundingClientRect().left,
                        })
                    }
                >
                    참여자 목록
                </ButtonForGettingInvitedUser>
                <InviteButton
                    onClick={(evt) =>
                        props.setAskoverDropdownDisplay({
                            visible: true,
                            offsetY: evt.target.getBoundingClientRect().left,
                        })
                    }
                >
                    초대하기
                </InviteButton>
            </div>
            <div style={{ width: '5%' }}>
                <MenuButton onClick={() => props.setSidebarDisplay(!props.sidebarDisplay)}>
                    메뉴
                </MenuButton>
            </div>
        </MenuDiv>
    );
};

export default TopMenu;
