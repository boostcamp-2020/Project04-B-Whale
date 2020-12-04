import React from 'react';
import styled from 'styled-components';
import NaverLoginButton from './NaverLoginButton';
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
`;

const Login = () => {
    return (
        <>
            <LoginPageWrapper>
                <video muted autoPlay loop style={{ width: '100%', height: '100%' }}>
                    <source src={backgroundVideo} type="video/mp4" />
                </video>
                <LogoImg src={logo} alt="naver login" />
                <NaverLoginButton />
            </LoginPageWrapper>
        </>
    );
};

export default Login;
