import React from 'react';
import styled from 'styled-components';

const Wrapper = styled.div`
    display: flex;
    justify-content: flex-end;
`;

const CheckBoxWrapper = styled.div`
    display: inline-block;
    margin: 0 5px;
    padding: 5px;
    border: ${(props) => props.theme.border};
    border-radius: ${(props) => props.theme.radiusSmall};
`;

const Label = styled.label.attrs({
    for: 'me-checkbox',
})`
    margin-left: 5px;
    font-size: 18px;
`;

const CheckBox = styled.input.attrs({
    id: 'me-checkbox',
    type: 'checkbox',
    checked: true,
})`
    width: 15px;
    height: 15px;
`;

const MeCheckBox = () => {
    return (
        <Wrapper>
            <CheckBoxWrapper>
                <CheckBox />
                <Label>Me</Label>
            </CheckBoxWrapper>
        </Wrapper>
    );
};
export default MeCheckBox;
