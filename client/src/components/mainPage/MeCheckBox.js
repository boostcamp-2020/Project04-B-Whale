import React, { useContext } from 'react';
import styled from 'styled-components';
import { CalendarDispatchContext, CalendarStatusContext } from '../../context/CalendarContext';
import { getCardCount } from '../../utils/cardRequest';

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

    @media ${(props) => props.theme.sideBar} {
        margin: 0 10px;
    }
`;

const Label = styled.label.attrs({
    htmlFor: 'me-checkbox',
})`
    margin-left: 5px;
    font-size: 18px;
    cursor: pointer;
`;

const CheckBox = styled.input.attrs({
    id: 'me-checkbox',
    type: 'checkbox',
})`
    width: 15px;
    height: 15px;
    cursor: pointer;
`;

const MeCheckBox = () => {
    const { member, selectedDate: date } = useContext(CalendarStatusContext);
    const calendarDispatch = useContext(CalendarDispatchContext);

    const onChangeMeCheckBox = async () => {
        const isMember = member ? undefined : 'me';
        const startDate = date.clone().startOf('month').startOf('week').format('YYYY-MM-DD');
        const endDate = date.clone().endOf('month').endOf('week').format('YYYY-MM-DD');
        const { data } = await getCardCount({
            startDate,
            endDate,
            member: isMember,
        });
        calendarDispatch({ type: 'CHANGE_MEMBER', isMember, cardCount: data.cardCounts });
    };

    return (
        <Wrapper>
            <CheckBoxWrapper>
                <CheckBox defaultChecked={member} onChange={onChangeMeCheckBox} />
                <Label>내 카드만 보기</Label>
            </CheckBoxWrapper>
        </Wrapper>
    );
};
export default MeCheckBox;
