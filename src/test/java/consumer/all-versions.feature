Feature: A demo of how versioning would work on the consumer side with multiple versions tested with a single file

  Background:
    # Grab some universal configurations:
    * call read('classpath:helpers/config.feature')

    # Specify a Provider version:
    * def version = '1'

    # Start our server:
    * def provider = 'classpath:provider/provider_v' + version + '.feature'
    * def startMockServer = () => karate.start(provider).port
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
#    * match response == { "message": "id is missing" }

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
#    * match response == { "message": "name.firstName is missing" }
