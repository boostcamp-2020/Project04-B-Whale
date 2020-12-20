import React from 'react';
import styled from 'styled-components';

const Wrapper = styled.button`
    width: ${(props) => props.width};
    height: ${(props) => props.width};
    color: #5e6d84;
    font-weight: lighter;
    font-size: ${(props) => props.width * 0.8};
    background-color: transparent;
    &: hover {
        color: #192b4d;
    }
`;

const CloseButton = ({ width, onClick, _ref }) => {
    return (
        <Wrapper width={width} onClick={onClick} ref={_ref}>
            X
        </Wrapper>
    );
};

export default CloseButton;
