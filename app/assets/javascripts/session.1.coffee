$( document ).on 'turbolinks:load', ( ) ->


  # Если объект существует
  $logIn = $( '#log_in1' )
  if $logIn.length
    $parentElem = $logIn

    ########
    $parentElem
      .find( 'button' )
        .click ->  # Нажатие на кнопочку создать
          $elem = $( @ )
          $main = $elem.closest( 'main' )
          $usernameVal = $( '#username' ).val()
          $password = $( '#password' )
          $passwordVal = $password.val()

          if $usernameVal and $passwordVal
            $password.attr( 'value', '' ).val('')

            MyLib.ajax(
              "Авторизація [#{ $usernameVal }]"
              $main.data( 'path-send' )
              'post'
              { username: $usernameVal, password: $passwordVal }
              'json'
              null
              true )
          else
            switch
              when not $usernameVal and not $passwordVal then $header = 'Не введені ім\'я користувача та пароль'
              when not $usernameVal then $header = 'Не введене ім\'я користувача'
              when not $passwordVal then $header = 'Не введений пароль'

            MyLib.errorMsg( $header )
