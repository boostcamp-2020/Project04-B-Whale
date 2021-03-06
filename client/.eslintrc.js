module.exports = {
    env: {
        browser: true,
        es2021: true,
        node: true,
    },
    extends: ['plugin:react/recommended', 'airbnb', 'prettier', 'prettier/react'],
    parserOptions: {
        ecmaFeatures: {
            jsx: true,
        },
        ecmaVersion: 12,
        sourceType: 'module',
    },
    plugins: ['react', 'prettier'],
    rules: {
        'prettier/prettier': 'error',
        'react/jsx-filename-extension': [1, { extensions: ['.js', '.jsx'] }],
        'react/prop-types': 'off',
        'import/prefer-default-export': 'off',
        'no-case-declarations': 'off',
        'no-param-reassign': 'off',
        'no-console': 'off',
        'no-alert': 'off',
    },
};
