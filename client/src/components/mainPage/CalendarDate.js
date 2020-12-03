import React from 'react';
import styled from 'styled-components';
import { BsCardChecklist } from 'react-icons/bs';

const DateWrapper = styled.div`
    width: calc(100% / 7);
    margin: 5px;
    padding: 8px;
    border: ${(props) => props.theme.border};
    font-size: 20px;
    cursor: pointer;

    &:first-child {
        color: ${(props) => props.theme.redColor};
    }
    &:last-child {
        color: ${(props) => props.theme.blueColor};
    }
    &:hover {
        background-color: #00ff00;
    }
`;

const DateNumber = styled.div``;

const CardCountWrapper = styled.div`
    visibility: ${(props) => (props.count ? 'visible' : 'hidden')};
    display: flex;
    justify-content: space-between;
    align-items: center;
    width: 100%;
    margin-top: 10px;
    padding: 5px 8px;
    border-radius: ${(props) => props.theme.radiusSmall};
    color: ${(props) => props.theme.whiteColor};

    &.manyCard {
        background-color: ${(props) => props.theme.manyColor};
    }
    &.someCard {
        background-color: ${(props) => props.theme.someColor};
    }
    &.littleCard {
        background-color: ${(props) => props.theme.littleColor};
    }

    @media ${(props) => props.theme.sideBar} {
        padding: 2px;
        justify-content: center;
        & > svg {
            width: 20px;
            height: 20px;
        }
    }
`;

const CardCount = styled.div`
    @media ${(props) => props.theme.sideBar} {
        display: none;
    }
`;

const getCardBackground = (count) => {
    if (count > 10) return 'manyCard';
    if (count > 5) return 'someCard';
    return 'littleCard';
};

const Date = ({ className, onClick, date, count }) => {
    const cardBackground = getCardBackground(count);

    return (
        <DateWrapper className={className} onClick={() => onClick(date)}>
            <DateNumber>{date.format('D')}</DateNumber>
            <CardCountWrapper className={cardBackground} count={count}>
                <BsCardChecklist size={24} />
                <CardCount>{count || 0}</CardCount>
            </CardCountWrapper>
        </DateWrapper>
    );
};
export default Date;
