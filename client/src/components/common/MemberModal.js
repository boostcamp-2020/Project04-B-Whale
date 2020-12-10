import React, { useContext, useState } from 'react';
import styled from 'styled-components';
import { IoIosClose } from 'react-icons/io';
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

const ModalWrapper = styled.div`
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

const ModalHeader = styled.div`
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 5px 3px;
    border-bottom: ${(props) => props.theme.border};
`;

const ModalTitle = styled.div`
    font-size: 18px;
    font-weight: 700;
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

const MemberModal = ({ onClose }) => {
    const { boardDetail } = useContext(BoardDetailContext);
    const { creator, invitedUsers } = boardDetail;
    // TODO: 카드에 members 정보를 default 값으로 변경
    const [userIds, setUserIds] = useState([1, 2]);
    const allInvitedUsers = [creator, ...invitedUsers];
    const [searchedUsers, setSearchedUsers] = useState(allInvitedUsers);

    const onClickClose = async (e) => {
        if (e.target === e.currentTarget) {
            // TODO: context에 저장된 카드 id 가져오도록 변경할 것
            const cardId = 1;
            await addMemberToCard({ cardId, userIds });
            onClose();
        }
    };

    const onChangeUserSearch = (e) => {
        if (e.target.value === '') {
            setSearchedUsers(allInvitedUsers);
            return;
        }

        const regex = new RegExp(`^${e.target.value}`);
        const newSearchUsers = allInvitedUsers.filter((user) => user.name.search(regex) !== -1);
        setSearchedUsers(newSearchUsers);
    };

    return (
        <>
            <Wrapper onClick={onClickClose} />
            <ModalWrapper>
                <ModalHeader>
                    <div />
                    <ModalTitle>멤버</ModalTitle>
                    <IoIosClose size={24} cursor="pointer" onClick={onClose} />
                </ModalHeader>
                <SearchInput onChange={onChangeUserSearch} />
                {searchedUsers.map(({ id, profileImageUrl, name }) => (
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
            </ModalWrapper>
        </>
    );
};

export default MemberModal;
