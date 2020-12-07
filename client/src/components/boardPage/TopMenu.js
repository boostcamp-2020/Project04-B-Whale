/* eslint-disable jsx-a11y/no-autofocus */
import React, { useContext, useEffect, useRef, useState } from 'react';
import styled from 'styled-components';
import BoardDetailContext from '../../context/BoardDetailContext';
import { updateBoardTitle } from '../../utils/boardRequest';

const MenuDiv = styled.div`
    display: flex;
    position: relative;
    justify-content: space-between;
    line-height: 40px;
    width: 100%;
    min-height: 30px;
`;

const BoardTitle = styled.span`
    margin-right: 2%;
    border-radius: 4px;
    padding: 5px 5px;
    resize: none;
    margin-left: 2em;
    ${(props) =>
        props.state === 'span' &&
        `&:hover {
            cursor: pointer;
            opacity: 0.3;
            background-color: gray;
        }`};
`;

const BoardInput = styled.input`
    width: ${(props) => (props.width <= 0 ? 30 : props.width * 15)}px;
    height: 30px;
    position: relative;
    border-radius: 4px;
    margin-left: 2em;
    margin-right: 2%;
    z-index: 3;
`;

const ButtonForGettingInvitedUser = styled.button`
    opacity: 0.3;
    border-radius: 4px;
    padding: 5px 10px;
    margin-right: 2%;
`;

const InviteButton = styled.button`
    opacity: 0.3;
    border-radius: 4px;
    padding: 5px 10px;
    z-index: 9999;
`;

const MenuButton = styled.button`
    display: ${(props) => (props.sidebarDisplay ? 'none' : 'block')};
    margin-right: 5%;
    opacity: 0.3;
    border-radius: 4px;
    padding: 5px 10px;
`;

const DimmedForInput = styled.div`
    display: ${(props) => (props.inputState === 'input' ? 'inline-block' : 'none')};
    position: fixed;
    top: 0;
    left: 0;
    bottom: 0;
    right: 0;
    z-index: 2;
`;

const TopMenu = ({
    sidebarDisplay,
    setInvitedDropdownDisplay,
    setAskoverDropdownDisplay,
    setSidebarDisplay,
}) => {
    const { boardDetail, setBoardDetail } = useContext(BoardDetailContext);
    const [inputState, setInputState] = useState('span');
    const [inputContent, setInputContent] = useState('');

    useEffect(() => {
        setInputContent(boardDetail.title);
    }, [boardDetail]);

    const inputTag = useRef();

    const boardTitleClickHandler = () => {
        setInputState('input');
    };

    const changeBoardTitle = async (evt) => {
        if (evt.keyCode === 13) {
            if (!inputContent) {
                return;
            }
            await updateBoardTitle(boardDetail.id, inputContent);
            setBoardDetail({
                ...boardDetail,
                title: inputContent,
            });
            setInputState('span');
        }
    };

    const dimmedClickHandler = async () => {
        if (!inputContent) {
            return;
        }
        await updateBoardTitle(boardDetail.id, inputContent);
        setBoardDetail({
            ...boardDetail,
            title: inputContent,
        });
        setInputState('span');
    };

    return (
        <>
            <MenuDiv>
                <div style={{ width: '50%' }}>
                    {inputState === 'span' && (
                        <BoardTitle state={inputState} onClick={boardTitleClickHandler}>
                            {boardDetail.title}
                        </BoardTitle>
                    )}
                    {inputState === 'input' && (
                        <>
                            <BoardInput
                                width={inputContent.length}
                                value={inputContent}
                                onChange={(evt) => setInputContent(evt.target.value)}
                                autoFocus="autoFocus"
                                onKeyDown={changeBoardTitle}
                                ref={inputTag}
                            />
                            <DimmedForInput inputState={inputState} onClick={dimmedClickHandler} />
                        </>
                    )}
                    <ButtonForGettingInvitedUser
                        onClick={(evt) =>
                            setInvitedDropdownDisplay({
                                visible: true,
                                offsetY: evt.target.getBoundingClientRect().left,
                            })
                        }
                    >
                        참여자 목록
                    </ButtonForGettingInvitedUser>
                    <InviteButton
                        onClick={(evt) =>
                            setAskoverDropdownDisplay({
                                visible: true,
                                offsetY: evt.target.getBoundingClientRect().left,
                            })
                        }
                    >
                        초대하기
                    </InviteButton>
                </div>
                <div
                    style={{
                        width: '50%',
                        display: 'flex',
                        justifyContent: 'flex-end',
                        padding: '5px 0',
                    }}
                >
                    <MenuButton
                        sidebarDisplay={sidebarDisplay}
                        onClick={() => setSidebarDisplay(true)}
                    >
                        메뉴
                    </MenuButton>
                </div>
            </MenuDiv>
        </>
    );
};

export default TopMenu;
