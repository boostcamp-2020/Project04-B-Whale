import React from 'react';
import NaverLoginButton from './NaverLoginButton';
import backgroundVideo from '../../image/background.mp4';

const Login = () => {
    return (
        <>
            <div
                style={{
                    width: '100%',
                    height: '100%',
                    overflow: 'hidden',
                    margin: '0px auto',
                    position: 'relative',
                }}
            >
                <video muted autoPlay loop style={{ width: '100%', height: '100%' }}>
                    <source src={backgroundVideo} type="video/mp4" />
                </video>
                <p
                    style={{
                        position: 'absolute',
                        top: '10%',
                        left: '43%',
                        textAlign: 'center',
                        fontSize: '48px',
                        color: '#f73f52',
                    }}
                >
                    AreUDone
                </p>
                <NaverLoginButton />
            </div>
        </>
    );
};

export default Login;
