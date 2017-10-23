/* exported FormSplash */

class FormSplash {
  constructor( elem ) {
    const parentElem = elem;
    parentElem.querySelector( '.close' ).addEventListener( 'click', ( ) => this.close( ) );

    this.parentElem = parentElem;
  }

  open( type, caption, data = '' ) {
    MyLib.pageLoader( false );
    const header = this.parentElem.querySelector( '.header' );
    const iframe = this.parentElem.querySelector( 'iframe' );

    this.parentElem.classList.remove( 'print' );
    this.parentElem.classList.remove( 'info' );
    this.parentElem.classList.remove( 'error' );

    this.parentElem.classList.add( type );
    this.parentElem.querySelector( '.caption' ).textContent = caption;

    let captionType = '';

    if ( type === 'error' ) {
      iframe.srcdoc = data;
      captionType = 'Помилка:';
    } else if ( type === 'info' ) {
      iframe.srcdoc = data;
      captionType = 'Інформація:';
    } else if ( type === 'print' ) {
      iframe.src = data;
      captionType = 'Друк документа:';
    }

    header.firstChild.textContent = captionType;
    this.parentElem.classList.remove( 'hide' );
  }

  close( ) {
    this.parentElem.classList.add( 'hide' );
  }
}

