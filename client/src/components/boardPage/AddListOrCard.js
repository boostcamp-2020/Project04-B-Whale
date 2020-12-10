/* eslint-disable no-unused-vars */
import React, { useRef, useState, useContext } from 'react';
import { withRouter } from 'react-router-dom';
import styled from 'styled-components';
import { AiOutlinePlus } from 'react-icons/ai';
import { GrClose } from 'react-icons/gr';
import { DatePicker, Modal, Input } from 'antd';
import 'antd/dist/antd.css';
import moment from 'moment';
import { createList } from '../../utils/listRequest';
import BoardDetailContext from '../../context/BoardDetailContext';
import { createCard } from '../../utils/cardRequest';

const Wrapper = styled.div`
    display: flex;
    align-items: baseline;
`;

const AddListButton = styled.button`
    ${(props) => props.parent === 'card' && 'background: none'};
    width: 250px;
    height: 30px;
    border-radius: 8px;
    border: none;
    cursor: pointer;
    &:hover {
        background-color: darkgray;
        opacity: 0.5;
    }
`;

const TitleInput = styled(Input)`
    height: '30px';
`;

const InputWrapper = styled.div`
    display: flex;
    flex-direction: column;
    width: 250px;
    height: ${(props) => (props.parent === 'card' ? 'auto' : 'auto')}px;
    padding: 5px;
    border-radius: 8px;
    background-color: lightgray;
`;

const AddButton = styled.button`
    width: auto;
    padding: 0 10px;
    height: 30px;
`;

const FooterBtnDiv = styled.div`
    margin-top: 5px;
    display: flex;
    justify-content: flex-start;
`;

const CloseBtn = styled(GrClose)`
    margin: auto 5px;
    cursor: pointer;
`;

const AddListOrCard = ({ parent, id, history }) => {
    const getFormattedDate = (datetime) => {
        return `${datetime.getFullYear()}-${`0${datetime.getMonth() + 1}`.slice(
            -2,
        )}-${`0${datetime.getDate()}`.slice(-2)} ${`0${datetime.getHours()}`.slice(
            -2,
        )}:${`0${datetime.getMinutes()}`.slice(-2)}:${`0${datetime.getSeconds()}`.slice(-2)}`;
    };

    const [state, setState] = useState('button');
    const [dueDate, setDueDate] = useState(getFormattedDate(new Date()));
    const { boardDetail, setBoardDetail } = useContext(BoardDetailContext);
    const dateFormat = 'YYYY-MM-DD HH:mm:ss';
    const input = useRef();

    const okHandler = (value) => {
        setDueDate(getFormattedDate(new Date(value)));
    };

    const showInvalidTitleModal = () => {
        Modal.info({
            title: `${parent === 'list' ? '리스트 ' : '카드 '} 제목을 입력해주세요😩`,
            onOk() {
                input.current.focus();
            },
            style: { top: '40%' },
        });
    };

    const switchStatus = (status, executeAfterSuccess) => {
        switch (status) {
            case 201:
            case 204:
                executeAfterSuccess();
                break;
            case 401:
                window.location.href = '/login';
                break;
            case 403:
            case 404:
                history.goBack();
                break;
            default:
                throw new Error(`Unhandled status type : ${status}`);
        }
    };

    const setStateList = () => {
        setBoardDetail({
            ...boardDetail,
            lists: [...boardDetail.lists, { title: input.current.value }],
        });
        setState('button');
    };

    const setStateCard = () => {};

    const checkInputHandler = (evt) => {
        if (evt.keyCode !== undefined && evt.keyCode !== 13) return false;
        const replacedTitle = input.current.value?.replace(/ /g, '');
        if (!replacedTitle) {
            showInvalidTitleModal();
            return false;
        }
        return true;
    };

    const addListHandler = async (evt) => {
        if (!checkInputHandler(evt)) return;
        const { status } = await createList({
            title: input.current.value,
            boardId: boardDetail.id,
        });
        switchStatus(status, setStateList);
    };

    const addCardHandler = async (evt) => {
        // TODO: 카드추가 handler, datetime
        // status switch
        if (!checkInputHandler(evt)) return;
        const { status } = await createCard({
            listId: id,
            title: input.current.value,
            content: '',
            dueDate,
        });
        switchStatus(status, setStateCard);
    };

    if (state === 'button') {
        return (
            <div>
                <AddListButton parent={parent} onClick={() => setState('input')}>
                    <AiOutlinePlus />
                    {parent === 'list' ? ' 리스트 추가' : ' 카드 추가'}
                </AddListButton>
            </div>
        );
    }
    return (
        <Wrapper>
            <InputWrapper parent={parent}>
                <TitleInput
                    ref={input}
                    placeholder={
                        parent === 'list' ? '리스트 제목을 입력하세요.' : '카드 제목을 입력하세요.'
                    }
                    autoFocus="autoFocus"
                    type="text"
                    onKeyDown={addListHandler}
                />
                {parent === 'card' && (
                    <DatePicker
                        showTime
                        style={{ marginTop: '5px' }}
                        defaultValue={moment(
                            `${new Date(Date.now() - new Date().getTimezoneOffset() * 60000)
                                .toISOString()
                                .slice(0, -1)}`,
                            dateFormat,
                        )}
                        format={dateFormat}
                        onOk={okHandler}
                        clearIcon={false}
                    />
                )}
                <FooterBtnDiv>
                    <AddButton onClick={parent === 'list' ? addListHandler : addCardHandler}>
                        만들기
                    </AddButton>
                    <CloseBtn onClick={() => setState('button')} />
                </FooterBtnDiv>
            </InputWrapper>
        </Wrapper>
    );
};

export default withRouter(AddListOrCard);
