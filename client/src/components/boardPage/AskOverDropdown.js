import React, { useRef, useState, useContext, useEffect } from 'react';
import styled from 'styled-components';
import UserDetailForDropdown from './UserDetailForDropdown';
import BoardDetailContext from '../../context/BoardDetailContext';
import { searchUsersByName } from '../../utils/userRequest';

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
    width: 300px;
    height: auto;
    background-color: ${(props) => props.theme.whiteColor};
    border: ${(props) => props.theme.border};
    border-radius: ${(props) => props.theme.radiusSmall};
    overflow: auto;
    z-index: 9999;
    max-height: 500px;
    overflow: scroll;
    display: flex;
    flex-direction: column;
    justify-content: space-between;
`;
const ContentWrapper = styled.div`
    max-height: 400px;
    overflow: scroll;
`;

const SearchInput = styled.input.attrs({
    type: 'text',
    placeholder: '이름으로 검색',
})`
    height: 35px;
    margin: 5px 5px;
    border: 3px solid lightgray;
    &:focus {
        outline: 1px solid blue;
    }
`;

const AskOverDropdown = (props) => {
    const wrapper = useRef();
    const input = useRef();
    const { askoverDropdownDisplay } = props;
    const [inputContent, setInputContent] = useState('');
    const [searchedUsers, setSearchedUsers] = useState([]);
    const [checkUsers, setCheckUsers] = useState([]);
    const { boardDetail } = useContext(BoardDetailContext);

    const onClose = (evt) => {
        if (evt.target === wrapper.current) props.setAskoverDropdownDisplay(false);
    };

    let time;
    useEffect(() => {
        time = setTimeout(async () => {
            if (!input.current?.value) {
                setSearchedUsers([]);
                return;
            }
            const { data } = await searchUsersByName(input.current?.value);
            setSearchedUsers([...data]);
        }, 1000);
    }, [inputContent]);

    const handleChange = async (evt) => {
        setInputContent(evt.target.value);
        clearTimeout(time);
    };

    return (
        <Wrapper onClick={onClose} ref={wrapper}>
            <DropdownWrapper
                offsetY={askoverDropdownDisplay.offsetY}
                offsetX={askoverDropdownDisplay.offsetX}
            >
                <SearchInput
                    autoFocus="autoFocus"
                    value={inputContent}
                    onChange={handleChange}
                    ref={input}
                />
                <ContentWrapper>
                    {searchedUsers.map(({ profileImageUrl, name, id }) => (
                        <UserDetailForDropdown
                            profileImageUrl={profileImageUrl}
                            id={id}
                            key={id}
                            name={name}
                            parent="invite"
                            checkUsers={checkUsers}
                            setCheckUsers={setCheckUsers}
                            already={boardDetail.invitedUsers.some((v) => {
                                return v.id === id;
                            })}
                            setAskoverDropdownDisplay={props.setAskoverDropdownDisplay}
                        />
                    ))}
                </ContentWrapper>
            </DropdownWrapper>
        </Wrapper>
    );
};

export default AskOverDropdown;
