import React, { useRef } from 'react';
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
`;

const SearchInput = styled.input.attrs({
    type: 'text',
    placeholder: '이름으로 검색',
})`
    height: 35px;
    &:focus {
        outline: 1px solid blue;
    }
`;

const SearchButton = styled.button``;

// eslint-disable-next-line no-unused-vars
const AskOverDropdown = (props) => {
    const wrapper = useRef();
    const { askoverDropdownDisplay } = props;

    // eslint-disable-next-line no-unused-vars
    const onClose = (evt) => {
        if (evt.target === wrapper.current) props.setAskoverDropdownDisplay(false);
    };

    return (
        <Wrapper onClick={onClose} ref={wrapper}>
            <DropdownWrapper offsetY={askoverDropdownDisplay.offsetY}>
                <SearchInput />
                <SearchButton>검색</SearchButton>
            </DropdownWrapper>
        </Wrapper>
    );
};

export default AskOverDropdown;
