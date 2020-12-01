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
        'import/prefer-default-export': 'off',
        'import/no-default-export': 'error',
        'import/no-cycle': 'off',
        'class-methods-use-this': 'off',
        'no-unused-vars': 'warn',
    },
};
