import React from 'react';
import styled from 'styled-components';

const DimmedModal = styled.div`
    box-sizing: border-box;
    display: ${(props) => (props.visible ? 'block' : 'none')};
    position: fixed;
    top: 0;
    left: 0;
    bottom: 0;
    right: 0;
    background-color: rgba(0, 0, 0, 0.6);
    z-index: 1;
`;

const ModalWrapper = styled.div`
    box-sizing: border-box;
    display: ${(props) => (props.visible ? 'block' : 'none')};
    position: fixed;
    top: 0;
    right: 0;
    bottom: 0;
    left: 0;
    z-index: 2;
    overflow: auto;
    outline: 0;
`;

const ModalInner = styled.div`
    box-sizing: border-box;
    position: relative;
    box-shadow: 0 0 6px 0 rgba(0, 0, 0, 0.5);
    background-color: #fff;
    border-radius: 10px;
    width: 360px;
    max-width: 480px;
    top: 40%;
    margin: 0 auto;
    padding: 5px 20px;
`;

const CloseModalBtn = styled.button`
    width: 30px;
    margin-bottom: 10px;
    margin-left: 95%;
`;

const ModalContents = styled.div`
    display: flex;
    flex-direction: column;
    align-items: flex-end;
`;

const BoardTitleInput = styled.input.attrs({
    placeholder: '보드 타이틀을 입력하세요.',
})`
    width: 300px;
    margin-bottom: 10px;
    border: 1px solid black;
`;

const Modal = ({ onClose, visible }) => {
    const onDimmedClick = (e) => {
        if (e.target === e.currentTarget) {
            onClose();
        }
    };

    const createBoard = () => {
        // axios
        onClose();
    };

    return (
        <>
            <DimmedModal visible={visible} />
            <ModalWrapper onClick={onDimmedClick} visible={visible}>
                <ModalInner>
                    <CloseModalBtn onClick={onClose}>X</CloseModalBtn>
                    <ModalContents>
                        <BoardTitleInput />
                        <button type="button" onClick={createBoard}>
                            생성
                        </button>
                    </ModalContents>
                </ModalInner>
            </ModalWrapper>
        </>
    );
};

export default Modal;
