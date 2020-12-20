import React, { useRef, useState } from 'react';
import styled from 'styled-components';
import { IoIosClose } from 'react-icons/io';
import { GithubPicker } from 'react-color';
import { Modal, Input } from 'antd';
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

const BoardTitleInput = styled(Input)`
    margin-bottom: 10px;
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
    const [color, setColor] = useState('#FFFFFF');
    const inputTitleElement = useRef();
    const colors = [
        '#f4decd',
        '#0e63b2',
        '#C67e28',
        '#43892b',
        '#9f3426',
        '#754a8c',
        '#bf417e',
        '#3fb757',
        '#169ec0',
        '#71797e',
    ];
    const onClickChangeColor = ({ hex }) => {
        setColor(hex);
    };

    const onDimmedClick = (e) => {
        if (e.target === e.currentTarget) {
            onClose();
            document.getElementById('root').style.overflow = 'auto';
        }
    };

    const showInvalidTitleModal = () => {
        Modal.info({
            title: '생성할 보드 제목을 입력해주세요😩',
            onOk() {
                inputTitleElement.current.focus();
            },
            style: { top: '40%' },
        });
    };

    const checkInputHandler = (e) => {
        if (e.keyCode !== undefined && e.keyCode !== 13) return false;
        const replacedTitle = inputTitleElement.current.state.value?.replace(/ /g, '');
        if (!replacedTitle) {
            showInvalidTitleModal();
            return false;
        }
        return true;
    };

    const addBoard = async (e) => {
        if (!checkInputHandler(e)) return;
        const title = inputTitleElement.current.state.value;
        const { data } = await createBoard({ title, color });
        document.location = `/board/${data.id}`;
    };

    return (
        <>
            <DimmedModal visible={visible} />
            <ModalWrapper onClick={onDimmedClick} visible={visible}>
                <ModalInner color={color}>
                    <CloseModalBtn onClick={onClose}>
                        <IoIosClose />
                    </CloseModalBtn>
                    <ModalContents>
                        <BoardTitleInput
                            ref={inputTitleElement}
                            autoFocus="autoFocus"
                            type="text"
                            placeholder="보드 타이틀을 입력하세요."
                            onKeyDown={addBoard}
                        />
                        <Wrapper>
                            <GithubPicker
                                colors={colors}
                                width={138}
                                onChangeComplete={onClickChangeColor}
                            />
                            <AddButton onClick={addBoard}>생성</AddButton>
                        </Wrapper>
                    </ModalContents>
                </ModalInner>
            </ModalWrapper>
        </>
    );
};

export default CreateBoardModal;
