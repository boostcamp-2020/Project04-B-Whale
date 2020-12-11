import React, { useContext } from 'react';
import styled from 'styled-components';
import { FaHome } from 'react-icons/fa';
import BoardDetailContext from '../../context/BoardDetailContext';
import { inviteUserIntoBoard } from '../../utils/boardRequest';

const UserDiv = styled.div`
    margin: 5px 0;
    display: flex;
    flex-direction: row;
    justify-content: space-between;
`;

const ProfileImageDiv = styled.div`
    width: 30px;
    height: 30px;
    margin-left: 5px;
    border-radius: 70%;
    overflow: hidden;
`;

const NameDiv = styled.div`
    margin: auto 10px;
`;

const ProfileImage = styled.img`
    width: 100%;
    height: 100%;
`;

const InviteBtn = styled.button`
    margin: auto 10px;
    float: right;
    border-radius: 8px;
`;

const InvitedUserDetail = ({
    profileImageUrl,
    id,
    name,
    parent,
    already,
    host,
    setAskoverDropdownDisplay,
}) => {
    const { boardDetail, setBoardDetail } = useContext(BoardDetailContext);

    const inviteHandler = async () => {
        const { status } = await inviteUserIntoBoard(boardDetail.id, id);
        if (status === 201) {
            setAskoverDropdownDisplay(false);
            boardDetail.invitedUsers = [...boardDetail.invitedUsers, { id, name, profileImageUrl }];
            setBoardDetail({ ...boardDetail });
        }
    };
    return (
        <UserDiv already={already} parent={parent}>
            <div style={{ display: 'flex' }}>
                <ProfileImageDiv>
                    <ProfileImage src={profileImageUrl} alt={`${name} image`} align="center" />
                </ProfileImageDiv>
                <NameDiv>{name}</NameDiv>
            </div>
            {host && parent !== 'invite' && (
                <div style={{ margin: 'auto 10px', color: 'green' }}>
                    <FaHome />
                </div>
            )}
            {already && parent === 'invite' && (
                <div style={{ color: 'red', margin: 'auto 10px' }}>초대된 유저</div>
            )}
            {!already && parent === 'invite' && (
                <InviteBtn onClick={inviteHandler}>초대하기</InviteBtn>
            )}
        </UserDiv>
    );
};

export default InvitedUserDetail;
