import React, { useState } from 'react';
import styled from 'styled-components';
import { ImHome } from 'react-icons/im';
import Modal from './CreateBoardModal';
import BoardsButton from './BoardsButton';
import logo from '../../image/app_logo.png';

const HeaderDiv = styled.div`
    display: flex;
    justify-content: space-between;
    align-items: center;
    width: 100%;
    height: 80px;
    min-height: 50px;
    background-color: lightskyblue;
`;

const LogoImg = styled.img`
    width: 250px;
    cursor: pointer;

    @media ${(props) => props.theme.sideBar} {
        width: 140px;
    }
`;

const ButtonDiv = styled.div`
    display: flex;
    padding-left: 10px;
    align-items: center;
`;

const GoCalendarBtn = styled(ImHome)`
    width: 20px;
    height: 20px;
    cursor: pointer;
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
        document.location = '/login';
    };

    const goMainBtnHandler = () => {
        document.location = '/';
    };
    return (
        <>
            <HeaderDiv>
                <ButtonDiv>
                    <GoCalendarBtn onClick={goMainBtnHandler} />
                    <BoardsButton />
                </ButtonDiv>
                <HeaderTitle>
                    <LogoImg
                        src={logo}
                        alt="AreUDone logo"
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
