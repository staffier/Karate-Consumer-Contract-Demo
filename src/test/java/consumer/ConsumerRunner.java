package consumer;

import com.intuit.karate.junit5.Karate;

class ConsumerRunner {

    @Karate.Test
    Karate testAllConsumersWithOneFile() {
        return Karate.run("all-versions").relativeTo(getClass());
    }

    @Karate.Test
    Karate testAllConsumersWithMultipleFiles() {
        return Karate.run("classpath:consumer/versions").relativeTo(getClass());
    }

}
