module.exports = {
  env: {
    browser: true,
    es6: true,
    node: true,
    jquery: true
  },
  globals: {
    moment: true,
    my: true
  },
  extends: 'eslint:recommended',
  parserOptions: {
    'sourceType': 'module'
  },
  rules: {
      // Best Practices
      curly: [ 'error', 'multi-line' ], // enforce consistent brace style for all control statements
      eqeqeq: [ 'error', 'always', { null: 'ignore' } ], // require the use of === and !==
      // Stylistic Issues
      indent: [ 'error', 2 ],
      quotes: [ 'error', 'single', { avoidEscape: true } ], // enforce the consistent use of either backticks, double, or single quotes
      indent: [ 'error', 2, { SwitchCase: 1,
                              VariableDeclarator: { var: 2, let: 2, const: 3 },
                              outerIIFEBody: 1,
                              MemberExpression: 1,
                              FunctionDeclaration: { body: 1, parameters: 'first'},
                              FunctionExpression: { body: 1, parameters: 'first'},
                              CallExpression: { arguments: 'first'},
                              ArrayExpression: 'first',
                              ObjectExpression: 'first'
                              //flatTernaryExpressions: true
      } ],
      // Possible Errors
      'no-console': 'warn'// disallow the use of console http://eslint.org/docs/rules/no-console




      // 'linebreak-style': [
      //     'error',
      //     'windows'
      // ],

      // 'semi': [
      //     'error',
      //     'always'
      // ]
  }
};
