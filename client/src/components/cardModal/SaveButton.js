import React from 'react';
import styled from 'styled-components';

const Wrapper = styled.button`
    width: ${(props) => props.width};
    height: ${(props) => props.height};
    color: white;
    background-color: #59ac44;
    border-radius: 0.2rem;
    font-size: 0.9rem;
    font-weight: normal;
    &: hover {
        background-color: #69c64f;
    }
`;

const SaveButton = ({ width, height, className, onClick, children }) => {
    return (
        <Wrapper width={width} height={height} onClick={onClick} className={className}>
            {children}
        </Wrapper>
    );
};

export default SaveButton;
