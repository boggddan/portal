// StyleLint v7.13.0

module.exports = {
  //"extends": "",
  "rules": {
    // Color

    // Specify lowercase or uppercase for hex colors (Autofixable).
    // https://stylelint.io/user-guide/rules/color-hex-case/
    'color-hex-case': 'lower',

    // Specify short or long notation for hex colors.
    // https://stylelint.io/user-guide/rules/color-hex-length/
    'color-hex-length': 'short',

    // Require (where possible) or disallow named colors.
    // https://stylelint.io/user-guide/rules/color-named/
    'color-named': [ 'always-where-possible', { ignore: [], ignoreProperties: [] }
    ],

    // Disallow hex colors.
    // https://stylelint.io/user-guide/rules/color-no-hex/
    'color-no-hex': null,

    // Disallow invalid hex colors.
    // https://stylelint.io/user-guide/rules/color-no-invalid-hex/
    'color-no-invalid-hex': true,

    ////////////////////////////////////////
    // Font family
    ////////////////////////////////////////

    // Specify whether or not quotation marks should be used around font family name
    // https://stylelint.io/user-guide/rules/font-family-name-quotes/
    'font-family-name-quotes': 'always-unless-keyword',

    // Disallow duplicate font family name
    // https://stylelint.io/user-guide/rules/font-family-no-duplicate-names/
    'font-family-no-duplicate-names': [ true, { ignoreFontFamilyNames: [] } ],

    ////////////////////////////////////////
    // Font weight
    ////////////////////////////////////////

    // Require numeric or named (where possible) font-weight value
    // https://stylelint.io/user-guide/rules/font-weight-notation/
    'font-weight-notation': [ 'named-where-possible', { ignore: [ 'relative' ] } ],

    ////////////////////////////////////////
    // Function
    ////////////////////////////////////////

    // Specify a blacklist of disallowed function
    // https://stylelint.io/user-guide/rules/function-blacklist/
    'function-blacklist': [],

    // Disallow an unspaced operator within calc function
    // https://stylelint.io/user-guide/rules/function-calc-no-unspaced-operator/
    'function-calc-no-unspaced-operator': true,

    // Require a newline or disallow whitespace after the commas of function
    // https://stylelint.io/user-guide/rules/function-comma-newline-after/
    'function-comma-newline-after': 'always-multi-line',

    // Require a newline or disallow whitespace before the commas of function
    // https://stylelint.io/user-guide/rules/function-comma-newline-before/
    'function-comma-newline-before': 'never-multi-line',

    // Require a single space or disallow whitespace after the commas of function
    // https://stylelint.io/user-guide/rules/function-comma-space-after/
    'function-comma-space-after': 'always-single-line',

    // Require a single space or disallow whitespace before the commas of function
    // https://stylelint.io/user-guide/rules/function-comma-space-before/
    'function-comma-space-before': 'never',

    // Disallow direction values in linear-gradient() calls that are not valid according to the standard synta
    // https://stylelint.io/user-guide/rules/function-linear-gradient-no-nonstandard-direction/
    'function-linear-gradient-no-nonstandard-direction': true,

    // Limit the number of adjacent empty lines within function
    // https://stylelint.io/user-guide/rules/function-max-empty-lines/
    'function-max-empty-lines': 0,

    // Specify lowercase or uppercase for function name
    // https://stylelint.io/user-guide/rules/function-name-case/
    'function-name-case': [ 'lower', { ignoreFunctions: [] } ],

    // Require a newline or disallow whitespace on the inside of the parentheses of function
    // https://stylelint.io/user-guide/rules/function-parentheses-newline-inside/
    'function-parentheses-newline-inside': 'always-multi-line',

    // Require a single space or disallow whitespace on the inside of the parentheses of function
    // https://stylelint.io/user-guide/rules/function-parentheses-space-inside/
    'function-parentheses-space-inside': 'always-single-line',

    // Disallow scheme-relative url
    // https://stylelint.io/user-guide/rules/function-url-no-scheme-relative/
    'function-url-no-scheme-relative': true,

    // Require or disallow quotes for url
    // https://stylelint.io/user-guide/rules/function-url-quotes/
    'function-url-quotes': [ 'always', { except: [ 'empty' ] } ],

    // Specify a blacklist of disallowed url scheme
    // https://stylelint.io/user-guide/rules/function-url-scheme-blacklist/
    'function-url-scheme-blacklist': [ ],

    // Specify a whitelist of allowed url scheme
    // https://stylelint.io/user-guide/rules/function-url-scheme-whitelist/
    'function-url-scheme-whitelist': ['/./'],

    // Specify a whitelist of allowed function
    // https://stylelint.io/user-guide/rules/function-whitelist/
    'function-whitelist': [ '/./' ],

    // Require or disallow whitespace after function
    // https://stylelint.io/user-guide/rules/function-whitespace-after/
    'function-whitespace-after': 'always',

    ////////////////////////////////////////
    // Number
    ////////////////////////////////////////

    // Require or disallow a leading zero for fractional numbers less than
    // https://stylelint.io/user-guide/rules/number-leading-zero/
    'number-leading-zero': 'always',

    // Limit the number of decimal places allowed in number
    // https://stylelint.io/user-guide/rules/number-max-precision/
    'number-max-precision': 3,

    // Disallow trailing zeros in number
    // https://stylelint.io/user-guide/rules/number-no-trailing-zeros/
    'number-no-trailing-zeros': true,

    ////////////////////////////////////////
    // String
    ////////////////////////////////////////

    // Disallow (unescaped) newlines in string
    // https://stylelint.io/user-guide/rules/string-no-newline/
    'string-no-newline': true,

    // Specify single or double quotes around string
    // https://stylelint.io/user-guide/rules/string-quotes/
    'string-quotes': 'single',

    ////////////////////////////////////////
    // Length
    ////////////////////////////////////////

    // Disallow units for zero length
    // https://stylelint.io/user-guide/rules/length-zero-no-unit/
    'length-zero-no-unit': true,

    ////////////////////////////////////////
    // Time
    ////////////////////////////////////////

    // Specify the minimum number of milliseconds for time value
    // https://stylelint.io/user-guide/rules/time-min-milliseconds/
    'time-min-milliseconds': 100,

    ////////////////////////////////////////
    // Unit
    ////////////////////////////////////////

    // Specify a blacklist of disallowed unit
    // https://stylelint.io/user-guide/rules/unit-blacklist/
    'unit-blacklist': [ [ ], { ignoreProperties: { } } ],

    // Specify lowercase or uppercase for unit
    // https://stylelint.io/user-guide/rules/unit-case/
    'unit-case': 'lower',

    // Disallow unknown unit
    // https://stylelint.io/user-guide/rules/unit-no-unknown/
    'unit-no-unknown': [ true, { ignoreUnits: [ ] } ],

    // Specify a whitelist of allowed unit
    // https://stylelint.io/user-guide/rules/unit-whitelist/
    'unit-whitelist': [ null, { ignoreProperties: { } } ],

    ////////////////////////////////////////
    // Value
    ////////////////////////////////////////

    // Specify lowercase or uppercase for keywords value
    // https://stylelint.io/user-guide/rules/value-keyword-case/
    'value-keyword-case': [ 'lower', { ignoreKeywords: [ ] } ],

    // Disallow vendor prefixes for value
    // https://stylelint.io/user-guide/rules/value-no-vendor-prefix/
    'value-no-vendor-prefix': true,

    ////////////////////////////////////////
    // Value list
    ////////////////////////////////////////

    // Require a newline or disallow whitespace after the commas of value list
    // https://stylelint.io/user-guide/rules/value-list-comma-newline-after/
    'value-list-comma-newline-after': 'always-multi-line',

    // Require a newline or disallow whitespace before the commas of value list
    // https://stylelint.io/user-guide/rules/value-list-comma-newline-before/
    'value-list-comma-newline-before': 'never-multi-line',

    // Require a single space or disallow whitespace after the commas of value list
    // https://stylelint.io/user-guide/rules/value-list-comma-space-after/
    'value-list-comma-space-after': 'always-single-line',

    // Require a single space or disallow whitespace before the commas of value list
    // https://stylelint.io/user-guide/rules/value-list-comma-space-before/
    'value-list-comma-space-before': 'never',

    // Limit the number of adjacent empty lines within value list
    // https://stylelint.io/user-guide/rules/value-list-max-empty-lines/
    'value-list-max-empty-lines': 0,

    ////////////////////////////////////////
    // Custom property
    ////////////////////////////////////////

    // Require or disallow an empty line before custom properties (Autofixable
    // https://stylelint.io/user-guide/rules/custom-property-empty-line-before/
    'custom-property-empty-line-before': [ 'always',
      { except: [ 'after-comment', 'after-custom-property', 'first-nested' ],
        ignore: [ 'after-comment', 'inside-single-line-block' ] }
    ],

    // Specify a pattern for custom propertie
    // https://stylelint.io/user-guide/rules/custom-property-pattern/
    'custom-property-pattern': '',

    ////////////////////////////////////////
    // Shorthand property
    ////////////////////////////////////////

    // Disallow redundant values in shorthand propertie
    // https://stylelint.io/user-guide/rules/shorthand-property-no-redundant-values/
    'shorthand-property-no-redundant-values': true,

    ////////////////////////////////////////
    // Property
    ////////////////////////////////////////

    // Specify a blacklist of disallowed propertie
    // https://stylelint.io/user-guide/rules/property-blacklist/
    'property-blacklist': [ ],

    // Specify lowercase or uppercase for propertie
    // https://stylelint.io/user-guide/rules/property-case/
    'property-case': 'lower',

    // Disallow unknown propertie
    // https://stylelint.io/user-guide/rules/property-no-unknown/
    'property-no-unknown': [ true,
      { ignoreProperties: [ ], checkPrefixed: true }
    ],

    // Disallow vendor prefixes for propertie
    // https://stylelint.io/user-guide/rules/property-no-vendor-prefix/
    'property-no-vendor-prefix': true,

    // Specify a whitelist of allowed propertie
    // https://stylelint.io/user-guide/rules/property-whitelist/
    'property-whitelist': [ '/./' ],

    ////////////////////////////////////////
    // Keyframe declaration
    ////////////////////////////////////////

    // Disallow !important within keyframe declaration
    // https://stylelint.io/user-guide/rules/keyframe-declaration-no-important/
    'keyframe-declaration-no-important': true,

    ////////////////////////////////////////
    // Declaration
    ////////////////////////////////////////

    // Require a single space or disallow whitespace after the bang of declaration
    // https://stylelint.io/user-guide/rules/declaration-bang-space-after/
    'declaration-bang-space-after': 'never',

    // Require a single space or disallow whitespace before the bang of declaration
    // https://stylelint.io/user-guide/rules/declaration-bang-space-before/
    'declaration-bang-space-before': 'always',

    // Require a newline or disallow whitespace after the colon of declaration
    // https://stylelint.io/user-guide/rules/declaration-colon-newline-after/
    'declaration-colon-newline-after': 'always-multi-line',

    // Require a single space or disallow whitespace after the colon of declaration
    // https://stylelint.io/user-guide/rules/declaration-colon-space-after/
    'declaration-colon-space-after': 'always-single-line',

    // Require a single space or disallow whitespace before the colon of declaration
    // https://stylelint.io/user-guide/rules/declaration-colon-space-before/
    'declaration-colon-space-before': 'never',

    // Require or disallow an empty line before declarations (Autofixable
    // https://stylelint.io/user-guide/rules/declaration-empty-line-before/
    'declaration-empty-line-before': [ 'always',
      { except: [ 'after-comment', 'after-declaration', 'first-nested' ],
        ignore: [ 'after-comment', 'after-declaration', 'inside-single-line-block' ] }
    ],

    // Disallow !important within declaration
    // https://stylelint.io/user-guide/rules/declaration-no-important/
    'declaration-no-important': true,

    // Specify a blacklist of disallowed property and unit pairs within declaration
    // https://stylelint.io/user-guide/rules/declaration-property-unit-blacklist/
    'declaration-property-unit-blacklist': { },

    // Specify a whitelist of allowed property and unit pairs within declaration
    // https://stylelint.io/user-guide/rules/declaration-property-unit-whitelist/
    'declaration-property-unit-whitelist': { },

    // Specify a blacklist of disallowed property and value pairs within declaration
    // https://stylelint.io/user-guide/rules/declaration-property-value-blacklist/
    'declaration-property-value-blacklist': { },

    // Specify a whitelist of allowed property and value pairs within declaration
    // https://stylelint.io/user-guide/rules/declaration-property-value-whitelist/
    'declaration-property-value-whitelist': { },

    ////////////////////////////////////////
    // Declaration block
    ////////////////////////////////////////

    // Disallow duplicate properties within declaration block
    // https://stylelint.io/user-guide/rules/declaration-block-no-duplicate-properties/
    'declaration-block-no-duplicate-properties': [ true,
      { ignore: [ 'consecutive-duplicates-with-different-values' ],
        ignoreProperties: [] }
    ],

    // Disallow longhand properties that can be combined into one shorthand propert
    // https://stylelint.io/user-guide/rules/declaration-block-no-redundant-longhand-properties/
    'declaration-block-no-redundant-longhand-properties':  [ true, { ignoreShorthands: [ ] } ],

    // Disallow shorthand properties that override related longhand properties
    // https://stylelint.io/user-guide/rules/declaration-block-no-shorthand-property-overrides/
    'declaration-block-no-shorthand-property-overrides': true,

    // Require a newline or disallow whitespace after the semicolons of declaration block
    // https://stylelint.io/user-guide/rules/declaration-block-semicolon-newline-after/
    'declaration-block-semicolon-newline-after': 'always-multi-line',

    // Require a newline or disallow whitespace before the semicolons of declaration block
    // https://stylelint.io/user-guide/rules/declaration-block-semicolon-newline-before/
    'declaration-block-semicolon-newline-before': 'never-multi-line',

    // Require a single space or disallow whitespace after the semicolons of declaration block
    // https://stylelint.io/user-guide/rules/declaration-block-semicolon-space-after/
    'declaration-block-semicolon-space-after': 'always-single-line',

    // Require a single space or disallow whitespace before the semicolons of declaration block
    // https://stylelint.io/user-guide/rules/declaration-block-semicolon-space-before/
    'declaration-block-semicolon-space-before': 'never',

    // Limit the number of declaration within single line declaration block
    // https://stylelint.io/user-guide/rules/declaration-block-single-line-max-declarations/
    'declaration-block-single-line-max-declarations': 1,

    // Require or disallow a trailing semicolon within declaration block
    // https://stylelint.io/user-guide/rules/declaration-block-trailing-semicolon/
    'declaration-block-trailing-semicolon': 'always',

    ////////////////////////////////////////
    // Block
    ////////////////////////////////////////

    // Require or disallow an empty line before the closing brace of block
    // https://stylelint.io/user-guide/rules/block-closing-brace-empty-line-before/
    // 'block-closing-brace-empty-line-before': null,

    // Require a newline or disallow whitespace after the closing brace of block
    // https://stylelint.io/user-guide/rules/block-closing-brace-newline-after/
    // 'block-closing-brace-newline-after': null,

    // Require a newline or disallow whitespace before the closing brace of block
    // https://stylelint.io/user-guide/rules/block-closing-brace-newline-before/
    // 'block-closing-brace-newline-before': null,

    // Require a single space or disallow whitespace after the closing brace of block
    // https://stylelint.io/user-guide/rules/block-closing-brace-space-after/
    // 'block-closing-brace-space-after': null,

    // Require a single space or disallow whitespace before the closing brace of block
    // https://stylelint.io/user-guide/rules/block-closing-brace-space-before/
    // 'block-closing-brace-space-before': null,

    // Disallow empty block
    // https://stylelint.io/user-guide/rules/block-no-empty/
    // 'block-no-empty': null,

    // Disallow single-line blocks (deprecated
    // https://stylelint.io/user-guide/rules/block-no-single-line/
    // 'block-no-single-line': null,

    // Require a newline after the opening brace of block
    // https://stylelint.io/user-guide/rules/block-opening-brace-newline-after/
    // 'block-opening-brace-newline-after': null,

    // Require a newline or disallow whitespace before the opening brace of block
    // https://stylelint.io/user-guide/rules/block-opening-brace-newline-before/
    // 'block-opening-brace-newline-before': null,

    // Require a single space or disallow whitespace after the opening brace of block
    // https://stylelint.io/user-guide/rules/block-opening-brace-space-after/
    // 'block-opening-brace-space-after': null,

    // Require a single space or disallow whitespace before the opening brace of block
    // https://stylelint.io/user-guide/rules/block-opening-brace-space-before/
    // 'block-opening-brace-space-before': null,

    ////////////////////////////////////////
    // Selector
    ////////////////////////////////////////

    // Require a single space or disallow whitespace on the inside of the brackets within attribute selector
    // https://stylelint.io/user-guide/rules/selector-attribute-brackets-space-inside/
    // 'selector-attribute-brackets-space-inside': null,

    // Specify a blacklist of disallowed attribute operator
    // https://stylelint.io/user-guide/rules/selector-attribute-operator-blacklist/
    // 'selector-attribute-operator-blacklist': null,

    // Require a single space or disallow whitespace after operators within attribute selector
    // https://stylelint.io/user-guide/rules/selector-attribute-operator-space-after/
    // 'selector-attribute-operator-space-after': null,

    // Require a single space or disallow whitespace before operators within attribute selector
    // https://stylelint.io/user-guide/rules/selector-attribute-operator-space-before/
    // 'selector-attribute-operator-space-before': null,

    // Specify a whitelist of allowed attribute operator
    // https://stylelint.io/user-guide/rules/selector-attribute-operator-whitelist/
    // 'selector-attribute-operator-whitelist': null,

    // Require or disallow quotes for attribute value
    // https://stylelint.io/user-guide/rules/selector-attribute-quotes/
    // 'selector-attribute-quotes': null,

    // Specify a pattern for class selector
    // https://stylelint.io/user-guide/rules/selector-class-pattern/
    // 'selector-class-pattern': null,

    // Require a single space or disallow whitespace after the combinators of selector
    // https://stylelint.io/user-guide/rules/selector-combinator-space-after/
    // 'selector-combinator-space-after': null,

    // Require a single space or disallow whitespace before the combinators of selector
    // https://stylelint.io/user-guide/rules/selector-combinator-space-before/
    // 'selector-combinator-space-before': null,

    // Disallow non-space characters for descendant combinators of selector
    // https://stylelint.io/user-guide/rules/selector-descendant-combinator-no-non-space/
    // 'selector-descendant-combinator-no-non-space': null,

    // Specify a pattern for id selector
    // https://stylelint.io/user-guide/rules/selector-id-pattern/
    // 'selector-id-pattern': null,

    // Limit the number of attribute selectors in a selecto
    // https://stylelint.io/user-guide/rules/selector-max-attribute/
    // 'selector-max-attribute': null,

    // Limit the number of classes in a selecto
    // https://stylelint.io/user-guide/rules/selector-max-class/
    // 'selector-max-class': null,

    // Limit the number of combinators in a selecto
    // https://stylelint.io/user-guide/rules/selector-max-combinators/
    // 'selector-max-combinators': null,

    // Limit the number of compound selectors in a selecto
    // https://stylelint.io/user-guide/rules/selector-max-compound-selectors/
    // 'selector-max-compound-selectors': null,

    // Limit the number of adjacent empty lines within selector
    // https://stylelint.io/user-guide/rules/selector-max-empty-lines/
    // 'selector-max-empty-lines': null,

    // Limit the number of id selectors in a selecto
    // https://stylelint.io/user-guide/rules/selector-max-id/
    // 'selector-max-id': null,

    // Limit the specificity of selector
    // https://stylelint.io/user-guide/rules/selector-max-specificity/
    // 'selector-max-specificity': null,

    // Limit the number of type in a selecto
    // https://stylelint.io/user-guide/rules/selector-max-type/
    // 'selector-max-type': null,

    // Limit the number of universal selectors in a selecto
    // https://stylelint.io/user-guide/rules/selector-max-universal/
    // 'selector-max-universal': null,

    // Specify a pattern for the selectors of rules nested within rule
    // https://stylelint.io/user-guide/rules/selector-nested-pattern/
    // 'selector-nested-pattern': null,

    // Disallow attribute selectors (deprecated
    // https://stylelint.io/user-guide/rules/selector-no-attribute/
    // 'selector-no-attribute': null,

    // Disallow combinators in selectors (deprecated
    // https://stylelint.io/user-guide/rules/selector-no-combinator/
    // 'selector-no-combinator': null,

    // Disallow empty selectors (deprecated
    // https://stylelint.io/user-guide/rules/selector-no-empty/
    // 'selector-no-empty': null,

    // Disallow id selectors (deprecated
    // https://stylelint.io/user-guide/rules/selector-no-id/
    // 'selector-no-id': null,

    // Disallow qualifying a selector by typ
    // https://stylelint.io/user-guide/rules/selector-no-qualifying-type/
    // 'selector-no-qualifying-type': null,

    // Disallow type selectors (deprecated
    // https://stylelint.io/user-guide/rules/selector-no-type/
    // 'selector-no-type': null,

    // Disallow the universal selector (deprecated
    // https://stylelint.io/user-guide/rules/selector-no-universal/
    // 'selector-no-universal': null,

    // Disallow vendor prefixes for selector
    // https://stylelint.io/user-guide/rules/selector-no-vendor-prefix/
    // 'selector-no-vendor-prefix': null,

    // Specify a blacklist of disallowed pseudo-class selector
    // https://stylelint.io/user-guide/rules/selector-pseudo-class-blacklist/
    // 'selector-pseudo-class-blacklist': null,

    // Specify lowercase or uppercase for pseudo-class selector
    // https://stylelint.io/user-guide/rules/selector-pseudo-class-case/
    // 'selector-pseudo-class-case': null,

    // Disallow unknown pseudo-class selector
    // https://stylelint.io/user-guide/rules/selector-pseudo-class-no-unknown/
    // 'selector-pseudo-class-no-unknown': null,

    // Specify a whitelist of allowed pseudo-class selector
    // https://stylelint.io/user-guide/rules/selector-pseudo-class-whitelist/
    // 'selector-pseudo-class-whitelist': null,

    // Specify lowercase or uppercase for pseudo-element selector
    // https://stylelint.io/user-guide/rules/selector-pseudo-element-case/
    // 'selector-pseudo-element-case': null,

    // Specify single or double colon notation for applicable pseudo-element
    // https://stylelint.io/user-guide/rules/selector-pseudo-element-colon-notation/
    // 'selector-pseudo-element-colon-notation': null,

    // Disallow unknown pseudo-element selector
    // https://stylelint.io/user-guide/rules/selector-pseudo-element-no-unknown/
    // 'selector-pseudo-element-no-unknown': null,

    // Disallow the composition of :root in selectors (deprecated
    // https://stylelint.io/user-guide/rules/selector-root-no-composition/
    // 'selector-root-no-composition': null,

    // Specify lowercase or uppercase for type selecto
    // https://stylelint.io/user-guide/rules/selector-type-case/
    // 'selector-type-case': null,

    // Disallow unknown type selector
    // https://stylelint.io/user-guide/rules/selector-type-no-unknown/
    // 'selector-type-no-unknown': null,

    ////////////////////////////////////////
    // Selector list
    ////////////////////////////////////////

    // Require a newline or disallow whitespace after the commas of selector list
    // https://stylelint.io/user-guide/rules/selector-list-comma-newline-after/
    // 'selector-list-comma-newline-after': null,

    // Require a newline or disallow whitespace before the commas of selector list
    // https://stylelint.io/user-guide/rules/selector-list-comma-newline-before/
    // 'selector-list-comma-newline-before': null,

    // Require a single space or disallow whitespace after the commas of selector list
    // https://stylelint.io/user-guide/rules/selector-list-comma-space-after/
    // 'selector-list-comma-space-after': null,

    // Require a single space or disallow whitespace before the commas of selector list
    // https://stylelint.io/user-guide/rules/selector-list-comma-space-before/
    // 'selector-list-comma-space-before': null,

    ////////////////////////////////////////
    // Root rule
    ////////////////////////////////////////

    // Disallow standard properties inside :root rules (deprecated
    // https://stylelint.io/user-guide/rules/root-no-standard-properties/
    // 'root-no-standard-properties': null,

    ////////////////////////////////////////
    // Rule
    ////////////////////////////////////////

    // Require or disallow an empty line before rules (Autofixable
    // https://stylelint.io/user-guide/rules/rule-empty-line-before/
    // 'rule-empty-line-before': null,

    // Require or disallow an empty line before nested rules (deprecated
    // https://stylelint.io/user-guide/rules/rule-nested-empty-line-before/
    // 'rule-nested-empty-line-before': null,

    // Require or disallow an empty line before non-nested rules (deprecated
    // https://stylelint.io/user-guide/rules/rule-non-nested-empty-line-before/
    // 'rule-non-nested-empty-line-before': null,

    ////////////////////////////////////////
    // Media feature
    ////////////////////////////////////////

    // Require a single space or disallow whitespace after the colon in media feature
    // https://stylelint.io/user-guide/rules/media-feature-colon-space-after/
    // 'media-feature-colon-space-after': null,

    // Require a single space or disallow whitespace before the colon in media feature
    // https://stylelint.io/user-guide/rules/media-feature-colon-space-before/
    // 'media-feature-colon-space-before': null,

    // Specify a blacklist of disallowed media feature name
    // https://stylelint.io/user-guide/rules/media-feature-name-blacklist/
    // 'media-feature-name-blacklist': null,

    // Specify lowercase or uppercase for media feature name
    // https://stylelint.io/user-guide/rules/media-feature-name-case/
    // 'media-feature-name-case': null,

    // Disallow unknown media feature name
    // https://stylelint.io/user-guide/rules/media-feature-name-no-unknown/
    // 'media-feature-name-no-unknown': null,

    // Disallow vendor prefixes for media feature name
    // https://stylelint.io/user-guide/rules/media-feature-name-no-vendor-prefix/
    // 'media-feature-name-no-vendor-prefix': null,

    // Specify a whitelist of allowed media feature name
    // https://stylelint.io/user-guide/rules/media-feature-name-whitelist/
    // 'media-feature-name-whitelist': null,

    // Disallow missing punctuation for non-boolean media features(deprecated
    // https://stylelint.io/user-guide/rules/media-feature-no-missing-punctuation/
    // 'media-feature-no-missing-punctuation': null,

    // Require a single space or disallow whitespace on the inside of the parentheses within media feature
    // https://stylelint.io/user-guide/rules/media-feature-parentheses-space-inside/
    // 'media-feature-parentheses-space-inside': null,

    // Require a single space or disallow whitespace after the range operator in media feature
    // https://stylelint.io/user-guide/rules/media-feature-range-operator-space-after/
    // 'media-feature-range-operator-space-after': null,

    // Require a single space or disallow whitespace before the range operator in media feature
    // https://stylelint.io/user-guide/rules/media-feature-range-operator-space-before/
    // 'media-feature-range-operator-space-before': null,

    ////////////////////////////////////////
    // Custom media
    ////////////////////////////////////////

    // Specify a pattern for custom media query name
    // https://stylelint.io/user-guide/rules/custom-media-pattern/
    // 'custom-media-pattern': null,

    ////////////////////////////////////////
    // Media query list
    ////////////////////////////////////////

    // Require a newline or disallow whitespace after the commas of media query list
    // https://stylelint.io/user-guide/rules/media-query-list-comma-newline-after/
    // 'media-query-list-comma-newline-after': null,

    // Require a newline or disallow whitespace before the commas of media query list
    // https://stylelint.io/user-guide/rules/media-query-list-comma-newline-before/
    // 'media-query-list-comma-newline-before': null,

    // Require a single space or disallow whitespace after the commas of media query list
    // https://stylelint.io/user-guide/rules/media-query-list-comma-space-after/
    // 'media-query-list-comma-space-after': null,

    // Require a single space or disallow whitespace before the commas of media query list
    // https://stylelint.io/user-guide/rules/media-query-list-comma-space-before/
    // 'media-query-list-comma-space-before': null,

    ////////////////////////////////////////
    // At-rule
    ////////////////////////////////////////

    // Specify a blacklist of disallowed at-rule
    // https://stylelint.io/user-guide/rules/at-rule-blacklist/
    // 'at-rule-blacklist': null,

    // Require or disallow an empty line before at-rules (Autofixable
    // https://stylelint.io/user-guide/rules/at-rule-empty-line-before/
    // 'at-rule-empty-line-before': null,

    // Specify lowercase or uppercase for at-rules names (Autofixable
    // https://stylelint.io/user-guide/rules/at-rule-name-case/
    // 'at-rule-name-case': null,

    // Require a newline after at-rule name
    // https://stylelint.io/user-guide/rules/at-rule-name-newline-after/
    // 'at-rule-name-newline-after': null,

    // Require a single space after at-rule name
    // https://stylelint.io/user-guide/rules/at-rule-name-space-after/
    // 'at-rule-name-space-after': null,

    // Disallow unknown at-rule
    // https://stylelint.io/user-guide/rules/at-rule-no-unknown/
    // 'at-rule-no-unknown': null,

    // Disallow vendor prefixes for at-rule
    // https://stylelint.io/user-guide/rules/at-rule-no-vendor-prefix/
    // 'at-rule-no-vendor-prefix': null,

    // Require a newline after the semicolon of at-rule
    // https://stylelint.io/user-guide/rules/at-rule-semicolon-newline-after/
    // 'at-rule-semicolon-newline-after': null,

    // Require a single space or disallow whitespace before the semicolons of at rule
    // https://stylelint.io/user-guide/rules/at-rule-semicolon-space-before/
    // 'at-rule-semicolon-space-before': null,

    // Specify a whitelist of allowed at-rule
    // https://stylelint.io/user-guide/rules/at-rule-whitelist/
    // 'at-rule-whitelist': null,

    ////////////////////////////////////////
    // stylelint-disable comment
    ////////////////////////////////////////

    // Require a reason comment before or after stylelint-disable comments(deprecated
    // https://stylelint.io/user-guide/rules/stylelint-disable-reason/
    // 'stylelint-disable-reason': null,

    ////////////////////////////////////////
    // Comment
    ////////////////////////////////////////

    // Require or disallow an empty line before comments (Autofixable
    // https://stylelint.io/user-guide/rules/comment-empty-line-before/
    // 'comment-empty-line-before': null,

    // Disallow empty comment
    // https://stylelint.io/user-guide/rules/comment-no-empty/
    // 'comment-no-empty': null,

    // Require or disallow whitespace on the inside of comment marker
    // https://stylelint.io/user-guide/rules/comment-whitespace-inside/
    // 'comment-whitespace-inside': null,

    // Specify a blacklist of disallowed words within comment
    // https://stylelint.io/user-guide/rules/comment-word-blacklist/
    // 'comment-word-blacklist': null,

    ////////////////////////////////////////
    // General / Sheet
    ////////////////////////////////////////

    // Specify indentation (Autofixable
    // https://stylelint.io/user-guide/rules/indentation/
    // 'indentation': null,

    // Limit the number of adjacent empty line
    // https://stylelint.io/user-guide/rules/max-empty-lines/
    // 'max-empty-lines': null,

    // Limit the length of a lin
    // https://stylelint.io/user-guide/rules/max-line-length/
    // 'max-line-length': null,

    // Limit the depth of nestin
    // https://stylelint.io/user-guide/rules/max-nesting-depth/
    // 'max-nesting-depth': null,

    // Disallow browser hacks that are irrelevant to the browsers you are targeting (deprecated
    // https://stylelint.io/user-guide/rules/no-browser-hacks/
    // 'no-browser-hacks': null,

    // Disallow selectors of lower specificity from coming after overriding selectors of higher specificit
    // https://stylelint.io/user-guide/rules/no-descending-specificity/
    // 'no-descending-specificity': null,

    // Disallow duplicate selector
    // https://stylelint.io/user-guide/rules/no-duplicate-selectors/
    // 'no-duplicate-selectors': null,

    // Disallow empty source
    // https://stylelint.io/user-guide/rules/no-empty-source/
    // 'no-empty-source': null,

    // Disallow end-of-line whitespac
    // https://stylelint.io/user-guide/rules/no-eol-whitespace/
    // 'no-eol-whitespace': null,

    // Disallow extra semicolon
    // https://stylelint.io/user-guide/rules/no-extra-semicolons/
    // 'no-extra-semicolons': null,

    // Disallow colors that are suspiciously close to being identical (deprecated
    // https://stylelint.io/user-guide/rules/no-indistinguishable-colors/
    // 'no-indistinguishable-colors': null,

    // Disallow double-slash comments (//...) which are not supported by CS
    // https://stylelint.io/user-guide/rules/no-invalid-double-slash-comments/
    // 'no-invalid-double-slash-comments': null,

    // Disallow missing end-of-source newline
    // https://stylelint.io/user-guide/rules/no-missing-end-of-source-newline/
    // 'no-missing-end-of-source-newline': null,

    // Disallow unknown animation
    // https://stylelint.io/user-guide/rules/no-unknown-animations/
    // 'no-unknown-animations': null,

    // Disallow features that are unsupported by the browsers that you are targeting (deprecated, use the stylelint-no-unsupported-browser-features plugin instead
    //
    // 'no-unsupported-browser-features': null


  },
}
