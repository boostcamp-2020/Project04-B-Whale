/* eslint-disable no-nested-ternary */
import React, { useRef, useContext } from 'react';
import styled from 'styled-components';
import { BsChevronLeft } from 'react-icons/bs';
import { CgClose } from 'react-icons/cg';
import 'antd/dist/antd.css';
import { Button } from 'antd';
import BoardDetailContext from '../../context/BoardDetailContext';
import { modifyListPosition } from '../../utils/listRequest';

const Wrapper = styled.div`
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    z-index: 99;
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
    width: 225px;
    height: auto;
    border: none;
    background: none;
    cursor: pointer;
`;

const SelectWrapper = styled.div`
    background-color: darkgray;
    width: 100%;
    height: 60px;
    display: flex;
    flex-direction: column;
    padding: 5px;
    border-radius: 6px;
`;

const MoveBtn = styled(Button)`
    margin: 5px 0;
    background: #52b43f;
    color: white;
    border-radius: 5px;
`;

const ListMoveDropdown = ({
    listId,
    setListMenuState,
    listMoveDropdownState,
    setListMoveDropdownState,
}) => {
    const wrapper = useRef();
    const { boardDetail, setBoardDetail } = useContext(BoardDetailContext);
    const currentListInd = boardDetail.lists.findIndex((v) => v.id === listId);
    const selectNode = useRef();

    const onClose = (evt) => {
        if (evt.target === wrapper.current) setListMoveDropdownState({ visible: false });
    };

    const BackBtnOnClick = () => {
        setListMenuState({ ...listMoveDropdownState, visible: true });
        setListMoveDropdownState({ visible: false });
    };

    const moveListHandler = async () => {
        const { selectedIndex } = selectNode.current;
        const { value } = selectNode.current;
        const listCount = boardDetail.lists.length;
        if (currentListInd === selectedIndex) {
            setListMoveDropdownState({ visible: false });
            return;
        }
        let position = 0;
        if (selectedIndex === 0) {
            position = Number(value) / 2;
        } else if (selectedIndex + 1 === listCount) {
            position = Number(value) + 1;
        } else if (selectedIndex < currentListInd) {
            const prevValue = selectNode.current[selectedIndex - 1].value;
            position = (Number(value) + Number(prevValue)) / 2;
        } else {
            const naxtValue = selectNode.current[selectedIndex + 1].value;
            position = (Number(value) + Number(naxtValue)) / 2;
        }
        await modifyListPosition({ listId, position });

        boardDetail.lists[currentListInd].position = position;
        boardDetail.lists.sort((a, b) => {
            return a.position < b.position ? -1 : a.position > b.position ? 1 : 0;
        });
        setBoardDetail({ ...boardDetail });
        setListMoveDropdownState({ visible: false });
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
                <SelectWrapper>
                    <span style={{ marginBottom: '10px' }}>위치</span>
                    <span>
                        <Select ref={selectNode}>
                            {boardDetail.lists.map((value, index) => {
                                return (
                                    <option value={value.position} key={value.id}>
                                        {index === currentListInd
                                            ? `${index + 1} (현재 위치)`
                                            : index + 1}
                                    </option>
                                );
                            })}
                        </Select>
                    </span>
                </SelectWrapper>
                <MoveBtn onClick={moveListHandler}>MoveBtn</MoveBtn>
            </DropdownWrapper>
        </Wrapper>
    );
};

export default ListMoveDropdown;
