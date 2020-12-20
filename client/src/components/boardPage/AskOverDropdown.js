import React, { useRef, useState, useContext, useEffect } from 'react';
import styled from 'styled-components';
import ReactLoading from 'react-loading';
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
    top: ${(props) => props.offsetX + 45}px;
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
    @media ${(props) => props.theme.sideBar} {
        width: 200px;
        left: ${(props) => props.offsetY - 30}px;
    }
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

const SearchResultDiv = styled.div`
    display: flex;
    justify-content: center;
    margin: 10px;
`;

const LoadingSvg = styled(ReactLoading).attrs({
    width: '32px',
    height: '32px',
    color: 'darkgray',
})`
    margin: auto;
`;

const AskOverDropdown = (props) => {
    const wrapper = useRef();
    const input = useRef();
    const { askoverDropdownDisplay } = props;
    const [inputContent, setInputContent] = useState('');
    const [searchedUsers, setSearchedUsers] = useState([]);
    const [checkUsers, setCheckUsers] = useState([]);
    const { boardDetail } = useContext(BoardDetailContext);
    const [noUserState, setNoUserState] = useState(false);

    const onClose = (evt) => {
        if (evt.target === wrapper.current) props.setAskoverDropdownDisplay(false);
    };

    let time;
    useEffect(() => {
        time = setTimeout(async () => {
            const replacedInput = input.current?.value?.replace(/ /g, '');
            if (!input.current?.value || !replacedInput) {
                setSearchedUsers([]);
                return;
            }
            const { data } = await searchUsersByName(input.current?.value);
            if (!data.length) setNoUserState(true);
            else {
                setNoUserState(false);
                setSearchedUsers([...data]);
            }
        }, 1000);
    }, [inputContent]);

    const handleChange = async (evt) => {
        setInputContent(evt.target.value);
        setNoUserState(false);
        setSearchedUsers([]);
        clearTimeout(time);
    };

    const searchEscHandler = (evt) => {
        if (evt.keyCode === 27) {
            props.setAskoverDropdownDisplay(false);
        }
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
                    onKeyDown={searchEscHandler}
                    ref={input}
                />
                <ContentWrapper onWheel={(e) => e.stopPropagation()}>
                    {!searchedUsers.length &&
                        inputContent &&
                        (!noUserState ? (
                            <LoadingSvg type="bars" />
                        ) : (
                            <SearchResultDiv>
                                <span>검색된 유저가 없습니다😩</span>
                            </SearchResultDiv>
                        ))}
                    {searchedUsers.map(({ profileImageUrl, name, id }) => (
                        <UserDetailForDropdown
                            profileImageUrl={profileImageUrl}
                            id={id}
                            key={id}
                            name={name}
                            parent="invite"
                            checkUsers={checkUsers}
                            setCheckUsers={setCheckUsers}
                            already={
                                boardDetail.invitedUsers.some((v) => {
                                    return v.id === id;
                                }) || id === boardDetail.creator.id
                            }
                            setAskoverDropdownDisplay={props.setAskoverDropdownDisplay}
                        />
                    ))}
                </ContentWrapper>
            </DropdownWrapper>
        </Wrapper>
    );
};

export default AskOverDropdown;
