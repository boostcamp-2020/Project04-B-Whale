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
  }
  html {
    height: 100%;
  }
  body {
    height: 100%; font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Open Sans', 'Helvetica Neue', sans-serif;
  }
  #root{
    height: 100%;
  }
  button {
      cursor: pointer;
  }
`;

export default GlobalStyle;
