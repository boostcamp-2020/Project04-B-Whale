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
import { addNotification } from '../../utils/contentScript';

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
        background-color: gray;
        opacity: 0.5;
        color: white;
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

const AddListBtnInput = ({ parent, id, history }) => {
    const [state, setState] = useState('button');
    let datetime = moment().format('YYYY-MM-DD HH:mm:ss');
    const { boardDetail, setBoardDetail } = useContext(BoardDetailContext);
    const dateFormat = 'YYYY-MM-DD HH:mm:ss';
    const input = useRef();
    const [dueDate, setDueDate] = useState(moment(new Date()).format('YYYY-MM-DD HH:mm:ss'));

    const okHandler = (value) => {
        datetime = moment(new Date(value)).format('YYYY-MM-DD HH:mm:ss');
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

    const checkInputHandler = (evt) => {
        if (evt.keyCode !== undefined && evt.keyCode !== 13) return false;
        const replacedTitle = input.current.state.value?.replace(/ /g, '');
        if (!replacedTitle) {
            showInvalidTitleModal();
            return false;
        }
        return true;
    };

    const setStateList = (responseData) => {
        setBoardDetail({
            ...boardDetail,
            lists: [
                ...boardDetail.lists,
                {
                    id: responseData.id,
                    title: responseData.title,
                    position: responseData.position,
                    cards: [{ id: 0 }],
                },
            ],
        });
        setState('button');
    };

    const setStateCard = (responseData) => {
        const { title, position } = responseData;
        boardDetail.lists[boardDetail.lists.findIndex((v) => v.id === id)].cards.push({
            id: responseData.id,
            title,
            dueDate: responseData.dueDate,
            position,
            content: '',
            commentCount: 0,
        });
        setBoardDetail({ ...boardDetail });
        setState('button');
    };

    const addListHandler = async (evt) => {
        if (!checkInputHandler(evt)) return;
        const { status, data } = await createList({
            title: input.current.state.value,
            boardId: boardDetail.id,
        });
        setStateList(data);
    };

    const addCardHandler = async (evt) => {
        if (!checkInputHandler(evt)) return;
        const { status, data } = await createCard({
            listId: id,
            title: input.current.state.value,
            content: '',
            dueDate: datetime,
        });
        addNotification(data);
        setStateCard(data);
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
                    onKeyDown={parent === 'list' ? addListHandler : addCardHandler}
                />
                {parent === 'card' && (
                    <DatePicker
                        showTime
                        style={{ marginTop: '5px' }}
                        defaultValue={moment(datetime, dateFormat)}
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
