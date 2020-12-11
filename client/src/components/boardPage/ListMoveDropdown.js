/* eslint-disable jsx-a11y/click-events-have-key-events */
/* eslint-disable jsx-a11y/no-static-element-interactions */
/* eslint-disable no-unused-vars */
import React, { useRef, useEffect, useContext, useState } from 'react';
import styled from 'styled-components';
import { BsChevronLeft } from 'react-icons/bs';
import { CgClose } from 'react-icons/cg';
import 'antd/dist/antd.css';
import { Button } from 'antd';
import BoardDetailContext from '../../context/BoardDetailContext';

const Wrapper = styled.div`
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
`;

const DropdownWrapper = styled.div`
    position: relative;
    top: ${(props) => props.offsetX + 20}px;
    left: ${(props) => props.offsetY}px;
    width: 250px;
    height: auto;
    background-color: ${(props) => props.theme.whiteColor};
    border: ${(props) => props.theme.border};
    border-radius: ${(props) => props.theme.radiusSmall};
    overflow: auto;
    z-index: 9999;
    max-height: 500px;
    overflow: scroll;
    padding: 5px;
`;

const BackBtn = styled(BsChevronLeft)`
    margin-right: 5px;
    cursor: pointer;
`;

const CloseBtn = styled(CgClose)`
    margin-right: 5px;
    cursor: pointer;
`;

const Hr = styled.hr`
    height: 1px;
    margin: 10px 0;
    background: #bbb;
    background-image: -webkit-linear-gradient(left, #eee, #777, #eee);
    background-image: -moz-linear-gradient(left, #eee, #777, #eee);
    background-image: -ms-linear-gradient(left, #eee, #777, #eee);
    background-image: -o-linear-gradient(left, #eee, #777, #eee);
`;

const Select = styled.select`
    width: 125px; /* 원하는 너비설정 */
    height: auto;
    border: none;
`;

const MoveBtn = styled(Button)`
    margin: 5px 0;
    background: #52b43f;
    color: white;
    border-radius: 5px;
`;

const ListMoveDropdown = ({
    listId,
    listMenuState,
    setListMenuState,
    listMoveDropdownState,
    setListMoveDropdownState,
}) => {
    const wrapper = useRef();
    const { boardDetail, setBoardDetail } = useContext(BoardDetailContext);
    const lists = new Array(boardDetail.lists.length).fill(0);
    const currentPos = boardDetail.lists.find((v) => v.id === listId).position;
    const [selectedPos, setSelectedPos] = useState(currentPos);
    const selectNode = useRef();

    const onClose = (evt) => {
        if (evt.target === wrapper.current) setListMoveDropdownState({ visible: false });
    };

    const BackBtnOnClick = () => {
        setListMenuState({ ...listMoveDropdownState, visible: true });
        setListMoveDropdownState({ visible: false });
    };

    const moveListHandler = () => {
        console.log(selectedPos);
    };

    return (
        <Wrapper onClick={onClose} ref={wrapper}>
            <DropdownWrapper
                offsetY={listMoveDropdownState.offsetY}
                offsetX={listMoveDropdownState.offsetX}
            >
                <div style={{ display: 'flex', justifyContent: 'space-between' }}>
                    <BackBtn onClick={BackBtnOnClick} />
                    <div>리스트 이동</div>
                    <CloseBtn onClick={() => setListMoveDropdownState({ visible: false })} />
                </div>
                <Hr />
                <div
                    style={{
                        backgroundColor: 'darkgray',
                        width: '100%',
                        height: '60px',
                        display: 'flex',
                        flexDirection: 'column',
                        padding: '5px',
                        borderRadius: '6px',
                        cursor: 'pointer',
                    }}
                >
                    <span style={{ marginBottom: '10px' }}>위치</span>
                    <span>
                        <Select
                            ref={selectNode}
                            value={selectedPos}
                            onChange={(evt) => setSelectedPos(evt.target.value)}
                        >
                            {lists.map((value, index) => {
                                return (
                                    <option value={index + 1} selected={index + 1 === currentPos}>
                                        {index + 1 === currentPos
                                            ? `${index + 1} (현재 위치)`
                                            : index + 1}
                                    </option>
                                );
                            })}
                        </Select>
                    </span>
                </div>
                <MoveBtn onClick={moveListHandler}>MoveBtn</MoveBtn>
            </DropdownWrapper>
        </Wrapper>
    );
};

export default ListMoveDropdown;
