import React, { useState } from 'react';
import styled from 'styled-components';
import DueDateModal from './DueDateModal';

const Wrapper = styled.div`
    position: relative;
`;

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
        <Wrapper>
            <Button onClick={onClickDisplayModal}>마감 기한</Button>
            {isModalDisplay ? <DueDateModal onClose={() => setIsModalDisplay(false)} /> : null}
        </Wrapper>
    );
};

export default MoveButton;
