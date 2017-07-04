module.exports = {
  env: {
    browser: true,
    es6: true,
    jquery: true,
    node: true
  },
    globals: {
    moment: true,
    MyLib: true
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
      ////////////////////////////////////////

      // enforce getter and setter pairs in objects
      // http://eslint.org/docs/rules/accessor-pairs
      'accessor-pairs': 'off',

      // enforce return statements in callbacks of array methods
      // http://eslint.org/docs/rules/array-callback-return
      'array-callback-return': 'error',

      // enforce the use of variables within the scope they are defined
      // http://eslint.org/docs/rules/block-scoped-var
      'block-scoped-var': 'error',

      // enforce that class methods utilize this
      // http://eslint.org/docs/rules/class-methods-use-this
      'class-methods-use-this': [ 'error', { 'exceptMethods': [] } ],

      // enforce a maximum cyclomatic complexity allowed in a program
      // http://eslint.org/docs/rules/complexity
      complexity: [ 'error', { max: 20 } ],

      // require return statements to either always or never specify values
      // http://eslint.org/docs/rules/consistent-return
      'consistent-return': [ 'error', { treatUndefinedAsUnspecified: false } ],

      // enforce consistent brace style for all control statements
      // http://eslint.org/docs/rules/curly
      curly: [ 'error', 'multi-line' ],

      // require default cases in switch statements
      // http://eslint.org/docs/rules/default-case
      'default-case': [ 'error', { commentPattern: '^no default$' } ],

      // enforce consistent newlines before and after dots
      // http://eslint.org/docs/rules/dot-location
      'dot-location': [ 'error', 'property' ],

      // enforce dot notation whenever possible
      // http://eslint.org/docs/rules/dot-notation
      'dot-notation': [ 'error', { allowKeywords: true } ],

      // require the use of === and !==
      // http://eslint.org/docs/rules/eqeqeq
      eqeqeq: [ 'error', 'always', { null: 'ignore' } ], // require the use of === and !==

      // require for-in loops to include an if statement
      // http://eslint.org/docs/rules/guard-for-in
      'guard-for-in': 'error',

      // disallow the use of alert, confirm, and prompt
      // http://eslint.org/docs/rules/no-alert
      'no-alert': 'warn',

      // disallow the use of arguments.caller or arguments.callee
      // http://eslint.org/docs/rules/no-caller
      'no-caller': 'error',

      // disallow lexical declarations in case clauses
      // http://eslint.org/docs/rules/no-case-declarations
      'no-case-declarations': 'error',

      // disallow division operators explicitly at the beginning of regular expressions
      // http://eslint.org/docs/rules/no-div-regex
      'no-div-regex': 'error',

      // disallow else blocks after return statements in if statements
      // http://eslint.org/docs/rules/no-else-return
      'no-else-return': 'error',

      // disallow empty functions
      //http://eslint.org/docs/rules/no-empty-function
      'no-empty-function': [ 'error', { allow: [] } ],

      // disallow empty destructuring patterns
      // http://eslint.org/docs/rules/no-empty-pattern
      'no-empty-pattern': 'error',

      // disallow null comparisons without type-checking operators
      // http://eslint.org/docs/rules/no-eq-null
      'no-eq-null': 'error',

      // disallow the use of eval()
      // http://eslint.org/docs/rules/no-eval
      'no-eval': [ 'error', { allowIndirect: false } ],

      // disallow extending native types
      // http://eslint.org/docs/rules/no-extend-native
      'no-extend-native': [ 'error', { exceptions: [] } ],

      // disallow unnecessary calls to .bind()
      // http://eslint.org/docs/rules/no-extra-bind
      'no-extra-bind': 'error',

      // disallow unnecessary labels
      // http://eslint.org/docs/rules/no-extra-label
      'no-extra-label': 'error',

      // disallow fallthrough of case statements
      // http://eslint.org/docs/rules/no-fallthrough
      'no-fallthrough': [ 'error', { commentPattern: '^ falls through$' } ],

      // disallow leading or trailing decimal points in numeric literals
      // http://eslint.org/docs/rules/no-floating-decimal
      'no-floating-decimal':'error',

      // disallow assignments to native objects or read-only global variables
      // http://eslint.org/docs/rules/no-global-assign
      'no-global-assign': [ 'error', { exceptions: [] } ],

      // disallow shorthand type conversions
      // http://eslint.org/docs/rules/no-implicit-coercion
      'no-implicit-coercion': [ 'error', { boolean: false,
                                           number: false,
                                           string: false,
                                           allow: [] }
      ],

      // disallow variable and function declarations in the global scope
      // http://eslint.org/docs/rules/no-implicit-globals
      'no-implicit-globals': 'error',

      // disallow the use of eval()-like methods
      // http://eslint.org/docs/rules/no-implied-eval
      'no-implied-eval': 'error',

      // disallow this keywords outside of classes or class-like objects
      // http://eslint.org/docs/rules/no-invalid-this
      'no-invalid-this':'error',

      // disallow the use of the __iterator__ property
      // http://eslint.org/docs/rules/no-iterator
      'no-iterator': 'error',

      // disallow labeled statements
      // http://eslint.org/docs/rules/no-labels
      'no-labels':  [ 'error', { allowLoop: false,
                                 allowSwitch: false }
      ],

      // disallow unnecessary nested blocks
      // http://eslint.org/docs/rules/no-lone-blocks
      'no-lone-blocks': 'error',

      // disallow function declarations and expressions inside loop statements
      // http://eslint.org/docs/rules/no-loop-func
      'no-loop-func': 'error',

      // disallow magic numbers
      // http://eslint.org/docs/rules/no-magic-numbers
      'no-magic-numbers': [ 'off', { ignore: [],
                                       ignoreArrayIndexes: false,
                                       enforceConst: true,
                                       detectObjects: true }
      ],

      // disallow multiple spaces
      // http://eslint.org/docs/rules/no-multi-spaces
      'no-multi-spaces': [ 'error', { ignoreEOLComments: false,
                                      exceptions: { Property: true,
                                                    BinaryExpression: false,
                                                    VariableDeclarator: true,
                                                    ImportDeclaration: true } }
      ],

      // disallow multiline strings
      // http://eslint.org/docs/rules/no-multi-str
      'no-multi-str': 'error',

      // disallow new operators outside of assignments or comparisons
      // http://eslint.org/docs/rules/no-new
      'no-new': 'error',

      // disallow new operators with the Function object
      // http://eslint.org/docs/rules/no-new-func
      'no-new-func': 'error',

      // disallow new operators with the String, Number, and Boolean objects
      // http://eslint.org/docs/rules/no-new-wrappers
      'no-new-wrappers': 'error',

      // disallow octal literals
      // http://eslint.org/docs/rules/no-octal
      'no-octal': 'error',

      // disallow octal escape sequences in string literals
      // http://eslint.org/docs/rules/no-octal-escape
      'no-octal-escape': 'error',

      // disallow reassigning function parameters
      // http://eslint.org/docs/rules/no-param-reassign
      'no-param-reassign': [ 'error', { props: true,
                                        ignorePropertyModificationsFor: [ ] } ],

      // disallow the use of the __proto__ property
      // http://eslint.org/docs/rules/no-proto
      'no-proto': 'error',

      // disallow variable redeclaration
      // http://eslint.org/docs/rules/no-redeclare
      'no-redeclare': [ 'error', { builtinGlobals: true } ],

      // disallow certain properties on certain objects
      // http://eslint.org/docs/rules/no-restricted-properties
      'no-restricted-properties': [ 'error',
            { object: 'arguments',
              property: 'callee',
              message: 'arguments.callee is deprecated',
            }, {
              property: '__defineGetter__',
              message: 'Please use Object.defineProperty instead.',
            }, {
              property: '__defineSetter__',
              message: 'Please use Object.defineProperty instead.',
            }, {
             object: 'require',
              message: 'Please call require() directly.' }
      ],

      // disallow assignment operators in return statements
      // http://eslint.org/docs/rules/no-return-assign
      'no-return-assign': [ 'error', 'always' ],

      // disallow unnecessary return await
      // http://eslint.org/docs/rules/no-return-await
      'no-return-await': 'error',

      // disallow javascript: urls
      // http://eslint.org/docs/rules/no-script-url
      'no-script-url': 'error',

      // disallow assignments where both sides are exactly the same
      // http://eslint.org/docs/rules/no-self-assign
      'no-self-assign': [ 'error', { props: true } ],

      // disallow comparisons where both sides are exactly the same
      // http://eslint.org/docs/rules/no-self-compare
      'no-self-compare': 'error',

      // disallow comma operators
      // http://eslint.org/docs/rules/no-sequences
      'no-sequences': 'error',

      // disallow throwing literals as exceptions
      // http://eslint.org/docs/rules/no-throw-literal
      'no-throw-literal': 'error',

      // disallow unmodified loop conditions
      // http://eslint.org/docs/rules/no-unmodified-loop-condition
      'no-unmodified-loop-condition': 'error',

      // disallow unused expressions
      // http://eslint.org/docs/rules/no-unused-expressions
      'no-unused-expressions': [ 'error', { allowShortCircuit: false,
                                            allowTernary: false,
                                            allowTaggedTemplates: false }
      ],
      // disallow unused labels
      // http://eslint.org/docs/rules/no-unused-labels
      'no-unused-labels': 'error',

      // disallow unnecessary calls to .call() and .apply()
      // http://eslint.org/docs/rules/no-useless-call
      'no-useless-call': 'error',

      // disallow unnecessary concatenation of literals or template literals
      // http://eslint.org/docs/rules/no-useless-concat
      'no-useless-concat': 'error',

      // disallow unnecessary escape characters
      // http://eslint.org/docs/rules/no-useless-escape
      'no-useless-escape': 'error',

      // disallow redundant return statements
      // http://eslint.org/docs/rules/no-useless-return
      'no-useless-return': 'error',

      // disallow void operators
      // http://eslint.org/docs/rules/no-void
      'no-void': 'error',

      // disallow specified warning terms in comments
      // http://eslint.org/docs/rules/no-warning-comments
      'no-warning-comments': [ 'error',
                              { terms: [ 'todo', 'fixme', 'any other term' ],
                                location: 'anywhere' }
      ],

      // disallow with statements
      // http://eslint.org/docs/rules/no-with
      'no-with': 'error',

      // require using Error objects as Promise rejection reasons
      // http://eslint.org/docs/rules/prefer-promise-reject-errors
      'prefer-promise-reject-errors': [ 'error', { allowEmptyReject: false } ],

      // enforce the consistent use of the radix argument when using parseInt()
      // http://eslint.org/docs/rules/radix
      radix: [ 'error', 'as-needed' ],

      // disallow async functions which have no await expression
      // http://eslint.org/docs/rules/require-await
      'require-await': 'error',

      // require var declarations be placed at the top of their containing scope
      // http://eslint.org/docs/rules/vars-on-top
      'vars-on-top': 'error',

      // require parentheses around immediate function invocations
      // http://eslint.org/docs/rules/wrap-iife
      'wrap-iife': [ 'error', 'outside', { functionPrototypeMethods: true } ],

      // require or disallow “Yoda” conditions
      // http://eslint.org/docs/rules/yoda
      yoda: [ 'error', 'never', { 'exceptRange': true } ],

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
      // require or disallow semicolons instead of ASI
      // http://eslint.org/docs/rules/semi
      semi: [ 'error', 'always', { omitLastInOneLineBlock: true } ],

      // enforce location of semicolons
      // http://eslint.org/docs/rules/semi-style
      'semi-style': [ 'error', 'last' ],

      // semi-spacing
      // http://eslint.org/docs/rules/semi-spacing
      'semi-spacing': [ 'error', { before: false, after: true } ],

      // enforce consistent spacing before or after unary operators
      // http://eslint.org/docs/rules/space-unary-ops
      'space-unary-ops': [ 'error', { words: true,
                                      nonwords: false,
                                      overrides: { }
      } ],

      // enforce consistent linebreak style
      // http://eslint.org/docs/rules/linebreak-style
      'linebreak-style': [ 'error', 'unix' ],








      // enforce linebreaks after opening and before closing array brackets
      // http://eslint.org/docs/rules/array-bracket-newline
      'array-bracket-newline': [ 'error', { multiline: true } ],

      // enforce consistent spacing inside array brackets
      // http://eslint.org/docs/rules/array-bracket-spacing
      'array-bracket-spacing': [ 'error', 'always', { singleValue: true,
                                                      objectsInArrays: true,
                                                      objectsInArrays: true }
      ],

      // enforce line breaks after each array element
      // http://eslint.org/docs/rules/array-element-newline
      'array-element-newline': [ 'error', { multiline: true } ],

      // enforce consistent spacing inside single-line blocks
      // http://eslint.org/docs/rules/block-spacing
      // 'block-spacing': 'error',

      // enforce consistent brace style for blocks
      // http://eslint.org/docs/rules/brace-style
      // 'brace-style': 'error',

      // enforce camelcase naming convention
      // http://eslint.org/docs/rules/camelcase
      // 'camelcase': 'error',

      // enforce or disallow capitalization of the first letter of a comment
      // http://eslint.org/docs/rules/capitalized-comments
      // 'capitalized-comments': 'error',

      // require or disallow trailing commas
      // http://eslint.org/docs/rules/comma-dangle
      // 'comma-dangle': 'error',

      // enforce consistent spacing before and after commas
      // http://eslint.org/docs/rules/comma-spacing
      // 'comma-spacing': 'error',

      // enforce consistent comma style
      // http://eslint.org/docs/rules/comma-style
      // 'comma-style': 'error',

      // enforce consistent spacing inside computed property brackets
      // http://eslint.org/docs/rules/computed-property-spacing
      // 'computed-property-spacing': 'error',

      // enforce consistent naming when capturing the current execution context
      // http://eslint.org/docs/rules/consistent-this
      // 'consistent-this': 'error',

      // require or disallow newline at the end of files
      // http://eslint.org/docs/rules/eol-last
      // 'eol-last': 'error',

      // require or disallow spacing between function identifiers and their invocations
      // http://eslint.org/docs/rules/func-call-spacing
      // 'func-call-spacing': 'error',

      // require function names to match the name of the variable or property to which they are assigned
      // http://eslint.org/docs/rules/func-name-matching
      // 'func-name-matching': 'error',

      // require or disallow named function expressions
      // http://eslint.org/docs/rules/func-names
      // 'func-names': 'error',

      // enforce the consistent use of either function declarations or expressions
      // http://eslint.org/docs/rules/func-style
      // 'func-style': 'error',

      // disallow specified identifiers
      // http://eslint.org/docs/rules/id-blacklist
      // 'id-blacklist': 'error',

      // enforce minimum and maximum identifier lengths
      // http://eslint.org/docs/rules/id-length
      // 'id-length': 'error',

      // require identifiers to match a specified regular expression
      // http://eslint.org/docs/rules/id-match
      // 'id-match': 'error',

      // enforce consistent indentation
      // http://eslint.org/docs/rules/indent
      // 'indent': 'error',

      // enforce the consistent use of either double or single quotes in JSX attributes
      // http://eslint.org/docs/rules/jsx-quotes
      // 'jsx-quotes': 'error',

      // enforce consistent spacing between keys and values in object literal properties
      // http://eslint.org/docs/rules/key-spacing
      // 'key-spacing': 'error',

      // enforce consistent spacing before and after keywords
      // http://eslint.org/docs/rules/keyword-spacing
      // 'keyword-spacing': 'error',

      // enforce position of line comments
      // http://eslint.org/docs/rules/line-comment-position
      // 'line-comment-position': 'error',

      // enforce consistent linebreak style
      // http://eslint.org/docs/rules/linebreak-style
      // 'linebreak-style': 'error',

      // require empty lines around comments
      // http://eslint.org/docs/rules/lines-around-comment
      // 'lines-around-comment': 'error',

      // enforce a maximum depth that blocks can be nested
      // http://eslint.org/docs/rules/max-depth
      // 'max-depth': 'error',

      // enforce a maximum line length
      // http://eslint.org/docs/rules/max-len
      // 'max-len': 'error',

      // enforce a maximum number of lines per file
      // http://eslint.org/docs/rules/max-lines
      // 'max-lines': 'error',

      // enforce a maximum depth that callbacks can be nested
      // http://eslint.org/docs/rules/max-nested-callbacks
      // 'max-nested-callbacks': 'error',

      // enforce a maximum number of parameters in function definitions
      // http://eslint.org/docs/rules/max-params
      // 'max-params': 'error',

      // enforce a maximum number of statements allowed in function blocks
      // http://eslint.org/docs/rules/max-statements
      // 'max-statements': 'error',

      // enforce a maximum number of statements allowed per line
      // http://eslint.org/docs/rules/max-statements-per-line
      // 'max-statements-per-line': 'error',

      // enforce newlines between operands of ternary expressions
      // http://eslint.org/docs/rules/multiline-ternary
      // 'multiline-ternary': 'error',

      // require constructor names to begin with a capital letter
      // http://eslint.org/docs/rules/new-cap
      // 'new-cap': 'error',

      // require parentheses when invoking a constructor with no arguments
      // http://eslint.org/docs/rules/new-parens
      // 'new-parens': 'error',

      // require a newline after each call in a method chain
      // http://eslint.org/docs/rules/newline-per-chained-call
      // 'newline-per-chained-call': 'error',

      // disallow Array constructors
      // http://eslint.org/docs/rules/no-array-constructor
      // 'no-array-constructor': 'error',

      // disallow bitwise operators
      // http://eslint.org/docs/rules/no-bitwise
      // 'no-bitwise': 'error',

      // disallow continue statements
      // http://eslint.org/docs/rules/no-continue
      // 'no-continue': 'error',

      // disallow inline comments after code
      // http://eslint.org/docs/rules/no-inline-comments
      // 'no-inline-comments': 'error',

      // disallow if statements as the only statement in else blocks
      // http://eslint.org/docs/rules/no-lonely-if
      // 'no-lonely-if': 'error',

      // disallow mixed binary operators
      // http://eslint.org/docs/rules/no-mixed-operators
      // 'no-mixed-operators': 'error',

      // disallow mixed spaces and tabs for indentation
      // http://eslint.org/docs/rules/no-mixed-spaces-and-tabs
      // 'no-mixed-spaces-and-tabs': 'error',

      // disallow use of chained assignment expressions
      // http://eslint.org/docs/rules/no-multi-assign
      // 'no-multi-assign': 'error',

      // disallow multiple empty lines
      // http://eslint.org/docs/rules/no-multiple-empty-lines
      // 'no-multiple-empty-lines': 'error',

      // disallow negated conditions
      // http://eslint.org/docs/rules/no-negated-condition
      // 'no-negated-condition': 'error',

      // disallow nested ternary expressions
      // http://eslint.org/docs/rules/no-nested-ternary
      // 'no-nested-ternary': 'error',

      // disallow Object constructors
      // http://eslint.org/docs/rules/no-new-object
      // 'no-new-object': 'error',

      // disallow the unary operators ++ and --
      // http://eslint.org/docs/rules/no-plusplus
      // 'no-plusplus': 'error',

      // disallow specified syntax
      // http://eslint.org/docs/rules/no-restricted-syntax
      // 'no-restricted-syntax': 'error',

      // disallow all tabs
      // http://eslint.org/docs/rules/no-tabs
      // 'no-tabs': 'error',

      // disallow ternary operators
      // http://eslint.org/docs/rules/no-ternary
      // 'no-ternary': 'error',

      // disallow trailing whitespace at the end of lines
      // http://eslint.org/docs/rules/no-trailing-spaces
      // 'no-trailing-spaces': 'error',

      // disallow dangling underscores in identifiers
      // http://eslint.org/docs/rules/no-underscore-dangle
      // 'no-underscore-dangle': 'error',

      // disallow ternary operators when simpler alternatives exist
      // http://eslint.org/docs/rules/no-unneeded-ternary
      // 'no-unneeded-ternary': 'error',

      // disallow whitespace before properties
      // http://eslint.org/docs/rules/no-whitespace-before-property
      // 'no-whitespace-before-property': 'error',

      // enforce the location of single-line statements
      // http://eslint.org/docs/rules/nonblock-statement-body-position
      // 'nonblock-statement-body-position': 'error',

      // enforce consistent line breaks inside braces
      // http://eslint.org/docs/rules/object-curly-newline
      // 'object-curly-newline': 'error',

      // enforce consistent spacing inside braces
      // http://eslint.org/docs/rules/object-curly-spacing
      // 'object-curly-spacing': 'error',

      // enforce placing object properties on separate lines
      // http://eslint.org/docs/rules/object-property-newline
      // 'object-property-newline': 'error',

      // enforce variables to be declared either together or separately in functions
      // http://eslint.org/docs/rules/one-var
      // 'one-var': 'error',

      // require or disallow newlines around variable declarations
      // http://eslint.org/docs/rules/one-var-declaration-per-line
      // 'one-var-declaration-per-line': 'error',

      // require or disallow assignment operator shorthand where possible
      // http://eslint.org/docs/rules/operator-assignment
      // 'operator-assignment': 'error',

      // enforce consistent linebreak style for operators
      // http://eslint.org/docs/rules/operator-linebreak
      // 'operator-linebreak': 'error',

      // require or disallow padding within blocks
      // http://eslint.org/docs/rules/padded-blocks
      // 'padded-blocks': 'error',

      // require or disallow padding lines between statements
      // http://eslint.org/docs/rules/padding-line-between-statements
      // 'padding-line-between-statements': 'error',

      // require quotes around object literal property names
      // http://eslint.org/docs/rules/quote-props
      // 'quote-props': 'error',

      // enforce the consistent use of either backticks, double, or single quotes
      // http://eslint.org/docs/rules/quotes
      // 'quotes': 'error',

      // require JSDoc comments
      // http://eslint.org/docs/rules/require-jsdoc
      // 'require-jsdoc': 'error',

      // require or disallow semicolons instead of ASI
      // http://eslint.org/docs/rules/semi
      // 'semi': 'error',

      // enforce consistent spacing before and after semicolons
      // http://eslint.org/docs/rules/semi-spacing
      // 'semi-spacing': 'error',

      // enforce location of semicolons
      // http://eslint.org/docs/rules/semi-style
      // 'semi-style': 'error',

      // require object keys to be sorted
      // http://eslint.org/docs/rules/sort-keys
      // 'sort-keys': 'error',

      // require variables within the same declaration block to be sorted
      // http://eslint.org/docs/rules/sort-vars
      // 'sort-vars': 'error',

      // enforce consistent spacing before blocks
      // http://eslint.org/docs/rules/space-before-blocks
      // 'space-before-blocks': 'error',

      // enforce consistent spacing before function definition opening parenthesis
      // http://eslint.org/docs/rules/space-before-function-paren
      // 'space-before-function-paren': 'error',

      // enforce consistent spacing inside parentheses
      // http://eslint.org/docs/rules/space-in-parens
      // 'space-in-parens': 'error',

      // require spacing around infix operators
      // http://eslint.org/docs/rules/space-infix-ops
      // 'space-infix-ops': 'error',

      // enforce consistent spacing before or after unary operators
      // http://eslint.org/docs/rules/space-unary-ops
      // 'space-unary-ops': 'error',

      // enforce consistent spacing after the // or /* in a comment
      // http://eslint.org/docs/rules/spaced-comment
      // 'spaced-comment': 'error',

      // enforce spacing around colons of switch statements
      // http://eslint.org/docs/rules/switch-colon-spacing
      // 'switch-colon-spacing': 'error',

      // require or disallow spacing between template tags and their literals
      // http://eslint.org/docs/rules/template-tag-spacing
      // 'template-tag-spacing': 'error',

      // require or disallow Unicode byte order mark (BOM)
      // http://eslint.org/docs/rules/unicode-bom
      // 'unicode-bom': 'error',

      // require parenthesis around regex literals
      // http://eslint.org/docs/rules/wrap-regex
      // 'wrap-regex': 'error',

      ////////////////////////////////////////
      // Possible Errors

      // enforce “for” loop update clause moving the counter in the right direction.
      // http://eslint.org/docs/rules/for-direction
      'for-direction': 'error',

      // disallow await inside of loops
      // http://eslint.org/docs/rules/no-await-in-loop
      'no-await-in-loop': 'error',

      // disallow comparing against -0
      // http://eslint.org/docs/rules/no-compare-neg-zero
      'no-compare-neg-zero': 'error',

      // disallow assignment operators in conditional expressions
      // http://eslint.org/docs/rules/no-cond-assign
      'no-cond-assign': [ 'error', 'always' ],

      // disallow the use of console
      // http://eslint.org/docs/rules/no-console
      'no-console': [ 'warn', { allow: [''] } ],

      // disallow constant expressions in conditions
      // http://eslint.org/docs/rules/no-constant-condition
      'no-constant-condition': [ 'error', { checkLoops: true } ],

      // disallow control characters in regular expressions
      // http://eslint.org/docs/rules/no-control-regex
      'no-control-regex': 'error',

      // disallow the use of debugger
      // http://eslint.org/docs/rules/no-debugger
      'no-debugger': 'error',

      // disallow duplicate arguments in function definitions
      // http://eslint.org/docs/rules/no-dupe-args
      'no-dupe-args': 'error',

      // disallow duplicate keys in object literals
      // http://eslint.org/docs/rules/no-dupe-keys
      'no-dupe-keys': 'error',

      // disallow duplicate case labels
      // http://eslint.org/docs/rules/no-duplicate-case
      'no-duplicate-case': 'error',

      // disallow empty block statements
      // http://eslint.org/docs/rules/no-empty
      'no-empty': [ 'error', { allowEmptyCatch: false } ],

      // disallow empty character classes in regular expressions
      // http://eslint.org/docs/rules/no-empty-character-class
      'no-empty-character-class': 'error',

      // disallow reassigning exceptions in catch clauses
      // http://eslint.org/docs/rules/no-empty-character-class
      'no-ex-assign': 'error',

      // disallow unnecessary boolean casts
      // http://eslint.org/docs/rules/no-extra-boolean-cast
      'no-extra-boolean-cast': 'error',

      // disallow unnecessary parentheses
      // http://eslint.org/docs/rules/no-extra-parens
      'no-extra-parens': [ 'error', 'all', { conditionalAssign: true,
                                             returnAssign: true,
                                             nestedBinaryExpressions: true,
                                             ignoreJSX: 'all',
                                             enforceForArrowConditionals: true }
      ],

      // disallow unnecessary semicolons
      // http://eslint.org/docs/rules/no-extra-semi
      'no-extra-semi': 'error',

      // disallow reassigning function declarations
      // http://eslint.org/docs/rules/no-func-assign
      'no-func-assign': 'error',

      // disallow variable or function declarations in nested blocks
      // http://eslint.org/docs/rules/no-inner-declarations
      'no-inner-declarations': [ 'error', 'both' ],

      // disallow invalid regular expression strings in RegExp constructors
      // http://eslint.org/docs/rules/no-invalid-regexp
      'no-invalid-regexp': [ 'error', { allowConstructorFlags: [ 'u', 'y'] } ],

      // disallow irregular whitespace outside of strings and comments
      // http://eslint.org/docs/rules/no-irregular-whitespace
      'no-irregular-whitespace': [ 'error', { skipStrings: false,
                                              skipComments: false,
                                              skipRegExps: false,
                                              skipTemplates: false }
      ],

      // disallow calling global object properties as functions
      // http://eslint.org/docs/rules/no-obj-calls
      'no-obj-calls': 'error',

      // disallow calling some Object.prototype methods directly on objects
      // http://eslint.org/docs/rules/no-prototype-builtins
      'no-prototype-builtins': 'error',

      // disallow multiple spaces in regular expressions
      // http://eslint.org/docs/rules/no-regex-spaces
      'no-regex-spaces': 'error',

      // disallow sparse arrays
      // http://eslint.org/docs/rules/no-sparse-arrays
      'no-sparse-arrays': 'error',

      // disallow template literal placeholder syntax in regular strings
      // http://eslint.org/docs/rules/no-template-curly-in-string
      'no-template-curly-in-string': 'error',

      // disallow confusing multiline expressions
      // http://eslint.org/docs/rules/no-unexpected-multiline
      'no-unexpected-multiline': 'error',

      // disallow unreachable code after return, throw, continue, and break statements
      // http://eslint.org/docs/rules/no-unreachable
      'no-unreachable': 'error',

      // disallow control flow statements in finally blocks
      // http://eslint.org/docs/rules/no-unsafe-finally
      'no-unsafe-finally': 'error',

      // disallow negating the left operand of relational operators
      // http://eslint.org/docs/rules/no-unsafe-negation
      'no-unsafe-negation': 'error',

      // require calls to isNaN() when checking for NaN
      // http://eslint.org/docs/rules/use-isnan
      'use-isnan': 'error',

      // enforce valid JSDoc comments
      // http://eslint.org/docs/rules/valid-jsdoc
      'valid-jsdoc': 'off',

      // enforce comparing typeof expressions against valid strings
      // http://eslint.org/docs/rules/valid-typeof
      'valid-typeof': [ 'error', { requireStringLiterals: true } ],

      ////////////////////////////////////////
      // Variables

      // require or disallow initialization in variable declarations
      // http://eslint.org/docs/rules/init-declarations
      'init-declarations': [ 'error', 'always' ],

      // disallow catch clause parameters from shadowing variables in the outer scope
      // http://eslint.org/docs/rules/no-catch-shadow
      'no-catch-shadow': 'error',

      // disallow deleting variables
      // http://eslint.org/docs/rules/no-delete-var
      'no-delete-var': 'error',

      // disallow labels that share a name with a variable
      // http://eslint.org/docs/rules/no-label-var
      'no-label-var': 'error',

      // disallow specified global variables
      // http://eslint.org/docs/rules/no-restricted-globals
      'no-restricted-globals': 'error',

      // disallow variable declarations from shadowing variables declared in the outer scope
      // http://eslint.org/docs/rules/no-shadow
      'no-shadow': [ 'error', { builtinGlobals: false,
                                hoist: 'all',
                                allow: [] }
      ],

      // disallow identifiers from shadowing restricted names
      // http://eslint.org/docs/rules/no-shadow-restricted-names
      'no-shadow-restricted-names': 'error',

      // disallow the use of undeclared variables unless mentioned in /*global */ comments
      // http://eslint.org/docs/rules/no-undef
      'no-undef': [ 'error', { typeof: true } ],

      // disallow initializing variables to undefined
      // http://eslint.org/docs/rules/no-undef-init
      'no-undef-init': 'error',

      // disallow the use of undefined as an identifier
      // http://eslint.org/docs/rules/no-undefined
      'no-undefined': 'error',

      // disallow unused variables
      // http://eslint.org/docs/rules/no-unused-vars
      'no-unused-vars': [ 'error', { vars: 'all',
                                     varsIgnorePattern: '',
                                     args: 'all',
                                     argsIgnorePattern: '',
                                     ignoreRestSiblings: false,
                                     caughtErrors: 'none',
                                     caughtErrorsIgnorePattern: '' }
      ],

      // disallow the use of variables before they are defined
      // http://eslint.org/docs/rules/no-use-before-define
      'no-use-before-define': [ 'error', { 'functions': true,
                                           classes: true,
                                           variables: true }
      ],

      ////////////////////////////////////////
      // ECMAScript 6

      // require braces around arrow function bodies
      // http://eslint.org/docs/rules/arrow-body-style
      'arrow-body-style': ['error', 'as-needed', { requireReturnForObjectLiteral: false } ],

      // require parentheses around arrow function arguments
      // http://eslint.org/docs/rules/arrow-parens
      'arrow-parens': [ 'error', 'as-needed', { requireForBlockBody: false } ],

      // enforce consistent spacing before and after the arrow in arrow functions
      // http://eslint.org/docs/rules/arrow-spacing
      'arrow-spacing': [ 'error', { before: true, after: true } ],

      // require super() calls in constructors
      // http://eslint.org/docs/rules/constructor-super
      'constructor-super': 'error',

      // enforce consistent spacing around * operators in generator functions
      // http://eslint.org/docs/rules/generator-star-spacing
      'generator-star-spacing': [ 'error', { before: false, after: true } ],

      // disallow reassigning class members
      // http://eslint.org/docs/rules/no-class-assign
      'no-class-assign': 'error',

      // disallow arrow functions where they could be confused with comparisons
      // http://eslint.org/docs/rules/no-confusing-arrow
      'no-confusing-arrow': [ 'error', { allowParens: true } ],

      // disallow reassigning const variables
      // http://eslint.org/docs/rules/no-const-assign
      'no-const-assign': 'error',

      // disallow duplicate class members
      // http://eslint.org/docs/rules/no-dupe-class-members
      'no-dupe-class-members': 'error',

      // disallow duplicate module imports
      // http://eslint.org/docs/rules/no-duplicate-imports
      'no-duplicate-imports': [ 'error', { includeExports: true } ],

      // disallow new operators with the Symbol object
      // http://eslint.org/docs/rules/no-new-symbol
      'no-new-symbol': 'error',

      // disallow specified modules when loaded by import
      // http://eslint.org/docs/rules/no-restricted-imports
      'no-restricted-imports': [ 'error', '' ],

      // disallow this/super before calling super() in constructors
      // http://eslint.org/docs/rules/no-this-before-super
      'no-this-before-super': 'error',

      // disallow unnecessary computed property keys in object literals
      // http://eslint.org/docs/rules/no-useless-computed-key
      'no-useless-computed-key': 'error',

      // disallow unnecessary constructors
      // http://eslint.org/docs/rules/no-useless-constructor
      'no-useless-constructor': 'error',

      // disallow renaming import, export, and destructured assignments to the same name
      // http://eslint.org/docs/rules/no-useless-rename
      'no-useless-rename': [ 'error', { ignoreDestructuring: false,
                                        ignoreImport: false,
                                        ignoreExport: false }
      ],

      // require let or const instead of var
      // http://eslint.org/docs/rules/no-var
      'no-var': 'error',

      // require or disallow method and property shorthand syntax for object literals
      // http://eslint.org/docs/rules/object-shorthand
      'object-shorthand': [ 'error', 'always', { avoidQuotes: false,
                                                 ignoreConstructors: false,
                                                 avoidExplicitReturnArrows: true }
      ],

      // require arrow functions as callbacks
      // http://eslint.org/docs/rules/prefer-arrow-callback
      'prefer-arrow-callback': [ 'error', { allowNamedFunctions: false,
                                            allowUnboundThis: true } ],

      // require const declarations for variables that are never reassigned after declared
      // http://eslint.org/docs/rules/prefer-const
      'prefer-const': [ 'error', { destructuring: 'any',
                                   ignoreReadBeforeAssign: true }
      ],

      // disallow parseInt() in favor of binary, octal, and hexadecimal literals
      // http://eslint.org/docs/rules/prefer-destructuring
      'prefer-destructuring': [ 'error', { array: true,
                                           object: true },
                                         { enforceForRenamedProperties: true } ],

      // require destructuring from arrays and/or objects
      // http://eslint.org/docs/rules/prefer-numeric-literals
      'prefer-numeric-literals': 'error',

      // require rest parameters instead of arguments
      // http://eslint.org/docs/rules/prefer-rest-params
      'prefer-rest-params': 'error',

      // require spread operators instead of .apply()
      // http://eslint.org/docs/rules/prefer-spread
      'prefer-spread': 'error',

      // require template literals instead of string concatenation
      // http://eslint.org/docs/rules/prefer-template
      'prefer-template': 'error',

      // require generator functions to contain yield
      // http://eslint.org/docs/rules/require-yield
      'require-yield': 'error',

      // enforce spacing between rest and spread operators and their expressions
      // http://eslint.org/docs/rules/rest-spread-spacing
      'rest-spread-spacing': [ 'error', 'never' ],

      // enforce sorted import declarations within modules
      // http://eslint.org/docs/rules/sort-imports
      'sort-imports': [ 'error',
        { ignoreCase: false,
          ignoreMemberSort: false,
          memberSyntaxSortOrder: [ 'none', 'all', 'multiple', 'single' ] }
        ],

      // require symbol descriptions
      // http://eslint.org/docs/rules/symbol-description
      'symbol-description': 'error',

      // require or disallow spacing around embedded expressions of template strings
      // http://eslint.org/docs/rules/template-curly-spacing
      'template-curly-spacing': [ 'error', 'always' ],

      // require or disallow spacing around the * in yield* expressions
      // http://eslint.org/docs/rules/yield-star-spacing
      'yield-star-spacing': [ 'error', { before: false, after: true } ]
    }
};
