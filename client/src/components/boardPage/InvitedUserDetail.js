import React from 'react';
import styled from 'styled-components';

const UserDiv = styled.div`
    margin: 5px 0;
    display: flex;
    flex-direction: row;
`;

const ProfileImageDiv = styled.div`
    width: 50px;
    height: 50px;
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

const InvitedUserDetail = ({ profileImageUrl, name }) => {
    return (
        <UserDiv>
            <ProfileImageDiv>
                <ProfileImage src={profileImageUrl} alt="My Image" align="center" />
            </ProfileImageDiv>
            <NameDiv>{name}</NameDiv>
        </UserDiv>
    );
};

export default InvitedUserDetail;
