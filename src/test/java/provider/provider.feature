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
          "id": "#string? _.length > 1",
          "name": {
            "firstName": "#string? _.length > 1",
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

    # Define various error responses:
    * def validateBoolean =
      """
      function(keys) {
        var req = karate.get('request');
        keys.forEach(key => {
          var val = req[key];
          var msg = null;
          if (karate.typeOf(val) != 'boolean') {
            msg = 'bad';
          }
          if (msg) {
            karate.set('responseStatus', 400);
            karate.set('response', { message: `${key} is ${msg}` });
            karate.abort();
          }
        });
      }
      """
    * def validateString =
      """
      function(keys) {
        var req = karate.get('request');
        keys.forEach(key => {
          var val = null;
          try {
            val = karate.jsonPath(req, key);
          } catch (error) {
            // path does not exist
          }
          var msg = null;
          if (karate.typeOf(val) != 'string') {
            msg = 'missing';
          } else if (val.length < 1) {
            msg = 'bad';
          }
          if (msg) {
            karate.set('responseStatus', 400);
            karate.set('response', { message: `${key} is ${msg}` });
            karate.abort();
          }
        });
      }
      """

    # Create a variable that will set a response status and body for error scenarios:
    * def abortWithResponse =
      """
        function(responseStatus, response) {
          karate.set('response', response);
          karate.set('responseStatus', responseStatus);
          karate.abort();
        }
      """

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
    * validateString(['id', 'company', 'name.firstName', 'name.lastName', 'address.street', 'address.city', 'address.state', 'address.zip'])
    * validateBoolean(['boolean'])
