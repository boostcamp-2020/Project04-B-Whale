/* eslint-disable no-unused-vars */
import React, { useRef, useState, useContext } from 'react';
import styled from 'styled-components';
import { Modal, Button } from 'antd';
import BoardDetailContext from '../../context/BoardDetailContext';
import 'antd/dist/antd.css';
import { deleteList } from '../../utils/listRequest';

const Wrapper = styled.div`
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    z-index: 2;
`;

const DropdownWrapper = styled.div`
    position: relative;
    top: ${(props) => props.offsetX + 20}px;
    left: ${(props) => props.offsetY}px;
    width: 200px;
    height: auto;
    background-color: ${(props) => props.theme.whiteColor};
    border: ${(props) => props.theme.border};
    border-radius: ${(props) => props.theme.radiusSmall};
    overflow: auto;
    z-index: 3;
    max-height: 500px;
    overflow: scroll;
    display: flex;
    flex-direction: column;
    justify-content: space-between;
    padding: 10px 5px;
`;

const EachMenuDiv = styled.div`
    margin-bottom: 10px;
    cursor: pointer;
    &:hover {
        background-color: lightgray;
    }
`;

const ListMenuDropdown = ({
    listId,
    listMenuState,
    setListMenuState,
    listMoveDropdownState,
    setListMoveDropdownState,
}) => {
    const wrapper = useRef();
    const { boardDetail, setBoardDetail } = useContext(BoardDetailContext);
    const [deleteModalState, setDeleteModalState] = useState(false);

    const onDimmedClick = (evt) => {
        if (evt.target === wrapper.current) setListMenuState(false);
    };

    const onCancelClick = () => {
        setDeleteModalState(false);
        setListMenuState(false);
    };

    const listMoveBtnHandler = (evt) => {
        setListMoveDropdownState({
            offsetX: listMenuState.offsetX,
            offsetY: listMenuState.offsetY,
            visible: true,
        });
        setListMenuState({ visible: false });
    };

    const handleAgree = async () => {
        // TODO: status switch
        // eslint-disable-next-line no-unused-vars
        const { status } = await deleteList({ listId });

        boardDetail.lists.splice(
            boardDetail.lists.findIndex((v) => {
                return v.id === listId;
            }),
            1,
        );
        setBoardDetail({ ...boardDetail });
        setDeleteModalState(false);
        setListMenuState(false);
    };

    return (
        <Wrapper onClick={onDimmedClick} ref={wrapper}>
            <DropdownWrapper offsetX={listMenuState.offsetX} offsetY={listMenuState.offsetY}>
                <EachMenuDiv onClick={listMoveBtnHandler}>리스트 이동</EachMenuDiv>
                <EachMenuDiv onClick={() => setDeleteModalState(true)}>리스트 삭제</EachMenuDiv>
            </DropdownWrapper>

            <Modal
                visible={deleteModalState}
                onOk={handleAgree}
                onCancel={onCancelClick}
                style={{ top: '40%' }}
                footer={[
                    <Button key="no" onClick={onCancelClick}>
                        아니오
                    </Button>,
                    <Button key="yes" type="primary" onClick={handleAgree}>
                        예
                    </Button>,
                ]}
            >
                <p>정말 삭제하시겠습니까?😥</p>
            </Modal>
        </Wrapper>
    );
};

export default ListMenuDropdown;
