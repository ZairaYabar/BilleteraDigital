Feature: Coleccion de usuarios

    Background:
        Given url "https://dummyjson.com"
        And header Content-Type = 'application/json'


Scenario: Registro de un usuario
    When path '/users/add'
And request
    """
        {
            "firstName": "armas",
            "lastName": "lorenzo",
            "age": 25
        }
    """
When method post
Then status 201
    And match response.lastName == 'lorenzo'



Scenario Outline: Registro de varios usuarios
    When path '/users/add'
And request
    """
        {
            "firstName": "<nombre>",
            "lastName": "<apellido>",
            "age": <edad>
        }
    """
When method post
Then status <resulexception>
Examples:
| apellido | nombre | edad | resulexception |
| alva     | rafa   | 40   |  201           |
| herrera  | jesus  | 30   |  201           |
| lopez    | carlo  | 25   |  201           |


    Scenario: Inicio de sesión
        When path '/user/login'
        And request
        """
        {
            username: 'emilys',
            password: 'emilyspass',
            expiresInMins: 60
        }
        """
        And method post
        Then status 200
        * def tokenLogin = response.accessToken
        * print tokenLogin
        When path '/user/me
        And header Authorization = 'Bearer ' + tokenLogin
        And method GET
        Then status 200