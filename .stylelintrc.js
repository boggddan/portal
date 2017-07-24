// StyleLint v7.13.0

module.exports = {
  plugins: [
             'stylelint-suitcss',
             'stylelint-no-browser-hacks/lib'
           ],
  extends: [ ],
  rules: {
    //======================================
    //
    //======================================

    //
    //
    // 'order/order': [
    //   [

    //   ],
    //   { disableFix: true }
    // ],

    //
    //
    // 'order/properties-order': [
    //   [
    //     "padding", "padding-top", "padding-right", "padding-bottom", "padding-left", "color"
    //   ],
    //   { disableFix: true }
    // ],

    //
    //
    // 'order/properties-alphabetical-order': [ true,   { 'disableFix': true } ],

    //======================================
    // Stylelint plugin for stylehacks linting https://github.com/Slamdunk/stylelint-no-browser-hacks
    //======================================

    // Disallow browser hacks that are irrelevant to the browsers you are targeting
    'plugin/no-browser-hacks': [ true, { browsers: [ ] } ],

    //======================================
    // Plugin stylelint-suitcss https://github.com/suitcss/stylelint-suitcss
    //======================================

    // Disallow custom properties outside of :root rules
    // https://github.com/suitcss/stylelint-suitcss/blob/master/rules/custom-property-no-outside-root/README.md
    // 'custom-property-no-outside-root': true,

    // Disallow standard properties inside :root rules
    // https://github.com/suitcss/stylelint-suitcss/blob/master/rules/root-no-standard-properties/README.md
    // 'root-no-standard-properties': true,

    // Disallow the composition of :root in selectors
    // https://github.com/suitcss/stylelint-suitcss/blob/master/rules/selector-root-no-composition/README.md
    // 'selector-root-no-composition': true,

    //======================================
    // Possible errors
    //======================================

    // Color
    //--------------------------------------

    // Disallow invalid hex colors.
    // https://stylelint.io/user-guide/rules/color-no-invalid-hex/
    'color-no-invalid-hex': true,

    // Font family
    //--------------------------------------

    // Disallow duplicate font family name
    // https://stylelint.io/user-guide/rules/font-family-no-duplicate-names/
    'font-family-no-duplicate-names': [ true, { ignoreFontFamilyNames: [] } ],

    // Function
    //--------------------------------------

    // Disallow an unspaced operator within calc function
    // https://stylelint.io/user-guide/rules/function-calc-no-unspaced-operator/
    'function-calc-no-unspaced-operator': true,

    // Disallow direction values in linear-gradient() calls that are not valid according to the standard synta
    // https://stylelint.io/user-guide/rules/function-linear-gradient-no-nonstandard-direction/
    'function-linear-gradient-no-nonstandard-direction': true,

    // String
    //--------------------------------------

    // Disallow (unescaped) newlines in string
    // https://stylelint.io/user-guide/rules/string-no-newline/
    'string-no-newline': true,

    // Unit
    //--------------------------------------

    // Disallow unknown unit
    // https://stylelint.io/user-guide/rules/unit-no-unknown/
    'unit-no-unknown': [ true, { ignoreUnits: [ ] } ],

    // Shorthand property
    //--------------------------------------

    // Disallow redundant values in shorthand propertie
    // https://stylelint.io/user-guide/rules/shorthand-property-no-redundant-values/
    'shorthand-property-no-redundant-values': true,

    // Property
    //--------------------------------------

    // Disallow unknown propertie
    // https://stylelint.io/user-guide/rules/property-no-unknown/
    'property-no-unknown': [ true, { ignoreProperties: [ ], checkPrefixed: true }
    ],

    // Keyframe declaration
    //--------------------------------------

    // Disallow !important within keyframe declaration
    // https://stylelint.io/user-guide/rules/keyframe-declaration-no-important/
    'keyframe-declaration-no-important': true,

    // Declaration block
    //--------------------------------------

    // Disallow duplicate properties within declaration block
    // https://stylelint.io/user-guide/rules/declaration-block-no-duplicate-properties/
    'declaration-block-no-duplicate-properties': [ true,
      { ignore: [ 'consecutive-duplicates-with-different-values' ],
        ignoreProperties: [ ] }
    ],

    // Disallow longhand properties that can be combined into one shorthand propert
    // https://stylelint.io/user-guide/rules/declaration-block-no-redundant-longhand-properties/
    'declaration-block-no-redundant-longhand-properties': [ true, { ignoreShorthands: [ ] } ],

    // Disallow shorthand properties that override related longhand properties
    // https://stylelint.io/user-guide/rules/declaration-block-no-shorthand-property-overrides/
    'declaration-block-no-shorthand-property-overrides': true,

    // Block
    //--------------------------------------

    // Disallow empty block
    // https://stylelint.io/user-guide/rules/block-no-empty/
    'block-no-empty': true,


    // Selector
    //--------------------------------------

    // Disallow unknown pseudo-class selector
    // https://stylelint.io/user-guide/rules/selector-pseudo-class-no-unknown/
    'selector-pseudo-class-no-unknown': [ true,  { ignorePseudoClasses: [ ] } ],

    // Disallow unknown pseudo-element selector
    // https://stylelint.io/user-guide/rules/selector-pseudo-element-no-unknown/
    'selector-pseudo-element-no-unknown': [ true, { ignorePseudoElements: [ ] } ],

    // Disallow unknown type selector
    // https://stylelint.io/user-guide/rules/selector-type-no-unknown/
    'selector-type-no-unknown': [ true, { ignore: [ ], ignoreNamespaces: [ ], ignoreTypes: [ ] } ],


    // Media feature
    //--------------------------------------

    // Disallow unknown media feature name
    // https://stylelint.io/user-guide/rules/media-feature-name-no-unknown/
    'media-feature-name-no-unknown': [ true, { ignoreMediaFeatureNames: [ ] } ],

    // At-rule
    //--------------------------------------

    // Disallow unknown at-rule
    // https://stylelint.io/user-guide/rules/at-rule-no-unknown/
    'at-rule-no-unknown': [ true, { ignoreAtRules: [ ] } ],

    // Comment
    //--------------------------------------

    // Disallow empty comment
    // https://stylelint.io/user-guide/rules/comment-no-empty/
    'comment-no-empty': true,

    // General / Sheet
    //--------------------------------------

    // Limit the depth of nestin
    // https://stylelint.io/user-guide/rules/max-nesting-depth/
    'max-nesting-depth': [ null, { ignore: [ ], ignoreAtRules: [ ] } ],

    // Disallow selectors of lower specificity from coming after overriding selectors of higher specificit
    // https://stylelint.io/user-guide/rules/no-descending-specificity/
    'no-descending-specificity': true,

    // Disallow duplicate selector
    // https://stylelint.io/user-guide/rules/no-duplicate-selectors/
    'no-duplicate-selectors': true,

    // Disallow empty source
    // https://stylelint.io/user-guide/rules/no-empty-source/
    'no-empty-source': true,

    // Disallow extra semicolon
    // https://stylelint.io/user-guide/rules/no-extra-semicolons/
    'no-extra-semicolons': true,

    // Disallow double-slash comments (//...) which are not supported by CS
    // https://stylelint.io/user-guide/rules/no-invalid-double-slash-comments/
    'no-invalid-double-slash-comments': true,

    // Disallow unknown animation
    // https://stylelint.io/user-guide/rules/no-unknown-animations/
    'no-unknown-animations': true,

    //======================================
    // Limit language features
    //======================================

    // Color
    //--------------------------------------

    // Require (where possible) or disallow named colors.
    // https://stylelint.io/user-guide/rules/color-named/
    'color-named': [ 'always-where-possible', { ignore: [ ], ignoreProperties: [ ] } ],

    // Disallow hex colors.
    // https://stylelint.io/user-guide/rules/color-no-hex/
    'color-no-hex': null,

    // Function
    //--------------------------------------

    // Specify a blacklist of disallowed function
    // https://stylelint.io/user-guide/rules/function-blacklist/
    'function-blacklist': [ null ],

    // Disallow scheme-relative url
    // https://stylelint.io/user-guide/rules/function-url-no-scheme-relative/
    'function-url-no-scheme-relative': true,

    // Specify a blacklist of disallowed url scheme
    // https://stylelint.io/user-guide/rules/function-url-scheme-blacklist/
    'function-url-scheme-blacklist': [ null ],

    // Specify a whitelist of allowed url scheme
    // https://stylelint.io/user-guide/rules/function-url-scheme-whitelist/
    'function-url-scheme-whitelist': [ null ],

    // Specify a whitelist of allowed function
    // https://stylelint.io/user-guide/rules/function-whitelist/
    'function-whitelist': [ null ],

    // Number
    //--------------------------------------

    // Limit the number of decimal places allowed in number
    // https://stylelint.io/user-guide/rules/number-max-precision/
    'number-max-precision': 3,

    // Time
    //--------------------------------------

    // Specify the minimum number of milliseconds for time value
    // https://stylelint.io/user-guide/rules/time-min-milliseconds/
    'time-min-milliseconds': 100,

    // Unit
    //--------------------------------------

    // Specify a blacklist of disallowed unit
    // https://stylelint.io/user-guide/rules/unit-blacklist/
    'unit-blacklist': [ [ null ], { ignoreProperties: { } } ],

    // Specify a whitelist of allowed unit
    // https://stylelint.io/user-guide/rules/unit-whitelist/
    'unit-whitelist': [ null, { ignoreProperties: { } } ],

    // Value
    //--------------------------------------

    // Disallow vendor prefixes for value
    // https://stylelint.io/user-guide/rules/value-no-vendor-prefix/
    'value-no-vendor-prefix': true,

    // Custom property
    //--------------------------------------

    // Specify a pattern for custom propertie
    // https://stylelint.io/user-guide/rules/custom-property-pattern/
    'custom-property-pattern': null,

    // Property
    //--------------------------------------

    // Specify a blacklist of disallowed propertie
    // https://stylelint.io/user-guide/rules/property-blacklist/
    'property-blacklist': [ null ],

    // Disallow vendor prefixes for propertie
    // https://stylelint.io/user-guide/rules/property-no-vendor-prefix/
    'property-no-vendor-prefix': true,

    // Specify a whitelist of allowed propertie
    // https://stylelint.io/user-guide/rules/property-whitelist/
    'property-whitelist': [ null ],

    // Declaration
    //--------------------------------------

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

    // Declaration block
    //--------------------------------------

    // Limit the number of declaration within single line declaration block
    // https://stylelint.io/user-guide/rules/declaration-block-single-line-max-declarations/
    'declaration-block-single-line-max-declarations': 1,

    // Selector
    //--------------------------------------

    // Specify a blacklist of disallowed attribute operator
    // https://stylelint.io/user-guide/rules/selector-attribute-operator-blacklist/
    'selector-attribute-operator-blacklist': [ null ],

    // Specify a whitelist of allowed attribute operator
    // https://stylelint.io/user-guide/rules/selector-attribute-operator-whitelist/
    'selector-attribute-operator-whitelist': [ '=', '|=', '*=', '$=', '^=' ],

    // Specify a pattern for class selector
    // https://stylelint.io/user-guide/rules/selector-class-pattern/
    'selector-class-pattern': [ null , { resolveNestedSelectors: true } ],

    // Specify a pattern for id selector
    // https://stylelint.io/user-guide/rules/selector-id-pattern/
    'selector-id-pattern':  null,

    // Limit the number of attribute selectors in a selecto
    // https://stylelint.io/user-guide/rules/selector-max-attribute/
    'selector-max-attribute': [ null, { ignoreAttributes: [ ] } ],

    // Limit the number of classes in a selecto
    // https://stylelint.io/user-guide/rules/selector-max-class/
    'selector-max-class': null,

    // Limit the number of combinators in a selecto
    // https://stylelint.io/user-guide/rules/selector-max-combinators/
    'selector-max-combinators': null,

    // Limit the number of compound selectors in a selecto
    // https://stylelint.io/user-guide/rules/selector-max-compound-selectors/
    'selector-max-compound-selectors': null,

    // Limit the number of adjacent empty lines within selector
    // https://stylelint.io/user-guide/rules/selector-max-empty-lines/
    'selector-max-empty-lines': 0,

    // Limit the number of id selectors in a selecto
    // https://stylelint.io/user-guide/rules/selector-max-id/
    'selector-max-id': null,

    // Limit the specificity of selector
    // https://stylelint.io/user-guide/rules/selector-max-specificity/
    'selector-max-specificity': null,

    // Limit the number of type in a selecto
    // https://stylelint.io/user-guide/rules/selector-max-type/
    'selector-max-type': [ null, { ignore: [ ], ignoreTypes: [ ] } ],

    // Limit the number of universal selectors in a selecto
    // https://stylelint.io/user-guide/rules/selector-max-universal/
    'selector-max-universal': null,

    // Specify a pattern for the selectors of rules nested within rule
    // https://stylelint.io/user-guide/rules/selector-nested-pattern/
    'selector-nested-pattern': null,

    // Disallow qualifying a selector by type
    // https://stylelint.io/user-guide/rules/selector-no-qualifying-type/
    'selector-no-qualifying-type': [ null, { ignore: [ 'attribute', 'class', 'id' ] } ],

    // Disallow vendor prefixes for selector
    // https://stylelint.io/user-guide/rules/selector-no-vendor-prefix/
    'selector-no-vendor-prefix': true,

    // Specify a blacklist of disallowed pseudo-class selector
    // https://stylelint.io/user-guide/rules/selector-pseudo-class-blacklist/
    'selector-pseudo-class-blacklist': [ null ],

    // Specify a whitelist of allowed pseudo-class selector
    // https://stylelint.io/user-guide/rules/selector-pseudo-class-whitelist/
    'selector-pseudo-class-whitelist': [ null ],

    // Media feature
    //--------------------------------------

    // Specify a blacklist of disallowed media feature name
    // https://stylelint.io/user-guide/rules/media-feature-name-blacklist/
    'media-feature-name-blacklist': [ null ],

    // Disallow vendor prefixes for media feature name
    // https://stylelint.io/user-guide/rules/media-feature-name-no-vendor-prefix/
    'media-feature-name-no-vendor-prefix': true,

    // Specify a whitelist of allowed media feature name
    // https://stylelint.io/user-guide/rules/media-feature-name-whitelist/
    'media-feature-name-whitelist': [ null ],

    // Custom media
    //--------------------------------------

    // Specify a pattern for custom media query name
    // https://stylelint.io/user-guide/rules/custom-media-pattern/
    'custom-media-pattern': [ null ],

    // At-rule
    //--------------------------------------

    // Specify a blacklist of disallowed at-rule
    // https://stylelint.io/user-guide/rules/at-rule-blacklist/
    'at-rule-blacklist': [ null ],

    // Disallow vendor prefixes for at-rule
    // https://stylelint.io/user-guide/rules/at-rule-no-vendor-prefix/
    'at-rule-no-vendor-prefix': true,

    // Specify a whitelist of allowed at-rule
    // https://stylelint.io/user-guide/rules/at-rule-whitelist/
    'at-rule-whitelist': [ null ],

    // Comment
    //--------------------------------------

    // Specify a blacklist of disallowed words within comment
    // https://stylelint.io/user-guide/rules/comment-word-blacklist/
    'comment-word-blacklist': [ null ],

    //======================================
    // Stylistic issues
    //======================================

    // Color
    //--------------------------------------

    // Specify lowercase or uppercase for hex colors (Autofixable).
    // https://stylelint.io/user-guide/rules/color-hex-case/
    'color-hex-case': 'lower',

    // Specify short or long notation for hex colors.
    // https://stylelint.io/user-guide/rules/color-hex-length/
    'color-hex-length': 'short',

    // Font family
    //--------------------------------------

    // Specify whether or not quotation marks should be used around font family name
    // https://stylelint.io/user-guide/rules/font-family-name-quotes/
    'font-family-name-quotes': 'always-unless-keyword',

    // Font weight
    //--------------------------------------

    // Require numeric or named (where possible) font-weight value
    // https://stylelint.io/user-guide/rules/font-weight-notation/
    'font-weight-notation': [ 'named-where-possible', { ignore: [ 'relative' ] } ],

    // Function
    //--------------------------------------

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

    // Require or disallow quotes for url
    // https://stylelint.io/user-guide/rules/function-url-quotes/
    'function-url-quotes': [ 'always', { except: [ 'empty' ] } ],

    // Require or disallow whitespace after function
    // https://stylelint.io/user-guide/rules/function-whitespace-after/
    'function-whitespace-after': 'always',

    // Number
    //--------------------------------------

    // Require or disallow a leading zero for fractional numbers less than
    // https://stylelint.io/user-guide/rules/number-leading-zero/
    'number-leading-zero': 'always',

    // Disallow trailing zeros in number
    // https://stylelint.io/user-guide/rules/number-no-trailing-zeros/
    'number-no-trailing-zeros': true,

    // String
    //--------------------------------------

    // Specify single or double quotes around string
    // https://stylelint.io/user-guide/rules/string-quotes/
    'string-quotes': 'single',

    // Length
    //--------------------------------------

    // Disallow units for zero length
    // https://stylelint.io/user-guide/rules/length-zero-no-unit/
    'length-zero-no-unit': true,

    // Unit
    //--------------------------------------

    // Specify lowercase or uppercase for unit
    // https://stylelint.io/user-guide/rules/unit-case/
    'unit-case': 'lower',

    // Value
    //--------------------------------------

    // Specify lowercase or uppercase for keywords value
    // https://stylelint.io/user-guide/rules/value-keyword-case/
    'value-keyword-case': [ 'lower', { ignoreKeywords: [ ] } ],

    // Value list
    //--------------------------------------

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

    // Custom property
    //--------------------------------------

    // Require or disallow an empty line before custom properties (Autofixable
    // https://stylelint.io/user-guide/rules/custom-property-empty-line-before/
    'custom-property-empty-line-before': [ 'always',
      { except: [ 'after-comment', 'after-custom-property', 'first-nested' ],
        ignore: [ 'after-comment', 'inside-single-line-block' ] }
    ],

    // Property
    //--------------------------------------

    // Specify lowercase or uppercase for propertie
    // https://stylelint.io/user-guide/rules/property-case/
    'property-case': 'lower',

    // Declaration
    //--------------------------------------

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

    // Declaration block
    //--------------------------------------

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

    // Require or disallow a trailing semicolon within declaration block
    // https://stylelint.io/user-guide/rules/declaration-block-trailing-semicolon/
    'declaration-block-trailing-semicolon': 'always',

    // Block
    //--------------------------------------

    // Require or disallow an empty line before the closing brace of block
    // https://stylelint.io/user-guide/rules/block-closing-brace-empty-line-before/
    'block-closing-brace-empty-line-before': 'never',

    // Require a newline or disallow whitespace after the closing brace of block
    // https://stylelint.io/user-guide/rules/block-closing-brace-newline-after/
    'block-closing-brace-newline-after': [ 'always', { ignoreAtRules: [ ] } ],

    // Require a newline or disallow whitespace before the closing brace of block
    // https://stylelint.io/user-guide/rules/block-closing-brace-newline-before/
    'block-closing-brace-newline-before': 'always-multi-line',

    // Require a single space or disallow whitespace after the closing brace of block
    // https://stylelint.io/user-guide/rules/block-closing-brace-space-after/
    'block-closing-brace-space-after': null,

    // Require a single space or disallow whitespace before the closing brace of block
    // https://stylelint.io/user-guide/rules/block-closing-brace-space-before/
    'block-closing-brace-space-before': 'always-single-line',

    // Require a newline after the opening brace of block
    // https://stylelint.io/user-guide/rules/block-opening-brace-newline-after/
    'block-opening-brace-newline-after': 'always-multi-line',

    // Require a newline or disallow whitespace before the opening brace of block
    // https://stylelint.io/user-guide/rules/block-opening-brace-newline-before/
   'block-opening-brace-newline-before': null,

    // Require a single space or disallow whitespace after the opening brace of block
    // https://stylelint.io/user-guide/rules/block-opening-brace-space-after/
    'block-opening-brace-space-after': 'always-single-line',

    // Require a single space or disallow whitespace before the opening brace of block
    // https://stylelint.io/user-guide/rules/block-opening-brace-space-before/
     'block-opening-brace-space-before': 'always',

    // Selector
    //--------------------------------------

    // Require a single space or disallow whitespace on the inside of the brackets within attribute selector
    // https://stylelint.io/user-guide/rules/selector-attribute-brackets-space-inside/
    'selector-attribute-brackets-space-inside': 'always',

    // Require a single space or disallow whitespace after operators within attribute selector
    // https://stylelint.io/user-guide/rules/selector-attribute-operator-space-after/
    'selector-attribute-operator-space-after': 'always',

    // Require a single space or disallow whitespace before operators within attribute selector
    // https://stylelint.io/user-guide/rules/selector-attribute-operator-space-before/
    'selector-attribute-operator-space-before': 'always',

    // Require or disallow quotes for attribute value
    // https://stylelint.io/user-guide/rules/selector-attribute-quotes/
    'selector-attribute-quotes': 'always',

    // Require a single space or disallow whitespace after the combinators of selector
    // https://stylelint.io/user-guide/rules/selector-combinator-space-after/
    'selector-combinator-space-after': 'always',

    // Require a single space or disallow whitespace before the combinators of selector
    // https://stylelint.io/user-guide/rules/selector-combinator-space-before/
    'selector-combinator-space-before': 'always',

    // Disallow non-space characters for descendant combinators of selector
    // https://stylelint.io/user-guide/rules/selector-descendant-combinator-no-non-space/
    'selector-descendant-combinator-no-non-space': true,

    // Specify lowercase or uppercase for pseudo-class selector
    // https://stylelint.io/user-guide/rules/selector-pseudo-class-case/
    'selector-pseudo-class-case': 'lower',

    // Require a single space or disallow whitespace on the inside of the parentheses within pseudo-class selectors
    // https://stylelint.io/user-guide/rules/selector-pseudo-class-parentheses-space-inside/
    'selector-pseudo-class-parentheses-space-inside': 'always',

    // Specify lowercase or uppercase for pseudo-element selector
    // https://stylelint.io/user-guide/rules/selector-pseudo-element-case/
    'selector-pseudo-element-case': 'lower',

    // Specify single or double colon notation for applicable pseudo-element
    // https://stylelint.io/user-guide/rules/selector-pseudo-element-colon-notation/
    'selector-pseudo-element-colon-notation': 'double',

    // Specify lowercase or uppercase for type selecto
    // https://stylelint.io/user-guide/rules/selector-type-case/
    'selector-type-case': 'lower',

    // Selector list
    //--------------------------------------

    // Require a newline or disallow whitespace after the commas of selector list
    // https://stylelint.io/user-guide/rules/selector-list-comma-newline-after/
    'selector-list-comma-newline-after': 'always',

    // Require a newline or disallow whitespace before the commas of selector list
    // https://stylelint.io/user-guide/rules/selector-list-comma-newline-before/
    'selector-list-comma-newline-before': 'never-multi-line',

    // Require a single space or disallow whitespace after the commas of selector list
    // https://stylelint.io/user-guide/rules/selector-list-comma-space-after/
    'selector-list-comma-space-after': null,

    // Require a single space or disallow whitespace before the commas of selector list
    // https://stylelint.io/user-guide/rules/selector-list-comma-space-before/
    'selector-list-comma-space-before': 'never',

    // Rule
    //--------------------------------------

    // Require or disallow an empty line before rules (Autofixable
    // https://stylelint.io/user-guide/rules/rule-empty-line-before/
    'rule-empty-line-before': [ 'always-multi-line',
      { except: [ 'after-single-line-comment', 'first-nested' ],
        ignore: [ 'after-comment', 'inside-block' ] }
    ],

    // Media feature
    //--------------------------------------

    // Require a single space or disallow whitespace after the colon in media feature
    // https://stylelint.io/user-guide/rules/media-feature-colon-space-after/
    'media-feature-colon-space-after': 'always',

    // Require a single space or disallow whitespace before the colon in media feature
    // https://stylelint.io/user-guide/rules/media-feature-colon-space-before/
    'media-feature-colon-space-before': 'never',

    // Specify lowercase or uppercase for media feature name
    // https://stylelint.io/user-guide/rules/media-feature-name-case/
    'media-feature-name-case': 'lower',

    // Require a single space or disallow whitespace on the inside of the parentheses within media feature
    // https://stylelint.io/user-guide/rules/media-feature-parentheses-space-inside/
    'media-feature-parentheses-space-inside': 'always',

    // Require a single space or disallow whitespace after the range operator in media feature
    // https://stylelint.io/user-guide/rules/media-feature-range-operator-space-after/
    'media-feature-range-operator-space-after': 'always',

    // Require a single space or disallow whitespace before the range operator in media feature
    // https://stylelint.io/user-guide/rules/media-feature-range-operator-space-before/
    'media-feature-range-operator-space-before': 'always',

    // Media query list
    //--------------------------------------

    // Require a newline or disallow whitespace after the commas of media query list
    // https://stylelint.io/user-guide/rules/media-query-list-comma-newline-after/
    'media-query-list-comma-newline-after': 'always-multi-line',

    // Require a newline or disallow whitespace before the commas of media query list
    // https://stylelint.io/user-guide/rules/media-query-list-comma-newline-before/
    'media-query-list-comma-newline-before': null,

    // Require a single space or disallow whitespace after the commas of media query list
    // https://stylelint.io/user-guide/rules/media-query-list-comma-space-after/
    'media-query-list-comma-space-after': 'always-single-line',

    // Require a single space or disallow whitespace before the commas of media query list
    // https://stylelint.io/user-guide/rules/media-query-list-comma-space-before/
    'media-query-list-comma-space-before': 'never',

    // At-rule
    //--------------------------------------

    // Require or disallow an empty line before at-rules (Autofixable
    // https://stylelint.io/user-guide/rules/at-rule-empty-line-before/
    'at-rule-empty-line-before': [ 'always',
      { except: [ 'blockless-after-same-name-blockless', 'first-nested' ],
        ignore: [ 'after-comment' ], ignoreAtRules: [ ] }
    ],

    // Specify lowercase or uppercase for at-rules names (Autofixable
    // https://stylelint.io/user-guide/rules/at-rule-name-case/
    'at-rule-name-case': 'lower',

    // Require a newline after at-rule name
    // https://stylelint.io/user-guide/rules/at-rule-name-newline-after/
    'at-rule-name-newline-after': 'always-multi-line',

    // Require a single space after at-rule name
    // https://stylelint.io/user-guide/rules/at-rule-name-space-after/
    'at-rule-name-space-after': 'always-single-line',

    // Require a newline after the semicolon of at-rule
    // https://stylelint.io/user-guide/rules/at-rule-semicolon-newline-after/
    'at-rule-semicolon-newline-after': 'always',

    // Require a single space or disallow whitespace before the semicolons of at rule
    // https://stylelint.io/user-guide/rules/at-rule-semicolon-space-before/
    'at-rule-semicolon-space-before': 'never',

    // Comment
    //--------------------------------------

    // Require or disallow an empty line before comments (Autofixable
    // https://stylelint.io/user-guide/rules/comment-empty-line-before/
    'comment-empty-line-before': [ 'always',
      { except: [ 'first-nested' ],
        ignore: [ 'after-comment', 'stylelint-commands' ] }
    ],

    // Require or disallow whitespace on the inside of comment marker
    // https://stylelint.io/user-guide/rules/comment-whitespace-inside/
    'comment-whitespace-inside': 'always',

    // General / Sheet
    //--------------------------------------

    // Specify indentation (Autofixable
    // https://stylelint.io/user-guide/rules/indentation/
    'indentation': [ 2,
      { indentInsideParens: 'once-at-root-twice-in-block',
        indentClosingBrace: false,
        except: [ ],
        ignore: [ ] }
    ],

    // Limit the number of adjacent empty line
    // https://stylelint.io/user-guide/rules/max-empty-lines/
    'max-empty-lines': [ 1, { ignore: [ 'comments' ] } ],

    // Limit the length of a lin
    // https://stylelint.io/user-guide/rules/max-line-length/
    'max-line-length': [ 50, { ignore: [ ], ignorePattern: '' } ],

    // Disallow end-of-line whitespac
    // https://stylelint.io/user-guide/rules/no-eol-whitespace/
    'no-eol-whitespace': [ true, { ignore: [ ] } ],

    // Disallow missing end-of-source newline
    // https://stylelint.io/user-guide/rules/no-missing-end-of-source-newline/
    'no-missing-end-of-source-newline': true
  }
}
