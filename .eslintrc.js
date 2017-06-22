module.exports = {
  env: {
    browser: true,
    es6: true,
    jquery: true,
    node: true
  },
  globals: {
    moment: true,
    my: true
  },
  extends: 'eslint:recommended',
  parserOptions: {
    ecmaVersion: 2017,
    sourceType: 'script',
    ecmaFeatures: {
      experimentalObjectRestSpread: true
    },
  },
  rules: {
      ////////////////////////////////////////
      // Best Practices
      curly: [ 'error', 'multi-line' ], // enforce consistent brace style for all control statements
      eqeqeq: [ 'error', 'always', { null: 'ignore' } ], // require the use of === and !==

      ////////////////////////////////////////
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
      // require or disallow semicolons instead of ASI http://eslint.org/docs/rules/semi
      semi: [ 'error', 'always', { omitLastInOneLineBlock: true } ],
      // enforce location of semicolons http://eslint.org/docs/rules/semi-style
      'semi-style': [ 'error', 'last' ],
      // semi-spacing http://eslint.org/docs/rules/semi-spacing
      'semi-spacing': [ 'error', { before: false, after: true } ],
      // enforce consistent spacing before or after unary operators http://eslint.org/docs/rules/space-unary-ops
      'space-unary-ops': [ 'error', { words: true,
                                      nonwords: false,
                                      overrides: { }
      } ],
      // enforce consistent linebreak style http://eslint.org/docs/rules/linebreak-style
      'linebreak-style': [ 'error', 'unix' ],

      ////////////////////////////////////////
      // Possible Errors
      // disallow the use of console http://eslint.org/docs/rules/no-console
      'no-console': 'warn',
      // disallow unnecessary semicolons http://eslint.org/docs/rules/no-extra-semi
      'no-extra-semi': 'error',
      // disallow confusing multiline expressions http://eslint.org/docs/rules/no-unexpected-multiline
      'no-unexpected-multiline': 'error',

      ////////////////////////////////////////
      // Variables
      // disallow unused variables http://eslint.org/docs/rules/no-unused-vars
      'no-unused-vars': [ 'error', { vars: 'all',
                                     args: 'all',
                                     ignoreRestSiblings: false,
                                     caughtErrors: 'none' }
      ]
    }
};
