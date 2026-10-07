Feature: Creación de Mascota usando karate
  #https://petstore.swagger.io/#/pet/addPet
  Scenario Outline: Creación de Mascota mediante POST
    Given url "https://petstore.swagger.io/v2"
    And path "/pet"
    And request
    """
        {
      "id": <codigo>,
      "category": {
        "id": 0,
        "name": <categoria>
      },
      "name": <nombre>,
      "photoUrls": [
        "string"
      ],
      "tags": [
        {
          "id": 0,
          "name": "string"
        }
      ],
      "status": "available"
      }
    """
    Then method post
    And status 200
    And match $.name == "firu" 
    Examples:
      |codigo     | nombre | categoria |
      |000000123  | firu   | perros    |
      |1          | firu   | perros    |
      |561        | firu   | perros    |

  Scenario Outline: Obtener informacion de mascota por ID
    Given url "https://petstore.swagger.io/v2"
    When path "/pet/+<idPet>"
    And method get
    Then status <resulexception>
    Examples:
      | idPet     | resulexception |
      | 000000123 | 200            |
      | 1         | 200            |
      | 456       | 404            |
      | 561       | 200            |
      | 198       | 404            |

  Scenario Outline: Registro de nuevo usuario

    Given url "https://dummyjson.com"
    And header Content-Type = 'application/json'
    And path '/users/add'
    And request
    """
    {
        "firstName": "<nombre>",
        "lastName": "<apellido>",
        "age": <edad>
    }
    """
    When method post
    Then status 201

    Examples:
      | apellido | nombre | edad |
      | alva     | rafa   | 40   |
      | herrera  | jesus  | 30   |
      | lopez    | carlo  | 25   |