import React, { useState } from 'react';
import styled from 'styled-components';
import { HiPlus } from 'react-icons/hi';
import Modal from './CreateBoardModal';

const Button = styled.li`
    display: flex;
    padding: 7px 10px;
    font-size: 18px;
    cursor: pointer;
`;

const AddBoardButton = () => {
    const [isModalDisplay, setIsModalDisplay] = useState(false);

    return (
        <>
            <Button onClick={() => setIsModalDisplay(true)}>
                <HiPlus />
                보드 추가하기
            </Button>
            <Modal onClose={() => setIsModalDisplay(false)} visible={isModalDisplay} />
        </>
    );
};

export default AddBoardButton;
