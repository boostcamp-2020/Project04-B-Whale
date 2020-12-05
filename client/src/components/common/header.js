import React, { useState } from 'react';
import styled from 'styled-components';
import Modal from './CreateBoardModal';
import BoardsButton from './BoardsButton';
import logo from '../../image/app_logo.png';

const HeaderDiv = styled.div`
    display: flex;
    justify-content: space-between;
    align-items: center;
    width: 100%;
    height: 10%;
    min-height: 50px;
    background-color: lightskyblue;
`;

const LogoImg = styled.img`
    width: 250px;
    position: absolute;
    top: 5%;
    left: 50%;
    cursor: pointer;
    transform: translate(-50%, -50%);
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
        localStorage.removeItem('jwt');
        document.location = '/';
    };
    return (
        <>
            <HeaderDiv>
                <BoardsButton />
                <HeaderTitle>
                    <LogoImg
                        src={logo}
                        alt="naver login"
                        onClick={() => {
                            document.location = '/';
                        }}
                    />
                </HeaderTitle>

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
