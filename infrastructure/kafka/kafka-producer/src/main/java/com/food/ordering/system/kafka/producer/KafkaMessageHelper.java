package com.food.ordering.system.kafka.producer;

import lombok.extern.slf4j.Slf4j;
import org.apache.kafka.clients.producer.RecordMetadata;
import org.springframework.kafka.support.SendResult;
import org.springframework.stereotype.Component;

@Slf4j
@Component
public class KafkaMessageHelper {

    public <T> void getKafkaCallback(SendResult<String, T> result, Throwable ex,
                                     String responseTopicName, T avroModel, String orderId, String avroModelName) {
        if (ex != null) {
            log.error("Error while sending {} message {} to topic {}", avroModelName, avroModel.toString(),
                    responseTopicName, ex);
        } else {
            RecordMetadata recordMetadata = result.getRecordMetadata();
            log.info("Received successful response from kafka for order id: {}" +
                            " Topic: {} Partition: {} Offset: {} Timestamp: {}",
                    orderId,
                    recordMetadata.topic(),
                    recordMetadata.partition(),
                    recordMetadata.offset(),
                    recordMetadata.timestamp());
        }
    }

}
