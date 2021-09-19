Feature: Use this to test various Consumer:Provider combinations

  Background:
    # Grab some universal configurations:
    * call read('classpath:helpers/config.feature')

    # Pretty print our requests & responses
    * configure logPrettyRequest = true
    * configure logPrettyResponse = true

  Scenario Outline: Consumer <consumerVersion> calling Provider <providerVersion>
    # Start our server:
    * def server = 'classpath:provider/provider_' + '<providerVersion>' + '.feature'
    * def startMockServer = () => karate.start(server).port
    * def port = callonce startMockServer

    # Test each of our Consumer:Provider combinations
    * call read('<scenario>')

    Examples:
      | scenario                                        | consumerVersion | providerVersion |
      | classpath:consumer/versions/consumer_v1.feature | v1              | v1              |
      | classpath:consumer/versions/consumer_v1.feature | v1              | v2              |
      | classpath:consumer/versions/consumer_v2.feature | v2              | v1              |
      | classpath:consumer/versions/consumer_v2.feature | v2              | v2              |
      | classpath:consumer/versions/consumer_v3.feature | v3              | v1              |
      | classpath:consumer/versions/consumer_v3.feature | v3              | v2              |
      | classpath:consumer/versions/consumer_v4.feature | v4              | v1              |
      | classpath:consumer/versions/consumer_v4.feature | v4              | v2              |

