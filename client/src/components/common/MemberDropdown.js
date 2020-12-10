import React, { useContext, useState } from 'react';
import styled from 'styled-components';
import BoardDetailContext from '../../context/BoardDetailContext';
import Member from './Member';

const Wrapper = styled.div`
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
`;

const DropdownWrapper = styled.div`
    position: absolute;
    top: 2.2em;
    left: 0.7em;
    z-index: 2;
    max-height: 500px;
    background-color: ${(props) => props.theme.whiteColor};
    border: ${(props) => props.theme.border};
    border-radius: ${(props) => props.theme.radiusSmall};
    overflow: scroll;
`;

const SearchInput = styled.input.attrs({
    type: 'text',
    placeholder: '이름으로 검색',
})`
    height: 35px;
    margin: 5px 5px;
    padding: 0 3px;
    border: 3px solid lightgray;

    &:focus {
        outline: 1px solid blue;
    }
`;

const InvitedUserDropdown = ({ onClose }) => {
    const { boardDetail } = useContext(BoardDetailContext);
    const { creator, invitedUsers } = boardDetail;
    // TODO: 카드에 members 정보를 default 값으로 변경
    const [selectedMember, setSelectedMember] = useState([1, 2]);

    const onClickClose = (e) => {
        if (e.target === e.currentTarget) {
            onClose();
        }
    };

    return (
        <>
            <Wrapper onClick={onClickClose} />
            <DropdownWrapper>
                <SearchInput />
                <Member
                    key={creator.id}
                    memberId={creator.id}
                    profileImageUrl={creator.profileImageUrl}
                    name={creator.name}
                    checked={selectedMember.includes(creator.id)}
                    selectedMember={selectedMember}
                    changeMember={setSelectedMember}
                />
                {invitedUsers.map(({ id, profileImageUrl, name }) => (
                    <Member
                        key={id}
                        memberId={id}
                        profileImageUrl={profileImageUrl}
                        name={name}
                        checked={selectedMember.includes(id)}
                        selectedMember={selectedMember}
                        changeMember={setSelectedMember}
                    />
                ))}
            </DropdownWrapper>
        </>
    );
};

export default InvitedUserDropdown;
