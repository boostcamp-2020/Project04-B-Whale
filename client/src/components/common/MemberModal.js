import React, { useContext, useState } from 'react';
import styled from 'styled-components';
import { IoIosClose } from 'react-icons/io';
import BoardDetailContext from '../../context/BoardDetailContext';
import CardContext from '../../context/CardContext';
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
    const { cardState, cardDispatch } = useContext(CardContext);
    const card = cardState.data;
    const [members, setMembers] = useState(card.members);
    const allInvitedUsers = [creator, ...invitedUsers];
    const [searchedUsers, setSearchedUsers] = useState(allInvitedUsers);

    const onClickClose = async (e) => {
        if (e.target === e.currentTarget) {
            const cardId = card.id;
            const userIds = members.map((member) => member.id);
            await addMemberToCard({ cardId, userIds });
            cardDispatch({ type: 'CHANGE_MEMBER', data: { ...card, members } });
            onClose();
        }
    };

    const onChangeUserSearch = (e) => {
        const text = e.target.value;
        if (text.includes('\\')) return;
        if (text === '') {
            setSearchedUsers(allInvitedUsers);
            return;
        }

        const regex = new RegExp(`^${text}`);
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
                    <IoIosClose size={24} cursor="pointer" onClick={onClickClose} />
                </ModalHeader>
                <SearchInput onChange={onChangeUserSearch} />
                {searchedUsers.map(({ id, profileImageUrl, name }) => (
                    <Member
                        key={id}
                        memberId={id}
                        profileImageUrl={profileImageUrl}
                        name={name}
                        checked={members.some((member) => member.id === id)}
                        selectedMember={members}
                        changeMember={setMembers}
                    />
                ))}
            </ModalWrapper>
        </>
    );
};

export default MemberModal;
