import React, { useState } from 'react';
import styled from 'styled-components';
import { HiPlus } from 'react-icons/hi';
import Modal from '../common/CreateBoardModal';

const Button = styled.button`
    width: 100%;
    padding: 8px 0;
    border: ${(props) => props.theme.border};
    font-size: 18px;
    font-weight: 700;
    text-align: center;
`;

const AddBoardButton = () => {
    const [isModalDisplay, setIsModalDisplay] = useState(false);

    return (
        <>
            <Button onClick={() => setIsModalDisplay(true)}>
                <HiPlus />
                보드 추가하기
            </Button>
            <Modal
                onClose={() => {
                    document.getElementById('root').style.overflow = 'auto';
                    setIsModalDisplay(false);
                }}
                visible={isModalDisplay}
            />
        </>
    );
};

export default AddBoardButton;
