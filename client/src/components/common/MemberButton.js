import React, { useState } from 'react';
import styled from 'styled-components';
import MemberDropdown from './MemberDropdown';

const Wrapper = styled.div`
    position: relative;
`;

const Button = styled.button`
    margin: 5px 10px;
    padding: 5px 10px;
`;

const MoveButton = () => {
    const [isModalDisplay, setIsModalDisplay] = useState(false);

    const onClickDisplayModal = () => {
        setIsModalDisplay(true);
    };

    return (
        <Wrapper>
            <Button onClick={onClickDisplayModal}>멤버 추가/삭제</Button>
            {isModalDisplay ? <MemberDropdown onClose={() => setIsModalDisplay(false)} /> : null}
        </Wrapper>
    );
};

export default MoveButton;
