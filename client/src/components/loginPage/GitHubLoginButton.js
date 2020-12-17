import React from 'react';
import { GithubLoginButton } from 'react-social-login-buttons';

const NaverLoginButton = () => {
    const onClickGitHubLogin = () => {
        window.location.href = `${process.env.REACT_APP_BASE_URL}/api/oauth/login/github`;
    };

    return (
        <GithubLoginButton
            onClick={onClickGitHubLogin}
            style={{
                position: 'absolute',
                top: '90%',
                background: '#555555',
                left: '50%',
                transform: 'translate(-52%, -50%)',
                width: '300px',
                height: '65px',
            }}
        />
    );
};

export default NaverLoginButton;
