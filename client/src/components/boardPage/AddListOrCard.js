/* eslint-disable no-unused-vars */
import React, { useRef, useState, useContext } from 'react';
import { withRouter } from 'react-router-dom';
import styled from 'styled-components';
import { AiOutlinePlus } from 'react-icons/ai';
import { GrClose } from 'react-icons/gr';
import { DatePicker, Modal } from 'antd';
import 'antd/dist/antd.css';
import moment from 'moment';
import { createList } from '../../utils/listRequest';
import BoardDetailContext from '../../context/BoardDetailContext';

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

const TitleInput = styled.input`
    height: '30px';
    margin-bottom: '5px';
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

const AddListBtnInput = ({ parent, history }) => {
    const [state, setState] = useState('button');
    let datetime = '';
    const { boardDetail, setBoardDetail } = useContext(BoardDetailContext);
    const dateFormat = 'YYYY-MM-DD HH:mm:ss';
    const input = useRef();
    const okHandler = (value) => {
        const m = new Date(value);
        const dateString = `${m.getFullYear()}-${`0${m.getMonth() + 1}`.slice(
            -2,
        )}-${`0${m.getDate()}`.slice(-2)} ${`0${m.getHours()}`.slice(
            -2,
        )}:${`0${m.getMinutes()}`.slice(-2)}:${`0${m.getSeconds()}`.slice(-2)}`;
        datetime = dateString;
    };

    const showInvalidTitleModal = () => {
        Modal.info({
            title: '잘못된 형식입니다.',
            content: <p>리스트 제목을 입력해주세요😩</p>,
            onOk() {},
            onCancel() {},
            style: { top: '40%' },
        });
    };

    const addListHandler = async (evt) => {
        if (evt.keyCode !== undefined && evt.keyCode !== 13) return;
        const replacedTitle = input.current.value.replace(/ /g, '');
        if (!replacedTitle) {
            showInvalidTitleModal();
            return;
        }
        const { status } = await createList({
            title: input.current.value,
            boardId: boardDetail.id,
        });
        switch (status) {
            case 201:
                setBoardDetail({
                    ...boardDetail,
                    lists: [...boardDetail.lists, { title: input.current.value }],
                });
                setState('button');
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

    const addCardHandler = () => {
        // TODO: 카드추가 handler, datetime
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

export default withRouter(AddListBtnInput);
