Feature: A few tests to showcase dynamic request generation & schema validation

  Background:
    # Grab some universal configurations:
    * call read('classpath:helpers/config.feature')

    # Start our server:
    * def startMockServer = () => karate.start('classpath:provider/provider_v1.feature').port
    * def port = callonce startMockServer
    * url 'http://localhost:' + port

  Scenario: Generate a random request that conforms to our schema
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

    # Use the ID returned in the response above as a URI parameter to make a new request:
    * def id = $.id
    * param key = id
    * method get
    * status 200
    * match response == "Bingo!"

  Scenario: Generate a random request that has some optional fields - should still pass our schema check
    * request
      """
        {
          "randomKey": "randomValue",
          "id": "77",
          "name": {
            "firstName": "#(randomFirstName)",
            "middleName": "Mitch",
            "lastName": "#(randomLastName)"
          },
          "address": {
            "street": "#(randomStreet)",
            "city": "#(randomCity)",
            "state": "#(randomState)",
            "zip": "#(randomZip)",
            "country": "United States"
          },
          "company": "#(randomCompany)",
          "boolean": true
        }
      """
    * method post
    * status 200

  Scenario: Generate a random request that is missing a required field (id) - should result in a 400
    * request
      """
        {
          "name": {
            "firstName": "#(randomFirstName)",
            "lastName": "#(randomLastName)"
          },
          "address": {
            "street": "#(randomStreet)",
            "city": "#(randomCity)",
            "state": "#(randomState)",
            "zip": "#(randomZip)",
          },
          "company": "#(randomCompany)",
          "boolean": true
        }
      """
    * method post
    * status 400
