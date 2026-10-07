Feature: Billetera Digital

  Background:

    * header x-channel = 'WEB'
    * header Content-Type = 'application/json'

  Scenario: Registro del emisor
    Given url 'http://134.209.211.10:4001'
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
    Given url 'http://134.209.211.10:4001'
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