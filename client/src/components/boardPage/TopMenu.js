import React, { useContext, useEffect, useRef, useState } from 'react';
import styled from 'styled-components';
import BoardDetailContext from '../../context/BoardDetailContext';
import { BoardsStatusContext, BoardsDispatchContext } from '../../context/BoardsContext';
import { updateBoardTitle } from '../../utils/boardRequest';

const MenuDiv = styled.div`
    display: flex;
    position: relative;
    justify-content: space-between;
    line-height: 30px;
    align-items: center;
    width: 100%;
    min-height: 30px;
    padding: 5px 0;
`;

const LeftTopmenuDiv = styled.div`
    width: 50%;

    @media ${(props) => props.theme.sideBar} {
        width: 80%;
        max-height: 40px;
        display: flex;
    }
`;

const BoardTitle = styled.span`
    margin-right: 2%;
    border-radius: 4px;
    padding: 5px 5px;
    resize: none;
    margin-left: 2em;
    font-weight: 900;
    font-family: '돋움';
    ${(props) =>
        props.state === 'span' &&
        `&:hover {
            cursor: pointer;
            opacity: 0.4;
            background-color: gray;
            color: white;
        }`};
    @media ${(props) => props.theme.sideBar} {
        margin-left: 2px;
        max-width: 120px;
        white-space: nowrap;
        overflow-x: auto;
        overflow-y: hidden;
        min-height: 40px;
    }
`;

const BoardInput = styled.input`
    width: ${(props) => (props.width <= 0 ? 30 : props.width * 15)}px;
    height: 30px;
    position: relative;
    border-radius: 4px;
    margin-left: 2em;
    margin-right: 2%;
    z-index: 3;
    &:focus {
        outline: 1px solid blue;
    }
    @media ${(props) => props.theme.sideBar} {
        margin-left: 2px;
        max-width: 120px;
    }
`;

const ButtonForGettingInvitedUser = styled.button`
    border-radius: 4px;
    padding: 5px 10px;
    margin-right: 2%;
    background-color: rgba(20, 197, 247, 0.17);
    &:hover {
        background-color: gray;
        opacity: 0.5;
        color: white;
    }
`;

const InviteButton = styled.button`
    border-radius: 4px;
    padding: 5px 10px;
    background-color: rgba(20, 197, 247, 0.17);
    &:hover {
        background-color: gray;
        opacity: 0.5;
        color: white;
    }
`;

const MenuButton = styled.button`
    display: ${(props) => (props.sidebarDisplay ? 'none' : 'block')};
    margin-right: 5%;
    border-radius: 4px;
    padding: 5px 10px;
    background-color: rgba(20, 197, 247, 0.17);
    &:hover {
        background-color: gray;
        opacity: 0.5;
        color: white;
    }
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

const MenuWrapper = styled.div`
    width: 50%;
    display: flex;
    justify-content: flex-end;
    padding: 5px 0;

    @media ${(props) => props.theme.sideBar} {
        width: 20%;
    }
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
    const { myBoards, invitedBoards } = useContext(BoardsStatusContext);
    const boardsDispatch = useContext(BoardsDispatchContext);

    useEffect(() => {
        setInputContent(boardDetail.title);
    }, [boardDetail]);

    const inputTag = useRef();

    const changeBoardTitle = async (evt) => {
        if (evt.keyCode === 13) {
            const replacedTitle = inputContent.replace(/ /g, '');
            if (!replacedTitle || !inputContent || inputContent === boardDetail.title) {
                setInputContent(boardDetail.title);
                setInputState('span');
                return;
            }
            await updateBoardTitle(boardDetail.id, inputContent);
            setBoardDetail({
                ...boardDetail,
                title: inputContent,
            });

            const newMyBoards = myBoards.map((board) => {
                if (board.id === boardDetail.id) board.title = inputContent;
                return board;
            });
            const newInvitedBoards = invitedBoards.map((board) => {
                if (board.id === boardDetail.id) board.title = inputContent;
                return board;
            });
            const newBoards = { myboards: newMyBoards, invitedBoards: newInvitedBoards };
            boardsDispatch({ type: 'MODIFY_BOARD', boards: newBoards });

            setInputState('span');
        }
    };

    const dimmedClickHandler = async () => {
        if (!inputContent || inputContent === boardDetail.title) {
            setInputContent(boardDetail.title);
            setInputState('span');
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
        <MenuDiv>
            <LeftTopmenuDiv>
                {inputState === 'span' && (
                    <BoardTitle state={inputState} onClick={() => setInputState('input')}>
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
                            offsetX: evt.target.getBoundingClientRect().top,
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
                            offsetX: evt.target.getBoundingClientRect().top,
                        })
                    }
                >
                    초대하기
                </InviteButton>
            </LeftTopmenuDiv>
            <MenuWrapper>
                <MenuButton sidebarDisplay={sidebarDisplay} onClick={() => setSidebarDisplay(true)}>
                    메뉴
                </MenuButton>
            </MenuWrapper>
        </MenuDiv>
    );
};

export default TopMenu;
