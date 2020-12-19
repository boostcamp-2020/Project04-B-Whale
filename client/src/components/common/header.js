import React from 'react';
import styled from 'styled-components';
import { ImHome } from 'react-icons/im';
import BoardsButton from './BoardsButton';
import logo from '../../image/app_logo.png';

const HeaderDiv = styled.div`
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 5px 10px;
    width: 100%;
    min-height: 50px;
    background-color: lightskyblue;
`;

const LogoImg = styled.img`
    width: 200px;
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
    margin-right: 10px;
    cursor: pointer;
`;

const HeaderTitle = styled.div``;

const LogoutBtn = styled.button`
    padding: 5px 10px;
    border-radius: ${(props) => props.theme.radiusSmall};
    font-size: 20px;
`;

const Header = () => {
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

                <LogoutBtn onClick={logoutHandler}>로그아웃</LogoutBtn>
            </HeaderDiv>
        </>
    );
};

export default Header;
