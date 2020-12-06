import React, { useState } from 'react';
import styled from 'styled-components';
import checkImg from '../../image/check.svg';

const UserDiv = styled.div`
    margin: 5px 0;
    display: flex;
    flex-direction: row;
    ${(props) =>
        props.parent === 'invite' &&
        `&:hover {
            background-color: ${props.already ? 'none' : 'lightgray'};
            cursor: ${props.already ? 'default' : 'pointer'};
        }`};
`;

const ProfileImageDiv = styled.div`
    width: 30px;
    height: 30px;
    margin-left: 5px;
    border-radius: 70%;
    overflow: hidden;
`;

const CheckImg = styled.img`
    width: 15px;
`;

const NameDiv = styled.div`
    margin: auto 10px;
`;

const ProfileImage = styled.img`
    width: 100%;
    height: 100%;
`;

const InvitedUserDetail = ({
    profileImageUrl,
    id,
    name,
    parent,
    checkUsers,
    setCheckUsers,
    already,
}) => {
    const [isChecked, setIsChecked] = useState(false);
    const detailUserOnClick = () => {
        if (already || !parent) return;
        const idx = checkUsers.indexOf(id);
        if (idx > -1) {
            checkUsers.splice(idx, 1);
            setCheckUsers([...checkUsers]);
        } else setCheckUsers([...checkUsers, id]);
        setIsChecked(!isChecked);
    };

    return (
        <UserDiv onClick={detailUserOnClick} already={already} parent={parent}>
            {parent === 'invite' && (
                <div style={{ width: '15px', margin: 'auto 5px', textAlign: 'center' }}>
                    {isChecked && <CheckImg src={checkImg} alt="check" />}
                </div>
            )}
            <ProfileImageDiv>
                <ProfileImage src={profileImageUrl} alt="My Image" align="center" />
            </ProfileImageDiv>
            <NameDiv>{name}</NameDiv>
            {already && <div style={{ color: 'red', margin: 'auto 10px' }}>초대된 유저</div>}
        </UserDiv>
    );
};

export default InvitedUserDetail;
