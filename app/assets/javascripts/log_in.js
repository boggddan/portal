/* exported LogIn */
/* global userInfo, objFormSplash */

class LogIn {
  constructor( elem ) {
    this.parentElem = elem;
    this.constructor.checkBrowser( );

    this.parentElem.querySelector( 'button' ).addEventListener( 'click', ( ) => this.clickEnter( ) );
  }

  static checkBrowser( ) {
    const { browser: { name: browserName } } = userInfo;
    const { os: { name: osName } } = userInfo;
    const { os: { version: osVersion } } = userInfo;

    const browserMajorNeed = 59;

    if ( browserName !== 'Chrome' || +userInfo.browser.major < browserMajorNeed ) {
      const caption = 'Браузер не підтримується для роботи з порталом';
      const configUser =
        '<span style="font-weight: bold;">' +
          'Ваша поточна конфігурація:' +
        '</span><br>' +
        '<span style="padding: 15px;">операційна система: ' +
          '<span style="font-weight: bold; color: green;">' +
            `${ osName } ${ osVersion }` +
          '</span>' +
        '</span><br>' +
        '<span style="padding: 15px;">браузер: ' +
          '<span style="font-weight: bold; color: green;">' +
            `${ browserName } ${ userInfo.browser.version }` +
          '</span>' +
        '</span><br>';

      let browserMessage = '';

      if ( osName === 'Windows' && osVersion === 'XP' ) {
        browserMessage =
          '<span style="font-weight: bold;color:red;">' +
            'Необхідний браузер Mozilla вище 52 версії включно' +
          '</span><br>' +
          '<a target="_blank" href="https://download.mozilla.org/?product=firefox-stub&os=win&lang=ru&attribution_code=c291cmNlPXd3dy5nb29nbGUuY29tLnVhJm1lZGl1bT1yZWZlcnJhbCZjYW1wYWlnbj0obm90IHNldCkmY29udGVudD0obm90IHNldCkmdGltZXN0YW1wPTE1MDU0ODQxMzU.&attribution_sig=7530ceec3284406d9335f811e0ad82b230e57e87d9a7df7f4ca04d2e0a0c88f2">Завантажити останню версію Mozilla Firefox</a>';
      } else {
        browserMessage =
          '<span style="font-weight: bold;color:red;">' +
            `Необхідний браузер Google Chrome вище ${ browserMajorNeed } версії включно` +
          '</span><br>' +
          '<a target="_blank" href="https://dl.google.com/tag/s/appguid%3D%7B8A69D345-D564-463C-AFF1-A69D9E530F96%7D%26iid%3D%7BE82EAA97-52EE-DE6B-E1F8-6405F064DC9F%7D%26lang%3Dru%26browser%3D4%26usagestats%3D1%26appname%3DGoogle%2520Chrome%26needsadmin%3Dprefers%26ap%3Dx64-stable-statsdef_1%26installdataindex%3Ddefaultbrowser/update2/installers/ChromeSetup.exe">Завантажити останню версію Google Chrome</a>';
      }

      const message = `${ browserMessage }<br><br> ${ configUser }`;

      objFormSplash.open( 'error', caption, message );
    }
  }

  // нажатие на кнопочку выход
  clickEnter( ) {
    const { value: usernameVal } = this.parentElem.querySelector( '#username' );
    const password = this.parentElem.querySelector( '#password' );
    const { value: passwordVal } = password;

    if ( usernameVal && passwordVal ) {
      password.value = '';
      const caption = `Авторизація [${ usernameVal }]`;
      const data = { username: usernameVal, password: passwordVal };
      const { dataset: { pathSend: url } } = this;
      MyLib.ajax( caption, url, 'post', data, 'json', null, false );
    } else {
      let header = '';
      if ( !usernameVal && !passwordVal ) header = 'Не введені ім\'я користувача та пароль';
      else if ( !usernameVal && passwordVal ) header = 'Не введене ім\'я користувача';
      else if ( usernameVal && !passwordVal ) header = 'Не введений пароль';

      objFormSplash.open( 'error', header, '' );
    }
  }
}

