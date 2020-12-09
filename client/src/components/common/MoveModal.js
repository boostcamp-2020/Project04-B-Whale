import React from 'react';
import styled from 'styled-components';
import { IoIosClose } from 'react-icons/io';

const Wrapper = styled.div`
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
`;

const ModalWrapper = styled.div`
    position: relative;
    top: 3.5em;
    left: 21.6em;
    width: 300px;
    padding: 5px;
    background-color: ${(props) => props.theme.whiteColor};
    border: ${(props) => props.theme.border};
    border-radius: ${(props) => props.theme.radiusSmall};
    z-index: 2;
`;

const ModalHeader = styled.div`
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding-bottom: 5px;
    border-bottom: ${(props) => props.theme.border};
`;

const ModalTitle = styled.div`
    font-size: 18px;
    font-weight: 700;
`;

const ModalBody = styled.div`
    margin-top: 5px;
    padding: 10px;
`;

const SelectWrapper = styled.div`
    display: flex;
    flex-flow: column;
    margin-top: 10px;
    padding: 5px 8px;
    border: ${(props) => props.theme.border};
    border-radius: ${(props) => props.theme.radiusSmall};
    background-color: ${(props) => props.theme.lightGrayColor};
`;

const SelectLabel = styled.label`
    font-weight: 700;
`;

const Select = styled.select`
    background: none;
    font-family: inherit;
`;

const Button = styled.button.attrs({ type: 'button' })`
    margin-top: 10px;
    padding: 5px 20px;
    border: ${(props) => props.theme.border};
    border-radius: ${(props) => props.theme.radiusSmall};
    background-color: ${(props) => props.theme.redColor};
    color: ${(props) => props.theme.whiteColor};
`;

const MoveModal = ({ onClose }) => {
    const onClickClose = (e) => {
        if (e.target === e.currentTarget) {
            onClose();
        }
    };

    return (
        <Wrapper onClick={onClickClose}>
            <ModalWrapper>
                <ModalHeader>
                    <div />
                    <ModalTitle>카드 이동</ModalTitle>
                    <IoIosClose size={24} onClick={onClose} />
                </ModalHeader>
                <ModalBody>
                    <ModalTitle>목적지 선택</ModalTitle>
                    <SelectWrapper>
                        <SelectLabel htmlFor="list-select">리스트</SelectLabel>
                        <Select id="list-select" defaultValue="list1">
                            <option value="list1">List1</option>
                            <option value="list2">list2</option>
                            <option value="list3">List3</option>
                        </Select>
                    </SelectWrapper>
                    <SelectWrapper>
                        <SelectLabel htmlFor="position-select">위치</SelectLabel>
                        <Select id="position-select" defaultValue="position1">
                            <option value="position1">Position1</option>
                            <option value="position2">Position2</option>
                        </Select>
                    </SelectWrapper>
                    <Button>이동</Button>
                </ModalBody>
            </ModalWrapper>
        </Wrapper>
    );
};

export default MoveModal;
