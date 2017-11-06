/* exported FormChoice */

class FormChoice {
  constructor( elem ) {
    const parentElem = elem;
    parentElem.querySelector( '.close' ).addEventListener( 'click', ( ) => this.close( ) );
    parentElem.querySelector( '.success' ).addEventListener( 'click', ( ) => this.success( ) );
    parentElem.querySelector( '.cancel' ).addEventListener( 'click', ( ) => this.cancel( ) );

    this.parentElem = parentElem;
  }

  open( type, caption, text, fnSuccess, fnCancel ) {
    MyLib.pageLoader( false );
    const header = this.parentElem.querySelector( '.header' );
    const main = this.parentElem.querySelector( '.main' );

    this.parentElem.classList.remove( 'print' );
    this.parentElem.classList.remove( 'info' );
    this.parentElem.classList.remove( 'error' );
    this.parentElem.classList.remove( 'remove' );

    this.parentElem.classList.add( type );
    header.querySelector( '.caption' ).textContent = caption;
    main.querySelector( '.text' ).textContent = text;

    let captionType = '';

    if ( type === 'error' ) {
      captionType = 'Помилка:';
    } else if ( type === 'info' ) {
      captionType = 'Інформація:';
    } else if ( type === 'print' ) {
      captionType = 'Друк документа:';
    } else if ( type === 'remove' ) {
      captionType = 'Видалити:';
    } else if ( type === 'attention' ) {
      captionType = 'Увага:';
    }

    header.firstChild.textContent = captionType;
    this.parentElem.classList.remove( 'hide' );

    this.fnSuccess = fnSuccess;
    this.fnCancel = fnCancel;
  }

  success( ) {
    if ( this.fnSuccess ) this.fnSuccess( );
    this.close( );
  }

  cancel( ) {
    if ( this.fnCancel ) this.fnCancel( );
    this.close( );
  }

  close( ) {
    this.parentElem.classList.add( 'hide' );
  }
}

