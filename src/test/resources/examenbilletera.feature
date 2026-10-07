Feature: Examen Billetera Digital

  Scenario: Registro del emisor
    Given url 'http://134.209.211.10:4001'
    * header x-channel = 'WEB'
    * header Content-Type = 'application/json'
    And path '/auth/v1/register'
    And request
    """
    {
      "phone": "941247856",
      "fullName": "emisor1",
      "email": "zairayabar000@test.com",
      "pin": "123456"
    }
    """
    When method post
    Then status 201


  Scenario: Registro del receptop
    Given url 'http://134.209.211.10:4001'
    * header x-channel = 'WEB'
    * header Content-Type = 'application/json'
    And path '/auth/v1/register'
    And request
    """
    {
      "phone": "974123659",
      "fullName": "receptor1",
      "email": "zairayabar000@test.com",
      "pin": "123456"
    }
    """
    When method post
    Then status 201

  Scenario: Emisor realiza tranferencia de pago al Receptor
    Given url 'http://134.209.211.10:4001'
    * header x-channel = 'WEB'
    * header Content-Type = 'application/json'
    And path '/auth/v1/login'
    And request
    """
    {
      "phone": "941247856",
      "pin": "123456"
    }
    """
    When method post
    Then status 200
    * def authTokenEmisor = response.token

    Given url 'http://134.209.211.10:4002'
    Given path '/wallet/v1/balance'
    * header x-channel = 'WEB'
    * header Content-Type = 'application/json'
    * header Authorization = 'Bearer ' + authTokenEmisor
    When method get
    Then status 200
    * def saldoactualEmisor = response.balance


    Given url 'http://134.209.211.10:4002'
    Given path '/wallet/v1/deposit'
    * header x-channel = 'WEB'
    * header Content-Type = 'application/json'
    * header Authorization = 'Bearer ' + authTokenEmisor
    * def recarga = 500
    And request
    """
    {
      "amount": #(recarga)
    }
    """
    When method post
    Then status 200
    * def saldototalEmisor = response.newBalance
    And match response.newBalance == saldoactualEmisor + recarga
    And print saldoactualEmisor
    And print recarga
    And print saldototalEmisor

    Given url 'http://134.209.211.10:4003'
    Given path '/transaction/v1/transfer'
    * header x-channel = 'WEB'
    * header Content-Type = 'application/json'
    * header Authorization = 'Bearer ' + authTokenEmisor
    * def pago = 450
    And request
    """
    {
      "recipientId": "u_1791392509122",
      "amount": #(pago),
      "description": "Pago Almuerzo",
      "categoryId": "cat_food_1"
    }
    """
    When method post
    Then status 200
    * def vartransactionId = response.transactionId
    * def varmensaje = response.message
    And match response.message == "Transferencia realizada con éxito"
    And print varmensaje

    Given url 'http://134.209.211.10:4001'
    * header x-channel = 'WEB'
    * header Content-Type = 'application/json'
    And path '/auth/v1/login'
    And request
    """
    {
      "phone": "974123659",
      "pin": "123456"
    }
    """
    When method post
    Then status 200
    * def authTokenReceptor = response.token

    Given url 'http://134.209.211.10:4002'
    Given path '/wallet/v1/balance'
    * header x-channel = 'WEB'
    * header Content-Type = 'application/json'
    * header Authorization = 'Bearer ' + authTokenReceptor
    When method get
    Then status 200
    * def saldoactualReceptor = response.balance
    And print saldoactualReceptor

    Given url 'http://134.209.211.10:4004'
    * header x-channel = 'WEB'
    * header Content-Type = 'application/json'
    And path '/admin/v1/login'
    And request
    """
    {
      "username": "admin",
      "password": "superpassword"
    }
    """
    When method post
    Then status 200
    * def authTokenAdmin = response.token

    Given url 'http://134.209.211.10:4004'
    Given path '/admin/v1/transactions'
    * header x-channel = 'WEB'
    * header Content-Type = 'application/json'
    * header Authorization = 'Bearer ' + authTokenAdmin
    When method get
    Then status 200

    And print response
    And print vartransactionId
    And print karate.typeOf(response)

    * def transaction = response.find(x => x.id == vartransactionId)

    And match transaction != null
    And match transaction.id == vartransactionId
    And match transaction.amount == recarga
