import React, { useState } from 'react';
import styled from 'styled-components';
import { IoIosClose } from 'react-icons/io';
import DatePicker, { registerLocale } from 'react-datepicker';
import 'react-datepicker/dist/react-datepicker.css';
import ko from 'date-fns/locale/ko';

registerLocale('ko', ko);

const Wrapper = styled.div`
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
`;

const ModalWrapper = styled.div`
    position: absolute;
    top: 2.3em;
    left: 0.6em;
    display: inline-block;
    padding: 5px;
    background-color: ${(props) => props.theme.whiteColor};
    border: ${(props) => props.theme.border};
    border-radius: ${(props) => props.theme.radiusSmall};
`;

const ModalHeader = styled.div`
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding-bottom: 5px;
    border-bottom: ${(props) => props.theme.border};
`;

const ModalTitle = styled.div`
    font-size: 18px;
    font-weight: 700;
`;

const ModalBody = styled.div`
    margin-top: 5px;
    padding: 10px;
`;

const DateWrapper = styled.div``;

const SelectDate = styled.input.attrs({
    type: 'text',
})`
    margin: 10px 0;
    padding: 3px 5px;
    border: ${(props) => props.theme.border};
`;

const Button = styled.button.attrs({ type: 'button' })`
    margin-top: 10px;
    padding: 5px 20px;
    border: ${(props) => props.theme.border};
    border-radius: ${(props) => props.theme.radiusSmall};
    background-color: ${(props) => props.theme.redColor};
    color: ${(props) => props.theme.whiteColor};
`;

const MoveModal = ({ onClose }) => {
    const [startDate, setStartDate] = useState(new Date());

    const onClickClose = (e) => {
        if (e.target === e.currentTarget) {
            onClose();
        }
    };

    return (
        <>
            <Wrapper onClick={onClickClose} />
            <ModalWrapper>
                <ModalHeader>
                    <div />
                    <ModalTitle>마감 기한 변경</ModalTitle>
                    <IoIosClose size={24} cursor="pointer" onClick={onClose} />
                </ModalHeader>
                <ModalBody>
                    <DateWrapper>
                        <ModalTitle>날짜 및 시간</ModalTitle>
                        <DatePicker
                            selected={startDate}
                            dateFormat="MM/dd/yyyy h:mm aa"
                            customInput={<SelectDate />}
                            readOnly
                        />
                        <DatePicker
                            selected={startDate}
                            onChange={(date) => setStartDate(date)}
                            showTimeInput
                            locale="ko"
                            inline
                        />
                    </DateWrapper>
                    <Button>저장하기</Button>
                </ModalBody>
            </ModalWrapper>
        </>
    );
};

export default MoveModal;
