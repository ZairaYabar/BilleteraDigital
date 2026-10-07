Feature: Billetera Digital

  Background:
    * def ip = 'http://134.209.211.10'
    * def urlCompleta1 = ip + ':' + port1
    * def urlCompleta2 = ip + ':' + port2
    * def urlCompleta3 = ip + ':' + port3
    * def urlCompleta4 = ip + ':' + port4

    * header x-channel = 'WEB'
    * header Content-Type = 'application/json'

  Scenario: Registro del emisor
    Given url urlCompleta1
    And path '/auth/v1/register'
    And request
    """
    {
      "phone": "#(emiphone)",
      "fullName": "#(emifullName)",
      "email": "#(emiemail)",
      "pin": "#(emipin)"
    }
    """
    When method post
    Then status 201


  Scenario: Registro del receptor
    Given url urlCompleta1
    And path '/auth/v1/register'
    And request
    """
    {
      "phone": "#(recpphone)",
      "fullName": "#(recpfullName)",
      "email": "#(recpemail)",
      "pin": "#(recppin)"
    }
    """
    When method post
    Then status 201