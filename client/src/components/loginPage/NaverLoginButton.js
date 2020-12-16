import React from 'react';
import styled from 'styled-components';
import image from '../../image/naverLoginBtn.PNG';

const NaverLoginButtonImg = styled.img`
    width: 300px;
    position: absolute;
    top: 80%;
    left: 50%;
    transform: translate(-50%, -50%);
    cursor: pointer;
`;

const NaverLoginButton = () => {
    const onClickNaverLogin = () => {
        window.location.href = `${process.env.REACT_APP_BASE_URL}/api/oauth/login/naver`;
    };

    return <NaverLoginButtonImg src={image} alt="naver login" onClick={onClickNaverLogin} />;
};

export default NaverLoginButton;
