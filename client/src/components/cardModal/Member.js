import React from 'react';
import styled from 'styled-components';

const UserDiv = styled.div`
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: flex-start;
    padding: 5px;
    max-width: 60px;
`;

const ProfileImageDiv = styled.div`
    width: 30px;
    height: 30px;
    border-radius: 70%;
    overflow: hidden;
`;

const ProfileImage = styled.img`
    width: 100%;
    height: 100%;
`;

const NameDiv = styled.div``;

const Member = ({ member }) => {
    return (
        <UserDiv>
            <ProfileImageDiv>
                <ProfileImage
                    src={member.profileImageUrl}
                    alt={`${member.name} image`}
                    align="center"
                />
            </ProfileImageDiv>
            <NameDiv>{member.name}</NameDiv>
        </UserDiv>
    );
};

export default Member;
