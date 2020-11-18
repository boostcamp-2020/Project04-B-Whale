module.exports = {
    env: {
        es6: true,
        es2021: true,
        node: true,
        jest: true,
        jasmine: true,
    },
    extends: ['airbnb-base', 'prettier'],
    parserOptions: {
        ecmaVersion: 12,
        sourceType: 'module',
        babelOptions: {
            configFile: './.babelrc.js',
        },
    },
    plugins: ['import', 'prettier'],
    parser: '@babel/eslint-parser',
    rules: {
        'prettier/prettier': 'error',
    },
};
