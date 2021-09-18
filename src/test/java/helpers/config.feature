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

    # Pretty print our JSON:
    * configure logPrettyRequest = true
    * configure logPrettyResponse = true
