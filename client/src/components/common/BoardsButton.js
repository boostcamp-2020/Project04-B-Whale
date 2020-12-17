import React, { useState } from 'react';
import styled from 'styled-components';
import { VscTriangleDown } from 'react-icons/vsc';
import BoardsDropdown from './BoardsDropdown';

const Button = styled.button`
    display: flex;
    padding: 5px 10px;
    border-radius: ${(props) => props.theme.radiusSmall};
`;

const BoardsButton = () => {
    const [isDropdownDisplay, setIsDropdownDisplay] = useState(false);

    const onClickDisplayDropdown = () => {
        setIsDropdownDisplay(true);
    };

    return (
        <>
            <Button onClick={onClickDisplayDropdown}>
                <div>Boards</div>
                <VscTriangleDown />
            </Button>
            {isDropdownDisplay ? (
                <BoardsDropdown onClose={() => setIsDropdownDisplay(false)} />
            ) : null}
        </>
    );
};

export default BoardsButton;
