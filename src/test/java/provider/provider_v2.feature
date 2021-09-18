Feature: Validate incoming requests conform to a particular schema

  Background:
    # Grab some universal configurations:
    * call read('classpath:helpers/config.feature')

    # Define a schema we want to use to validate incoming requests against (middleName was added as a required field):
    * def schema =
      """
        {
          "id": "#string? _.length > 1",
          "name": {
            "firstName": "#string? _.length > 1",
            "middleName": "#string? _.length > 1",
            "lastName": "#string? _.length > 1"
          },
          "address": {
            "street": "#string? _.length > 1",
            "city": "#string? _.length > 1",
            "state": "#string? _.length > 1",
            "zip": "#string? _.length > 1"
          },
          "company": "#string? _.length > 1",
          "boolean": #boolean
        }
      """
    * def schemaValidator = function() { return karate.match("request contains deep schema").pass }

    # Add a random delay (200 - 600ms) to each response:
    * def responseDelay = 200 + Math.random() * 400

  # This scenario will be used if an incoming request conforms to the schema
  Scenario: schemaValidator()
    * def responseStatus = 200
    * def uuid = function() { return java.util.UUID.randomUUID() + '' }
    * def response =
      """
      {
        "id": "#(uuid())",
        "message": "#(randomQuote)"
      }
      """

  # This scenario will be used if an incoming request contains a 'key' parameter
  Scenario: paramExists('key')
    * def responseStatus = 200
    * def response = "Bingo!"

  # This is a catch-all scenario, which will be used if the expressions in the previous two scenarios do not resolve to 'true'
  Scenario:
#    * match request contains deep schema

    # Send the appropriate error response to the Consumer:
    * validateString(['id', 'company', 'name.firstName', 'name.middleName', 'name.lastName', 'address.street', 'address.city', 'address.state', 'address.zip'])
    * validateBoolean(['boolean'])
