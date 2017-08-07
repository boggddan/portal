/* exported FormSplash */

class FormSplash {
  constructor( elem ) {
    const parentElem = elem;
    parentElem.querySelector( '.close' ).addEventListener( 'click', ( ) => this.close( ) );

    this.parentElem = parentElem;
  }

  open( type, caption, data ) {
    MyLib.pageLoader( false );
    const header = this.parentElem.querySelector( '.header' );
    const iframe = this.parentElem.querySelector( 'iframe' );

    this.parentElem.classList.remove( 'print' );
    this.parentElem.classList.remove( 'error' );

    this.parentElem.classList.add( type );
    header.firstChild.textContent = type === 'print' ? 'Друк документа:' : 'Помилка:';
    this.parentElem.querySelector( '.caption' ).textContent = caption;

    if ( type === 'error' ) iframe.srcdoc = data; else iframe.src = data;

    if ( data ) iframe.classList.remove( 'hide' ); else iframe.classList.add( 'hide' );
    this.parentElem.classList.remove( 'hide' );
  }

  close( ) {
    this.parentElem.classList.add( 'hide' );
  }
}

