/* exported UserNew */

class UserNew {
  constructor( elem ) {
    this.parentElem = elem;
    this.user = JSON.parse( this.parentElem.dataset.user );

    ( { user: { username: this.parentElem.querySelector( '#username' ).value } } = this );

    this.parentElem.querySelectorAll( '[name="userable_type"]' ).forEach( child => {
      child.addEventListener( 'change', event => this.changeUserableType( event ) );
    } );

    this.parentElem.querySelector( 'h1' ).textContent = `${ this.user.id ? 'Редагування' : 'Створення' } користувача`;

    MyLib.mainMenuActive( 'users' );
    const panel = this.parentElem.querySelector( `.panel[data-userable-type='${ this.user.userable_type }']` );
    const radio =  panel.querySelector( 'input' );
    radio.checked = true;
    radio.dispatchEvent( new Event( 'change' ) );

    const select = panel.querySelector( 'select' );
    if ( select ) ( { user: { userable_id: select.value } } = this );

    this.parentElem.querySelector( '.btn_save' ).addEventListener( 'click', ( ) => this.clickSave( ) );
    this.parentElem.querySelector( '.btn_exit' ).addEventListener( 'click', ( ) => this.clickExit( ) );
  }

  changeUserableType( { target: elem } ) {
    const panel = elem.closest( '.panel' );
    const { dataset: { userableType } } = panel;
    const select = panel.querySelector( 'select' );
    if ( select ) {
      if ( this.user.userable_type === userableType ) ( { user: { userable_id: select.value } } = this );
      else select.selectedIndex = 0;
      select.disabled = false;
    }

    this.parentElem.querySelectorAll( `.panel:not([data-userable-type='${ userableType }']) select` )
      .forEach( child => {
        const elemChild = child;
        elemChild.disabled = true;
      } );
  }

  // нажатие на кнопочку выход
  clickExit( ) {
    MyLib.assignLocation( this.parentElem.dataset.pathExit ); // для перехода в табличную часть
  }

  clickSave( ) {
    const { value: username } = this.parentElem.querySelector( '#username' );
    const { value: password } = this.parentElem.querySelector( '#password' );
    const { value: passwordConfirmation } = this.parentElem.querySelector( '#password_confirmation' );

    const panel = this.parentElem.querySelector( 'input:checked' ).closest( '.panel' );
    const select = panel.querySelector( 'select' );
    const { dataset: { userableType } } = panel;
    let userableId = 0;
    if ( select ) ( { value: userableId } = select );

    let headerMsg = '';
    if ( !username && !password ) headerMsg = 'Не введені ім\'я користувача та пароль';
    else if ( !username ) headerMsg = 'Не введене ім\'я користувача';
    else if ( !password ) headerMsg = 'Не введений пароль';
    else if ( password !== passwordConfirmation ) headerMsg = 'Паролі неспівпадають';

    if ( headerMsg ) MyLib.errorMsg( headerMsg );
    else {
      const caption = 'Створення користувача';
      const { parentElem: { dataset: { pathCreate: url } } } = this;
      const data = { id: this.user.id, username, userable_id: userableId, userable_type: userableType, password };
      const successAjax = ( ) => MyLib.assignLocation( this.parentElem.dataset.pathExit );
      MyLib.ajax( caption, url, 'post', data, 'json', successAjax, true );
    }
  }
}
