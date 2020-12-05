/* eslint-disable jsx-a11y/no-autofocus */
import React, { useContext, useState } from 'react';
import styled from 'styled-components';
import BoardDetailContext from '../../context/BoardDetailContext';

const MenuDiv = styled.div`
    display: flex;
    justify-content: space-between;
    line-height: 40px;
    width: 100%;
    min-height: 30px;
`;

const BoardTitle = styled.span`
    margin-right: 5%;
    border-radius: 4px;
    padding: 5px 5px;
    resize: none;
    margin-left: 5%;
    ${(props) =>
        props.state === 'span' &&
        `&:hover {
        cursor: pointer;
        opacity: 0.3;
        background-color: gray;
    }`};
`;

const BoardInput = styled.input`
    width: ${(props) => (props.width <= 0 ? 20 : props.width * 10)}px;
    height: 30px;
    border-radius: 4px;
`;

const ButtonForGettingInvitedUser = styled.button`
    opacity: 0.3;
    border-radius: 4px;
    padding: 5px 10px;
    margin-right: 5%;
`;

const InviteButton = styled.button`
    opacity: 0.3;
    border-radius: 4px;
    padding: 5px 10px;
`;

const MenuButton = styled.button`
    margin-right: 5%;
    opacity: 0.3;
    border-radius: 4px;
    padding: 5px 10px;
`;

const TopMenu = (props) => {
    const { boardDetail, setBoardDetail } = useContext(BoardDetailContext);
    const [inputState, setInputState] = useState('span');

    const boardTitleClickHandler = () => {
        setInputState('input');
    };
    const changeBoardTitle = (evt) => {
        if (evt.keyCode === 13) {
            // 이름 변경api, boardDetailcontext 이름 변경
            console.log(boardDetail.title);
        }
    };
    return (
        <MenuDiv>
            <div style={{ width: '50%' }}>
                <BoardTitle state={inputState} onClick={boardTitleClickHandler}>
                    {inputState === 'span' && boardDetail.title}
                    {inputState === 'input' && (
                        <BoardInput
                            width={boardDetail.title.length}
                            value={boardDetail.title}
                            onChange={(evt) =>
                                setBoardDetail({ ...boardDetail, title: evt.target.value })
                            }
                            autoFocus="autoFocus"
                            onKeyDown={changeBoardTitle}
                        />
                    )}
                </BoardTitle>
                <ButtonForGettingInvitedUser
                    onClick={(evt) =>
                        props.setInvitedDropdownDisplay({
                            visible: true,
                            offsetY: evt.target.getBoundingClientRect().left,
                        })
                    }
                >
                    참여자 목록
                </ButtonForGettingInvitedUser>
                <InviteButton
                    onClick={(evt) =>
                        props.setAskoverDropdownDisplay({
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
                <MenuButton onClick={() => props.setSidebarDisplay(!props.sidebarDisplay)}>
                    메뉴
                </MenuButton>
            </div>
        </MenuDiv>
    );
};

export default TopMenu;
