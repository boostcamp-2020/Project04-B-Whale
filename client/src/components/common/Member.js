import React from 'react';
import styled from 'styled-components';
import { FcCheckmark } from 'react-icons/fc';

const UserDiv = styled.div`
    display: flex;
    align-items: center;
    flex-direction: row;
    justify-content: space-between;
    padding: 5px 5px;
    cursor: pointer;

    &:hover {
        background-color: ${(props) => props.theme.blueColor};
    }
`;

const Wrapper = styled.div`
    display: flex;
`;

const ProfileImageDiv = styled.div`
    width: 30px;
    height: 30px;
    margin-left: 5px;
    border-radius: 70%;
    overflow: hidden;
`;

const ProfileImage = styled.img`
    width: 100%;
    height: 100%;
`;

const NameDiv = styled.div`
    margin: auto 10px;
`;

const Member = ({ profileImageUrl, name, checked }) => {
    return (
        <UserDiv>
            <Wrapper>
                <ProfileImageDiv>
                    <ProfileImage src={profileImageUrl} alt={`${name} image`} align="center" />
                </ProfileImageDiv>
                <NameDiv>{name}</NameDiv>
            </Wrapper>
            {checked && <FcCheckmark size={20} />}
        </UserDiv>
    );
};

export default Member;
