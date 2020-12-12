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
import Card from '../common/Card';

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
    max-height: 100%;
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
    margin-top: 5px;
    overflow-y: scroll;
    overflow-x: hidden;
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

    const changeListTitle = async (evt) => {
        if (evt.keyCode !== undefined && evt.keyCode !== 13) return;
        await updateListTitle({ listId: id, title: listTitle });
        boardDetail.lists[boardDetail.lists.findIndex((v) => v.id === id)].title = listTitle;
        setBoardDetail({ ...boardDetail });
        setTitleInputState(false);
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
                <CardsWrapper>
                    {boardDetail.lists[boardDetail.lists.findIndex((v) => v.id === id)].cards?.map(
                        (v) => (
                            <Card
                                width="230px"
                                height="60px"
                                fontSize={{ titleSize: '1rem', dueDateSize: '11px' }}
                                cardTitle={v.title}
                                cardDueDate={v.dueDate}
                                cardCommentCount={v.commentCount}
                            />
                        ),
                    )}
                </CardsWrapper>
                <FooterAddBtnDiv>
                    <AddListOrCard parent="card" id={id} />
                </FooterAddBtnDiv>
            </ListWrapper>
            {listMenuState.visible && (
                <ListMenuDropdown
                    listId={id}
                    listMenuState={listMenuState}
                    setListMenuState={setListMenuState}
                />
            )}
        </>
    );
}
