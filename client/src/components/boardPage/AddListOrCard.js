import React, { useState } from 'react';
import styled from 'styled-components';
import { AiOutlinePlus } from 'react-icons/ai';
import { GrClose } from 'react-icons/gr';
import { DatePicker } from 'antd';
import 'antd/dist/antd.css';
import moment from 'moment';

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
    /* height: 80px; */
    padding: 5px;
    border-radius: 8px;
    background-color: lightgray;
`;

const AddButton = styled.button`
    width: auto;
    padding: 0 10px;
    height: 30px;
`;

export default function AddListBtnInput({ parent }) {
    const [state, setState] = useState('button');
    let datetime = '';
    const dateFormat = 'YYYY-MM-DD HH:mm:ss';

    const okHandler = (value) => {
        const m = new Date(value);
        const dateString = `${m.getFullYear()}-${`0${m.getMonth() + 1}`.slice(
            -2,
        )}-${`0${m.getDate()}`.slice(-2)} ${`0${m.getHours()}`.slice(
            -2,
        )}:${`0${m.getMinutes()}`.slice(-2)}:${`0${m.getSeconds()}`.slice(-2)}`;
        datetime = dateString;
    };

    const addCardOrListHandler = () => {
        console.log(datetime);
    };

    if (state === 'button') {
        return (
            <div>
                <AddListButton parent={parent} onClick={() => setState('input')}>
                    <AiOutlinePlus />
                    {parent === 'list' ? 'Add a list' : 'Add a card'}
                </AddListButton>
            </div>
        );
    }
    return (
        <div style={{ display: 'flex', alignItems: 'baseline' }}>
            <InputWrapper parent={parent}>
                <TitleInput
                    placeholder={
                        parent === 'list' ? '리스트 제목을 입력하세요.' : '카드 제목을 입력하세요.'
                    }
                    style={{ height: '30px', marginBottom: '5px' }}
                    autoFocus="autoFocus"
                    type="text"
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
                <div
                    style={{
                        marginTop: '5px',
                        display: 'flex',
                        justifyContent: 'flex-start',
                    }}
                >
                    <AddButton onClick={addCardOrListHandler}>
                        {parent === 'list' ? 'Add List' : 'Add Card'}
                    </AddButton>
                    <GrClose
                        onClick={() => setState('button')}
                        style={{ margin: 'auto 5px', cursor: 'pointer' }}
                    />
                </div>
            </InputWrapper>
        </div>
    );
}
