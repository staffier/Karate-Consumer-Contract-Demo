Feature: A demo of how versioning would work on the consumer side

  Background:
    # Tap into our DataGenerator (Java faker):
    * def dataGenerator = Java.type('helpers.DataGenerator')

    # Define name components using our new 'dataGenerator' variable:
    * def randomFirstName = dataGenerator.getRandomName()[0]
    * def randomLastName = dataGenerator.getRandomName()[1]

    # Define address components:
    * def randomStreet = dataGenerator.getRandomAddress()[0] + ' ' + dataGenerator.getRandomAddress()[1]
    * def randomCity = dataGenerator.getRandomAddress()[2]
    * def randomState = dataGenerator.getRandomAddress()[3]
    * def randomZip = dataGenerator.getRandomAddress()[4]

    # ...and define a random company name just for kicks:
    * def randomCompany = dataGenerator.getRandomCompany()

    # Pretty print our JSON:
    * configure logPrettyRequest = true
    * configure logPrettyResponse = true

    # Start our server:
    * def startMockServer = () => karate.start('classpath:provider/provider.feature').port
    * def port = callonce startMockServer
    * url 'http://localhost:' + port

  Scenario: Version 1 - Required fields only
    * request
      """
        {
          "id": "11",
          "name": {
            "firstName": "#(randomFirstName)",
            "lastName": "#(randomLastName)"
          },
          "address": {
            "street": "#(randomStreet)",
            "city": "#(randomCity)",
            "state": "#(randomState)",
            "zip": "#(randomZip)"
          },
          "company": "#(randomCompany)",
          "boolean": true
        }
      """
    * method post
    * status 200
    * match response == { "id": "#uuid", "message": "#string" }

  Scenario: Version 2 - Optional fields (middleName & country) included
    * request
      """
        {
          "id": "11",
          "name": {
            "firstName": "#(randomFirstName)",
            "middleName": "Pat",
            "lastName": "#(randomLastName)"
          },
          "address": {
            "street": "#(randomStreet)",
            "city": "#(randomCity)",
            "state": "#(randomState)",
            "zip": "#(randomZip)",
            "country": "US"
          },
          "company": "#(randomCompany)",
          "boolean": true
        }
      """
    * method post
    * status 200
    * match response == { "id": "#uuid", "message": "#string" }

  Scenario: Version 3 - Missing a required field (id) - expected to fail with an id-specific error message
    * request
      """
        {
          "name": {
            "firstName": "#(randomFirstName)",
            "middleName": "Pat",
            "lastName": "#(randomLastName)"
          },
          "address": {
            "street": "#(randomStreet)",
            "city": "#(randomCity)",
            "state": "#(randomState)",
            "zip": "#(randomZip)",
            "country": "US"
          },
          "company": "#(randomCompany)",
          "boolean": true
        }
      """
    * method post
    # This will fail, since the request is missing an id field
    * status 200
    * match response == { "id": "#uuid", "message": "#string" }

#    The logs will show this is what was returned from the Provider, instead:
#    * status 400
#    * match response == { "message": "Your request is missing an ID" }

  Scenario: Version 4 - Missing a required field (firstName) - expected to fail with a generic error message
    * request
      """
        {
          "id": "11",
          "name": {
            "lastName": "#(randomLastName)"
          },
          "address": {
            "street": "#(randomStreet)",
            "city": "#(randomCity)",
            "state": "#(randomState)",
            "zip": "#(randomZip)"
          },
          "company": "#(randomCompany)",
          "boolean": true
        }
      """
    * method post
    # This will fail, since the request is missing an id field
    * status 200
    * match response == { "id": "#uuid", "message": "#string" }

#    The logs will show this is what was returned from the Provider, instead:
#    * status 400
#    * match response == { "message": "Your request did not conform to the schema" }
