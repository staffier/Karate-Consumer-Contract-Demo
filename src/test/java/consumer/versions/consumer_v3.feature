Feature: A demo of how versioning would work on the consumer side with each version housed in its own file

  Background:
    # Grab some universal configurations:
    * call read('classpath:helpers/config.feature')

    # Start our server:
    * def startMockServer = () => karate.start('classpath:provider/provider_v1.feature').port
    * def port = callonce startMockServer
    * url 'http://localhost:' + port


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
