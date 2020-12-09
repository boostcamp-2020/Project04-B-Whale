import React, { useState } from 'react';
import styled from 'styled-components';
import MoveModal from './MoveModal';

const Button = styled.button`
    margin: 5px 10px;
    padding: 5px 10px;
`;

const MoveButton = () => {
    const [isModalDisplay, setIsModalDisplay] = useState(false);

    const onClickDisplayModal = () => {
        setIsModalDisplay(true);
    };

    return (
        <div>
            <Button onClick={onClickDisplayModal}>카드 이동</Button>
            {isModalDisplay ? <MoveModal onClose={() => setIsModalDisplay(false)} /> : null}
        </div>
    );
};

export default MoveButton;
