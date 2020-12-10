/* eslint-disable jsx-a11y/no-static-element-interactions */
/* eslint-disable jsx-a11y/click-events-have-key-events */
import React, { useState } from 'react';
import styled from 'styled-components';
import { AiOutlineMenu } from 'react-icons/ai';
import { Input } from 'antd';
import AddListOrCard from './AddListOrCard';
import ListMenuDropdown from './ListMenuDropdown';
import { updateListTitle } from '../../utils/listRequest';

const ListWrapper = styled.div`
    background-color: lightgray;
    position: relative;
    margin-right: 10px;
    width: auto;
    height: auto;
    display: flex;
    padding: 5px;
    border-radius: 6px;
    flex-direction: column;
    z-index: 1;
`;

const ListTitleInput = styled(Input)`
    z-index: 3;
    position: relative;
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
    // eslint-disable-next-line no-unused-vars
    const [listMenuState, setListMenuState] = useState({
        visible: false,
        offsetY: 0,
        offsetX: 0,
    });
    // const updateContextListTitle = () => {};
    const changeListTitle = async (evt) => {
        if (evt.keyCode === 13) {
            console.log(listTitle);
            // 리스트 수정 api, 컨텍스트 변경
            const { status } = await updateListTitle({ listId: id, title: listTitle });
            switch (status) {
                case 201:
                    break;
                default:
                    break;
            }
            console.log(status);
            setTitleInputState(false);
        }
    };

    const dimmedClickHandler = () => {
        console.log(listTitle);
        // 리스트 수정 api, 컨텍스트 변경

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
                <div
                    style={{
                        display: 'flex',
                        justifyContent: 'space-between',
                    }}
                >
                    {!titleInputState && (
                        <div
                            onClick={() => setTitleInputState(true)}
                            style={{ margin: '0', cursor: 'pointer', height: '30px', width: '80%' }}
                        >
                            {title}
                        </div>
                    )}
                    {titleInputState && (
                        <div style={{ margin: '0', cursor: 'pointer', height: '30px' }}>
                            <ListTitleInput
                                value={listTitle}
                                onChange={(evt) => setListTitle(evt.target.value)}
                                onKeyDown={changeListTitle}
                                autoFocus="autoFocus"
                            />
                            <DimmedForInput
                                inputState={titleInputState}
                                onClick={dimmedClickHandler}
                            />
                        </div>
                    )}
                    <AiOutlineMenu onClick={menuClickHandler} style={{ cursor: 'pointer' }} />
                </div>
                <div style={{ margin: 'auto' }} />
                <div style={{ margin: 'auto' }}>
                    <AddListOrCard parent="card" />
                </div>
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
