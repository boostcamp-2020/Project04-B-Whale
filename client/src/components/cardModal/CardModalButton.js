import React from 'react';
import styled from 'styled-components';

const ButtonWrapper = styled.button`
    display: ${(props) =>
        props.visible === true || props.visible === undefined ? 'inline-block' : 'none'};
    width: ${(props) => props.width};
    height: ${(props) => props.height};
    font-weight: normal;
    color: #192b4d;
    background-color: #ebecef;
    border-radius: 0.3rem;
    &:hover {
        background-color: #e1e4e8;
        cursor: pointer;
    }
`;

const CardModalButton = ({ width, height, onClick, visible, children, className }) => {
    return (
        <ButtonWrapper
            width={width}
            height={height}
            onClick={onClick}
            visible={visible}
            className={className}
        >
            {children}
        </ButtonWrapper>
    );
};

export default CardModalButton;
