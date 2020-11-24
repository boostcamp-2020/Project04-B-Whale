const sizes = {
    sideBar: '590px',
    desktop: '1920px',
};

const sideBar = `(max-width: ${sizes.sideBar})`;

const desktop = `(max-width: ${sizes.desktop})`;

// 사용할 색깔
const colors = {
    redColor: '#f73f52',
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
