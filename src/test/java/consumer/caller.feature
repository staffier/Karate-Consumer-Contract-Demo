Feature: Use this to test responses from various Providers

  Scenario Outline: Consumer <consumerVersion> calling Provider <providerVersion>
    * call read('<scenario>') { providerVersion: <providerVersion> }

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

