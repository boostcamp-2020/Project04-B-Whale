import { createGlobalStyle } from 'styled-components';
import reset from 'styled-reset';

const GlobalStyle = createGlobalStyle`
  ${reset};
  @import url('https://fonts.googleapis.com/css2?family=Open+Sans:wght@400;600;700&display=swap');
  * {
      box-sizing: border-box;
      margin: 0;
      padding: 0;
      border: none;
      font-size: 16px;
      font-weight: 600;
      outline: none;
      text-decoration: none;
      user-select: none;
  }

  @font-face {
    font-family: 'NanumBarunpen';
    src: url('https://cdn.jsdelivr.net/gh/projectnoonnu/noonfonts_two@1.0/NanumBarunpen.woff') format('woff');
    font-weight: normal;
    font-style: normal;
  }

  body {
    /* height: 100%;  */
    font-family: NanumBarunpen;
  }
  #root{
        height: 100%; 
  }
  button {
      cursor: pointer;
  }
`;

export default GlobalStyle;
