package consumer;

import com.intuit.karate.junit5.Karate;

class ConsumerRunner {

    @Karate.Test
    Karate testAllConsumersWithOneFile() {
        return Karate.run("caller").relativeTo(getClass());
    }

}
