Feature: A demo of how versioning would work on the consumer side with each version housed in its own file

  Background:
    # Grab some universal configurations:
    * call read('classpath:helpers/config.feature')

    # Start our server (providerVersion is provided by caller.feature):
    * def version = '#(providerVersion)'
    * def server = 'classpath:provider/provider_' + providerVersion + '.feature'
    * def startMockServer = () => karate.start(server).port
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
