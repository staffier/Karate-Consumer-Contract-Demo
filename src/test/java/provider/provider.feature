Feature: Validate incoming requests conform to a particular schema

  Background:
    # Tap into our DataGenerator (Java faker):
    * def dataGenerator = Java.type('helpers.DataGenerator')

    # Produce a random quote using our Java faker variable:
    * def randomQuote = dataGenerator.getRandomQuote()

    # Define a schema we want to use to validate incoming requests against:
    * def schema =
      """
        {
          "id": "#string? _.length == 2",
          "name": {
            "firstName": "#string",
            "lastName": "#string"
          },
          "address": {
            "street": "#string",
            "city": "#string",
            "state": "#string",
            "zip": "#string"
          },
          "company": "#string",
          "boolean": #boolean
        }
      """
    * def schemaValidator = function() { return karate.match("request contains deep schema").pass }

    # Add a random delay (200 - 600ms) to each response:
    * def responseDelay = 200 + Math.random() * 400

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

  Scenario: paramExists('key')
    * def responseStatus = 200
    * def response = "Bingo!"

  Scenario:
    # Define a generic error response along with a specific response for requests without an id:
    * def genericResponse = { "message": "Your request did not conform to the schema" }
    * def missingIdResponse = { "message": "Your request is missing an ID" }

    # Create a variable that will set a response status and body for error scenarios:
    * def abortWithResponse =
      """
        function(responseStatus, response) {
          karate.set('response', response);
          karate.set('responseStatus', responseStatus);
          karate.abort();
        }
      """

    # Send the appropriate response to the Consumer:
    * if (!request.id) abortWithResponse(400, missingIdResponse)
    * abortWithResponse(400, genericResponse)
