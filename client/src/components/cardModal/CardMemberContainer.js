import React from 'react';
import styled from 'styled-components';
import Member from './Member';

const Wrapper = styled.div`
    width: 100%;
    height: 5rem;
    margin: 0 3rem;
`;

const CardMemberHeader = styled.div`
    color: #192b4d;
    font-weight: bold;
`;

const CardMemberWrapper = styled.div`
    display: flex;
    margin: 5px 0;
    font-size: 0.9rem;
`;

const CardMemberContainer = ({ members }) => {
    return (
        <Wrapper>
            <CardMemberHeader>멤버</CardMemberHeader>
            <CardMemberWrapper>
                {members !== [] && members.map((member) => <Member member={member} />)}
            </CardMemberWrapper>
        </Wrapper>
    );
};

export default CardMemberContainer;
