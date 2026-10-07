Feature: Servicio para tratamiento de productos

  Background:
    Given url "https://dummyjson.com"
    And header Content-Type = 'application/json'

  Scenario:
    When path "/products/search"
    And param q = 'phone'
    And param Limit = '2'
    And method get
    Then status 200

  Scenario:
    When path "/products/add"
    And request
  """
  {
  title: 'Lapicero'
  }
  """
    And method post
    Then status 201
    And match response.id == '#number'
    And match response.title == '#string'


  Scenario:
    When path "/products/add"
    * def nombreProd = 'Cuaderno'
    And request
  """
  {
  title: '#(nombreProd)'
  }
  """
    And method post
    Then status 201
    And match response.id == 195
    And match response.title == '#(nombreProd)'
    And print nombreProd


  Scenario: Crear un producto usando archivo externo
    When path "/products/add"
    * def productData = read('classpath:data.json')
    * def validaData = read('classpath:valida.json')
    And request productData
    Then method post
    And match response == validaData