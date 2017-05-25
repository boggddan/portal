Slim::Engine.set_options shortcut: {
  '#' => {attr: 'id' },
  '.' => {attr: 'class' },
  '&' => { tag: 'input', attr: 'type' },
  '@' => { attr: 'role' },
  '^' => { attr: %w(data-role role) }
}