import React from 'react';
import styled from 'styled-components';
import NaverLoginButton from './NaverLoginButton';
import GitHubLoginButton from './GitHubLoginButton';
import backgroundVideo from '../../image/background.mp4';
import logo from '../../image/app_logo.png';

const LoginPageWrapper = styled.div`
    width: '100%';
    height: '100%';
    overflow: 'hidden';
    margin: '0px auto';
    position: 'absolute';
`;

const LogoImg = styled.img`
    position: absolute;
    top: 20%;
    left: 50%;
    transform: translate(-50%, -50%);
    @media ${(props) => props.theme.sideBar} {
        width: 70%;
    }
`;

const Viedo = styled.video`
    width: 100%;
    height: 100%;
    @media ${(props) => props.theme.sideBar} {
        width: 350%;
        transform: translate(-35%, 0%);
    }
`;

const Login = () => {
    return (
        <>
            <LoginPageWrapper>
                <Viedo muted autoPlay loop>
                    <source src={backgroundVideo} type="video/mp4" />
                </Viedo>
                <LogoImg src={logo} alt="naver login" />
                <NaverLoginButton />
                <GitHubLoginButton />
            </LoginPageWrapper>
        </>
    );
};

export default Login;
