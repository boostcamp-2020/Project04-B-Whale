import React from 'react';
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
    top: 15%;
    left: 14em;
    width: 200px;
    height: 200px;
    background-color: ${(props) => props.theme.whiteColor};
    border: ${(props) => props.theme.border};
    border-radius: ${(props) => props.theme.radiusSmall};
    overflow: auto;
    z-index: 2;
`;

const InvitedUserDropdown = (props) => {
    return (
        <Wrapper onClick={() => props.setInvitedDropdownDisplay(false)}>
            <DropdownWrapper />
        </Wrapper>
    );
};

export default InvitedUserDropdown;
