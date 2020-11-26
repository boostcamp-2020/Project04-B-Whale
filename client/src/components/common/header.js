import React, { useState } from 'react';
import styled from 'styled-components';
import Modal from './create-board-modal';
import BoardsButton from './BoardsButton';

const HeaderDiv = styled.div`
    display: flex;
    justify-content: space-between;
    align-items: center;
    width: 100%;
    height: 10%;
    min-height: 50px;
    background-color: #f73f52;
`;

const HeaderTitle = styled.div`
    color: white;
`;

const AddBoardBtn = styled.button`
    padding: 5px 10px;
    margin-right: 10px;
`;

const LogoutBtn = styled.button`
    padding: 5px 10px;
    margin-right: 10px;
`;

const Header = () => {
    const [createBoardModalVisible, setCreateBoardModalVisible] = useState(false);

    const logoutHandler = () => {
        // logout 로직
        // 로컬스토리지 jwt 삭제하고
        // 로그인화면으로
    };

    return (
        <>
            <HeaderDiv>
                <BoardsButton />
                <HeaderTitle>TODO LIST</HeaderTitle>

                <div>
                    <AddBoardBtn onClick={() => setCreateBoardModalVisible(true)}>+</AddBoardBtn>
                    <LogoutBtn onClick={logoutHandler}>로그아웃</LogoutBtn>
                </div>
            </HeaderDiv>
            {createBoardModalVisible && (
                <Modal
                    visible={createBoardModalVisible}
                    onClose={() => setCreateBoardModalVisible(false)}
                />
            )}
        </>
    );
};

export default Header;
