import React, { useRef, useState } from 'react';
import styled from 'styled-components';

const Wrapper = styled.div`
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
`;

const DropdownWrapper = styled.div`
    position: relative;
    top: 14%;
    left: ${(props) => props.offsetY}px;
    width: 200px;
    height: 300px; //auto
    background-color: ${(props) => props.theme.whiteColor};
    border: ${(props) => props.theme.border};
    border-radius: ${(props) => props.theme.radiusSmall};
    overflow: auto;
    z-index: 2;
    max-height: 500px;
    overflow: scroll;
    display: flex;
    justify-content: center;
`;

const SearchInput = styled.input.attrs({
    type: 'text',
    placeholder: '이름으로 검색',
})`
    height: 35px;
    margin: 5px 0;
    border: 3px solid lightgray;
    &:focus {
        outline: 1px solid blue;
    }
`;

// eslint-disable-next-line no-unused-vars
const AskOverDropdown = (props) => {
    const wrapper = useRef();
    const input = useRef();
    const { askoverDropdownDisplay } = props;
    const [inputContent, setInputContent] = useState('');
    // eslint-disable-next-line no-unused-vars
    const onClose = (evt) => {
        if (evt.target === wrapper.current) props.setAskoverDropdownDisplay(false);
    };

    const searchPerSecond = setTimeout(() => {
        console.log(input.current?.value);
        // 검색 api 요청
    }, 1000);

    const time = (evt) => {
        setInputContent(evt.target.value);
        clearTimeout(searchPerSecond);
    };

    return (
        <Wrapper onClick={onClose} ref={wrapper}>
            <DropdownWrapper offsetY={askoverDropdownDisplay.offsetY}>
                <SearchInput value={inputContent} onChange={time} ref={input} />
            </DropdownWrapper>
        </Wrapper>
    );
};

export default AskOverDropdown;
