/* eslint-disable react/destructuring-assignment */
/* eslint-disable no-unused-vars */
import React, { useRef, useState, useContext, useEffect } from 'react';
import styled from 'styled-components';
import UserDetailForDropdown from './UserDetailForDropdown';
import BoardDetailContext from '../../context/BoardDetailContext';
import { searchUsersByName } from '../../utils/userRequest';
import MaterialUiModal from './MaterialUiModal';

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

const ListMenuDropdown = ({ listMenuState, setListMenuState, listId }) => {
    const wrapper = useRef();
    const dialog = useRef();
    const [deleteModalState, setDeleteModalState] = useState(false);
    const onClose = (evt) => {
        console.log(123123);
        if (evt.target === wrapper.current) setListMenuState(false);
    };

    const deleteListOnClick = () => {
        setDeleteModalState(true);
        // setListMenuState(false);
    };

    return (
        <Wrapper onClick={onClose} ref={wrapper}>
            <DropdownWrapper offsetX={listMenuState.offsetX} offsetY={listMenuState.offsetY}>
                <EachMenuDiv>리스트 이동</EachMenuDiv>
                <EachMenuDiv onClick={deleteListOnClick}>리스트 삭제</EachMenuDiv>
            </DropdownWrapper>
            <MaterialUiModal
                listId={listId}
                open={deleteModalState}
                setOpen={setDeleteModalState}
                setListMenuState={setListMenuState}
            />
        </Wrapper>
    );
};

export default ListMenuDropdown;
