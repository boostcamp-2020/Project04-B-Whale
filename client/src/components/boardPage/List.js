import React from 'react';
import styled from 'styled-components';
import AddListOrCard from './AddListOrCard';

const ListWrapper = styled.div`
    background-color: lightgray;
    margin-right: 10px;
    width: auto;
    height: auto;
    display: flex;
    padding: 5px;
    border-radius: 6px;
    flex-direction: column;
`;

export default function List() {
    return (
        <ListWrapper>
            <div style={{ margin: '0' }}>타이틀</div>
            <div style={{ margin: 'auto' }} />
            <div style={{ margin: 'auto' }}>
                <AddListOrCard parent="card" />
            </div>
        </ListWrapper>
    );
}
