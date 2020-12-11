import React, { useContext, useRef } from 'react';
import styled from 'styled-components';
import BoardDetailContext from '../../context/BoardDetailContext';
import UserDetailForDropdown from './UserDetailForDropdown';

const Wrapper = styled.div`
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
`;

const DropdownWrapper = styled.div`
    position: relative;
    top: ${(props) => props.offsetX + 55}px;
    left: ${(props) => props.offsetY}px;
    width: 250px;
    height: auto;
    background-color: ${(props) => props.theme.whiteColor};
    border: ${(props) => props.theme.border};
    border-radius: ${(props) => props.theme.radiusSmall};
    overflow: auto;
    z-index: 9999;
    max-height: 500px;
    overflow: scroll;
    padding: 5px;
`;

const InvitedUserDropdown = (props) => {
    const wrapper = useRef();
    const { boardDetail } = useContext(BoardDetailContext);
    const { invitedDropdownDisplay } = props;
    const onClose = (evt) => {
        if (evt.target === wrapper.current) props.setInvitedDropdownDisplay({ visible: false });
    };
    return (
        <Wrapper onClick={onClose} ref={wrapper}>
            <DropdownWrapper
                offsetY={invitedDropdownDisplay.offsetY}
                offsetX={invitedDropdownDisplay.offsetX}
            >
                <UserDetailForDropdown
                    profileImageUrl={boardDetail.creator.profileImageUrl}
                    host
                    name={boardDetail.creator.name}
                    key={boardDetail.creator.id}
                />
                {boardDetail.invitedUsers.map(({ profileImageUrl, name, id }) => (
                    <UserDetailForDropdown profileImageUrl={profileImageUrl} name={name} key={id} />
                ))}
            </DropdownWrapper>
        </Wrapper>
    );
};

export default InvitedUserDropdown;
