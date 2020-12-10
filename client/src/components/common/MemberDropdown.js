import React, { useContext, useState } from 'react';
import styled from 'styled-components';
import BoardDetailContext from '../../context/BoardDetailContext';
import { addMemberToCard } from '../../utils/cardRequest';
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
    const [userIds, setUserIds] = useState([1, 2]);

    const onClickClose = async (e) => {
        if (e.target === e.currentTarget) {
            // TODO: context에 저장된 카드 id 가져오도록 변경할 것
            const cardId = 1;
            await addMemberToCard({ cardId, userIds });
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
                    checked={userIds.includes(creator.id)}
                    selectedMember={userIds}
                    changeMember={setUserIds}
                />
                {invitedUsers.map(({ id, profileImageUrl, name }) => (
                    <Member
                        key={id}
                        memberId={id}
                        profileImageUrl={profileImageUrl}
                        name={name}
                        checked={userIds.includes(id)}
                        selectedMember={userIds}
                        changeMember={setUserIds}
                    />
                ))}
            </DropdownWrapper>
        </>
    );
};

export default InvitedUserDropdown;
