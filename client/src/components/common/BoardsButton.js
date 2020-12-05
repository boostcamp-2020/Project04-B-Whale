import React, { useState } from 'react';
import styled from 'styled-components';
import BoardsDropdown from './BoardsDropdown';

const Button = styled.button`
    margin: 5px 10px;
    padding: 5px 10px;
`;

const BoardsButton = () => {
    const [isDropdownDisplay, setIsDropdownDisplay] = useState(false);

    const onClickDisplayDropdown = () => {
        setIsDropdownDisplay(true);
    };

    return (
        <div>
            <Button onClick={onClickDisplayDropdown}>Boards ∇</Button>
            {isDropdownDisplay ? (
                <BoardsDropdown onClose={() => setIsDropdownDisplay(false)} />
            ) : null}
        </div>
    );
};

export default BoardsButton;
