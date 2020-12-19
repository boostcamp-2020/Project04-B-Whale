const sizes = {
    sideBar: '610px',
    desktop: '1920px',
};

const sideBar = `(max-width: ${sizes.sideBar})`;

const desktop = `(max-width: ${sizes.desktop})`;

// 사용할 색깔
const colors = {
    redColor: '#f73f52',
    whiteColor: '#f5f5f5',
    blueColor: '#588dff',
    mainColor: '#52524E',
    grayColor: '#908e8e',
    darkgrayColor: '#586069',
    lightGrayColor: '#c7c7c7',
    lightRedColor: '#f76e7c',
    manyColor: '#e0098b',
    someColor: '#f73fae',
    littleColor: '#fa88cd',
};

// 자주 사용하는 css style
const border = '1px solid #e1e4e8';
const radius = '10px';
const radiusSmall = '5px';

const theme = {
    sideBar,
    desktop,
    ...colors,
    border,
    radius,
    radiusSmall,
};

export default theme;
