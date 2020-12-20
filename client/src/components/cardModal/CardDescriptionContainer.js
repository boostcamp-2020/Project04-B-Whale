import React, { useContext, useEffect, useRef, useState } from 'react';
import styled from 'styled-components';
import CardContext from '../../context/CardContext';
import { modifyCardContent } from '../../utils/cardRequest';
import CardModalButton from './CardModalButton';
import CloseButton from './CloseButton';
import SaveButton from './SaveButton';

const Wrapper = styled.div`
    display: grid;
    grid-template-columns: 1fr 10fr;
    grid-auto-rows: minmax(2.5rem, auto);
    align-items: center;
    width: 100%;
    margin: 0rem 0rem 2rem 0rem;
`;

const CardDescriptionHeaderContainer = styled.div`
    grid-column-start: 2;
    grid-column-end: 3;
    grid-row-start: 1;
    grid-row-end: 2;
    display: flex;
    align-items: center;
    color: #192b4d;
`;

const CardDescriptionHeader = styled.span`
    font-weight: bold;
    margin-right: 0.5rem;
`;

const CardDescription = styled.div`
    display: block;
    grid-column-start: 2;
    grid-column-end: 3;
    grid-row-start: 2;
    grid-row-end: 3;
    color: #192b4d;
    font-size: 0.9rem;
    &:hover {
        cursor: pointer;
    }
`;

const CardDescriptionInputWrapper = styled.div`
    grid-column-start: 2;
    grid-column-end: 3;
    grid-row-start: 2;
    grid-row-end: 3;
    display: grid;
    grid-template-columns: 1fr 8fr;
    grid-auto-rows: auto;
    column-gap: 0.3rem;
    row-gap: 0.3rem;
    align-items: center;
`;

const CardDescriptionInput = styled.textarea`
    grid-column-start: 1;
    grid-column-end: 3;
    grid-row-start: 1;
    grid-row-end: 2;
    width: 100%;
    min-height: 6rem;
    padding: 0.5rem;
    border-radius: 0.2rem;
    color: #192b4d;
    font-size: 0.9rem;
    font-weight: normal;
    resize: vertical;
    &:focus {
        border: 0.15rem solid #0379bf;
        margin: -0.15rem;
    }
`;

const CardDescriptionInputSaveButton = styled(SaveButton)`
    grid-column-start: 1;
    grid-column-end: 2;
    grid-row-start: 2;
    grid-row-end: 3;
`;

const CardDescriptionInputCloseButton = styled(CloseButton)`
    grid-column-start: 2;
    grid-column-end: 3;
    grid-row-start: 2;
    grid-row-end: 3;
`;

const CardDescriptionContainer = ({ cardContent }) => {
    const [visible, setVisible] = useState(false);
    const [cardContentInputState, setCardContentInputState] = useState(cardContent);
    const { cardState, cardDispatch } = useContext(CardContext);
    const cardDescriptionInput = useRef();
    const saveButton = useRef();
    const closeButton = useRef();

    const card = cardState.data;

    useEffect(() => {
        if (visible) {
            cardDescriptionInput.current.focus();
        }
    }, [visible]);

    const inverseVisible = () => {
        setVisible(!visible);
    };

    const onChange = (e) => {
        setCardContentInputState(e.target.value);
    };

    const onClick = async () => {
        await modifyCardContent({ cardId: card.id, cardContent: cardContentInputState });
        cardDispatch({
            type: 'CHANGE_CARD_STATE',
            data: { ...card, content: cardContentInputState },
        });
        inverseVisible();
    };

    const onBlur = async (e) => {
        if (e.relatedTarget !== saveButton.current && e.relatedTarget !== closeButton.current) {
            await modifyCardContent({ cardId: card.id, cardContent: cardContentInputState });
            cardDispatch({
                type: 'CHANGE_CARD_STATE',
                data: { ...card, content: cardContentInputState },
            });
            inverseVisible();
        }
    };

    const onClickCloseButton = () => {
        setCardContentInputState(cardContent);
        inverseVisible();
    };

    return (
        <Wrapper>
            <CardDescriptionHeaderContainer>
                <CardDescriptionHeader>카드 내용</CardDescriptionHeader>
                <CardModalButton
                    width="5rem"
                    height="2rem"
                    visible={!visible}
                    onClick={inverseVisible}
                >
                    카드 수정
                </CardModalButton>
            </CardDescriptionHeaderContainer>
            {!visible && <CardDescription onClick={inverseVisible}>{cardContent}</CardDescription>}
            {visible && (
                <CardDescriptionInputWrapper>
                    <CardDescriptionInput
                        ref={cardDescriptionInput}
                        value={cardContentInputState}
                        onChange={onChange}
                        onBlur={onBlur}
                    />
                    <CardDescriptionInputSaveButton
                        width="3.5rem"
                        height="2rem"
                        onClick={onClick}
                        _ref={saveButton}
                    >
                        저장
                    </CardDescriptionInputSaveButton>
                    <CardDescriptionInputCloseButton
                        width="2rem"
                        onClick={onClickCloseButton}
                        _ref={closeButton}
                    >
                        X
                    </CardDescriptionInputCloseButton>
                </CardDescriptionInputWrapper>
            )}
        </Wrapper>
    );
};

export default CardDescriptionContainer;
