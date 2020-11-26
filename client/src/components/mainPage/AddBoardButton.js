import React, { useState } from 'react';
import styled from 'styled-components';
import Modal from '../common/create-board-modal';

const Button = styled.button`
    width: 100%;
    padding: 3px 0;
    border: ${(props) => props.theme.border};
    font-size: 18px;
    font-weight: 700;
    text-align: center;
`;

const AddBoardButton = () => {
    const [isModalDisplay, setIsModalDisplay] = useState(false);

    const onClickAddBoard = () => {
        setIsModalDisplay(true);
    };

    return (
        <>
            <Button onClick={onClickAddBoard}>+ 보드 추가하기</Button>
            <Modal onClose={() => setIsModalDisplay(false)} visible={isModalDisplay} />
        </>
    );
};

export default AddBoardButton;
