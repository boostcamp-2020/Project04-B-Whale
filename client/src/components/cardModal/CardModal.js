import React from 'react';
import styled from 'styled-components';
import CardDescriptionContainer from './CardDescriptionContainer';
import CardDueDateContainer from './CardDueDateContainer';
import CardModalButton from './CardModalButton';
import CardTitleContainer from './CardTitleContainer';
import CommentContainer from './CommentContainer';

const DimmedModal = styled.div`
    display: ${(props) => (props.visible ? 'block' : 'none')};
    position: fixed;
    top: 0;
    left: 0;
    bottom: 0;
    right: 0;
    background-color: rgba(0, 0, 0, 0.6);
    z-index: 1;
`;

const ModalWrapper = styled.div`
    display: ${(props) => (props.visible ? 'block' : 'none')};
    position: fixed;
    top: 0;
    right: 0;
    bottom: 0;
    left: 0;
    z-index: 2;
    overflow: auto;
    outline: 0;
`;

const ModalInner = styled.div`
    display: grid;
    grid-template-columns: 3fr 1fr;
    width: 768px;
    height: 885px;
    background-color: #f4f5f7;
    position: absolute;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    padding: 1rem;
    border-radius: 0.2rem;
`;

const CardModalLeftSideBar = styled.div`
    grid-column-start: 1;
    grid-column-end: 2;
`;

const CardModalRightSideBar = styled.div`
    display: flex;
    flex-direction: column;
    align-items: center;
    grid-column-start: 2;
    grid-column-end: 3;
    button {
        margin: 0.2rem 0rem;
    }
`;

const ButtonList = styled.div`
    display: flex;
    flex-direction: column;
    align-items: center;
    margin-top: 5rem;
`;

const CardModal = ({ visible, closeModal }) => {
    const onDimmedClick = (e) => {
        if (e.target === e.currentTarget) {
            closeModal();
        }
    };
    return (
        <>
            <DimmedModal visible={visible} />
            <ModalWrapper onClick={onDimmedClick} visible={visible}>
                <ModalInner>
                    <CardModalLeftSideBar>
                        <CardTitleContainer cardTitle="카드 타이틀" cardListTitle="리스트 타이틀" />
                        <CardDueDateContainer dueDate="2020-12-25 00:00:00" />
                        <CardDescriptionContainer />
                        <CommentContainer />
                    </CardModalLeftSideBar>
                    <CardModalRightSideBar>
                        <ButtonList>
                            <CardModalButton width="10rem" height="2rem">
                                멤버 추가
                            </CardModalButton>
                            <CardModalButton width="10rem" height="2rem">
                                마감 기한
                            </CardModalButton>
                            <CardModalButton width="10rem" height="2rem">
                                카드 이동
                            </CardModalButton>
                        </ButtonList>
                    </CardModalRightSideBar>
                </ModalInner>
            </ModalWrapper>
        </>
    );
};

export default CardModal;
