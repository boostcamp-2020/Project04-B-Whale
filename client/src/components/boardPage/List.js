/* eslint-disable jsx-a11y/no-static-element-interactions */
/* eslint-disable jsx-a11y/click-events-have-key-events */
import React, { useContext, useState } from 'react';
import styled from 'styled-components';
import { AiOutlineMenu } from 'react-icons/ai';
import { Input } from 'antd';
import AddListOrCard from './AddListOrCard';
import ListMenuDropdown from './ListMenuDropdown';
import { updateListTitle } from '../../utils/listRequest';
import BoardDetailContext from '../../context/BoardDetailContext';
import ListMoveDropdown from './ListMoveDropdown';

const ListWrapper = styled.div`
    background-color: lightgray;
    position: relative;
    margin-right: 10px;
    width: auto;
    height: fit-content;
    display: flex;
    padding: 5px;
    border-radius: 6px;
    flex-direction: column;
    z-index: 1;
`;

const ListContentWrapper = styled.div`
    display: flex;
    justify-content: space-between;
`;

const TitleDiv = styled.div`
    margin: 0;
    cursor: pointer;
    height: 30px;
    width: 80%;
`;

const InputTitleDiv = styled.div`
    margin: 0;
    cursor: pointer;
    height: 30px;
`;

const ListTitleInput = styled(Input)`
    z-index: 3;
    position: relative;
`;

const CardsWrapper = styled.div`
    margin: auto;
`;

const FooterAddBtnDiv = styled.div`
    margin: auto;
`;

const DimmedForInput = styled.div`
    display: ${(props) => (props.inputState ? 'inline-block' : 'none')};
    position: fixed;
    top: 0;
    left: 0;
    bottom: 0;
    right: 0;
    z-index: 2;
    cursor: default;
`;

export default function List({ title, id }) {
    const [titleInputState, setTitleInputState] = useState(false);
    const [listTitle, setListTitle] = useState(title);
    const { boardDetail, setBoardDetail } = useContext(BoardDetailContext);
    const [listMenuState, setListMenuState] = useState({
        visible: false,
        offsetY: 0,
        offsetX: 0,
    });

    const [listMoveDropdownState, setListMoveDropdownState] = useState({
        visible: false,
        offsetY: 0,
        offsetX: 0,
    });

    const updateContextListTitle = () => {
        boardDetail.lists[boardDetail.lists.findIndex((v) => v.id === id)].title = listTitle;
        setBoardDetail({ ...boardDetail });
    };

    const changeTitleHandler = () => {
        updateContextListTitle();
        setTitleInputState(false);
    };

    const changeListTitle = async (evt) => {
        if (evt.keyCode !== undefined && evt.keyCode !== 13) return;
        await updateListTitle({ listId: id, title: listTitle });
        changeTitleHandler();
    };

    const menuClickHandler = (evt) => {
        setListMenuState({
            visible: true,
            offsetX: evt.target.getBoundingClientRect().top,
            offsetY: evt.target.getBoundingClientRect().left,
        });
    };

    return (
        <>
            <ListWrapper>
                <ListContentWrapper>
                    {!titleInputState && (
                        <TitleDiv onClick={() => setTitleInputState(true)}>{title}</TitleDiv>
                    )}
                    {titleInputState && (
                        <InputTitleDiv>
                            <ListTitleInput
                                value={listTitle}
                                onChange={(evt) => setListTitle(evt.target.value)}
                                onKeyDown={changeListTitle}
                                autoFocus="autoFocus"
                            />
                            <DimmedForInput
                                inputState={titleInputState}
                                onClick={changeListTitle}
                            />
                        </InputTitleDiv>
                    )}
                    <AiOutlineMenu onClick={menuClickHandler} style={{ cursor: 'pointer' }} />
                </ListContentWrapper>
                <CardsWrapper style={{ marginTop: '5px' }}>카드들</CardsWrapper>
                <FooterAddBtnDiv>
                    <AddListOrCard parent="card" />
                </FooterAddBtnDiv>
            </ListWrapper>
            {listMenuState.visible && (
                <ListMenuDropdown
                    listId={id}
                    listMenuState={listMenuState}
                    setListMenuState={setListMenuState}
                    listMoveDropdownState={listMoveDropdownState}
                    setListMoveDropdownState={setListMoveDropdownState}
                />
            )}
            {listMoveDropdownState.visible && (
                <ListMoveDropdown
                    listId={id}
                    listMenuState={listMenuState}
                    setListMenuState={setListMenuState}
                    listMoveDropdownState={listMoveDropdownState}
                    setListMoveDropdownState={setListMoveDropdownState}
                />
            )}
        </>
    );
}
