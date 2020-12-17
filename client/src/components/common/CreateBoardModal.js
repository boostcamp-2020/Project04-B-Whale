import React, { useState } from 'react';
import styled from 'styled-components';
import { GithubPicker } from 'react-color';
import { Modal } from 'antd';
import { createBoard } from '../../utils/boardRequest';

const DimmedModal = styled.div`
    display: ${(props) => (props.visible ? 'block' : 'none')};
    position: fixed;
    top: 0;
    left: 0;
    bottom: 0;
    right: 0;
    background-color: rgba(0, 0, 0, 0.6);
    z-index: 2;
`;

const ModalWrapper = styled.div`
    display: ${(props) => (props.visible ? 'block' : 'none')};
    position: fixed;
    top: 0;
    right: 0;
    bottom: 0;
    left: 0;
    z-index: 3;
    overflow: auto;
    outline: 0;
`;

const ModalInner = styled.div`
    position: relative;
    box-shadow: 0 0 6px 0 rgba(0, 0, 0, 0.5);
    background-color: #fff;
    border-radius: 10px;
    width: 100%;
    max-width: 350px;
    top: 40%;
    margin: 0 auto;
    padding: 10px 20px;
    background-color: ${(props) => props.color};
`;

const CloseModalBtn = styled.button`
    width: 30px;
    margin-bottom: 10px;
    margin-left: 95%;
    background: none;
`;

const ModalContents = styled.div``;

const BoardTitleInput = styled.input.attrs({
    placeholder: '보드 타이틀을 입력하세요.',
})`
    width: 100%;
    margin-bottom: 10px;
    padding: 5px;
    border: ${(props) => props.theme.border};
    border-radius: ${(props) => props.theme.radiusSmall};
`;

const Wrapper = styled.div`
    display: flex;
    justify-content: space-between;
`;

const AddButton = styled.button.attrs({
    type: 'button',
})`
    padding: 5px 20px;
    border: ${(props) => props.theme.border};
    border-radius: ${(props) => props.theme.radiusSmall};
    font-size: 18px;
`;

const CreateBoardModal = ({ onClose, visible }) => {
    const [title, setTitle] = useState('');
    const [color, setColor] = useState('#ffffff');

    const onClickChangeColor = ({ hex }) => {
        setColor(hex);
    };

    const createBoardInputHandler = (event) => {
        setTitle(event.target.value);
    };

    const onDimmedClick = (e) => {
        if (e.target === e.currentTarget) {
            onClose();
        }
    };

    const addBoard = async () => {
        if (!title.replace(/(\s*)/g, '').length) {
            Modal.info({
                title: `보드 타이틀을 입력해주세요😩`,
                onOk() {},
                style: { top: '40%' },
            });
            return;
        }
        const { data } = await createBoard({ title, color });
        document.location = `/board/${data.id}`;
    };

    return (
        <>
            <DimmedModal visible={visible} />
            <ModalWrapper onClick={onDimmedClick} visible={visible}>
                <ModalInner color={color}>
                    <CloseModalBtn onClick={onClose}>X</CloseModalBtn>
                    <ModalContents>
                        <BoardTitleInput value={title} onChange={createBoardInputHandler} />
                        <Wrapper>
                            <GithubPicker width={212} onChangeComplete={onClickChangeColor} />
                            <AddButton onClick={addBoard}>생성</AddButton>
                        </Wrapper>
                    </ModalContents>
                </ModalInner>
            </ModalWrapper>
        </>
    );
};

export default CreateBoardModal;
