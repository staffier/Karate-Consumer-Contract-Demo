Feature: Universal configurations

  Scenario:
    # Tap into our DataGenerator (Java Faker):
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

    # Produce a random quote using our Java faker variable:
    * def randomQuote = dataGenerator.getRandomQuote()

    # Pretty print our JSON:
    * configure logPrettyRequest = true
    * configure logPrettyResponse = true

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
