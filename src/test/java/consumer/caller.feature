Feature: Use this to test various Consumer:Provider combinations

  Background:
    # Grab some universal configurations:
    * call read('classpath:helpers/config.feature')

    # Pretty print our requests & responses
    * configure logPrettyRequest = true
    * configure logPrettyResponse = true

  Scenario Outline: Consumer <consumer> calling Provider <provider>
    # Start our server:
    * def server = 'classpath:provider/' + '<provider>' + '.feature'
    * def startMockServer = () => karate.start(server).port
    * def port = call startMockServer

    # Test each of our Consumer:Provider combinations
    * call read('classpath:consumer/versions/' + '<consumer>' + '.feature')

    Examples:
      | consumer    | provider    |
      | consumer_v1 | provider_v1 |
      | consumer_v1 | provider_v2 |
      | consumer_v2 | provider_v1 |
      | consumer_v2 | provider_v2 |
      | consumer_v3 | provider_v1 |
      | consumer_v3 | provider_v2 |
      | consumer_v4 | provider_v1 |
      | consumer_v4 | provider_v2 |
