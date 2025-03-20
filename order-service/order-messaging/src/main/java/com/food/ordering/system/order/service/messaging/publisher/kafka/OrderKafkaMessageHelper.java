package com.food.ordering.system.order.service.messaging.publisher.kafka;

import lombok.extern.slf4j.Slf4j;
import org.apache.kafka.clients.producer.RecordMetadata;
import org.springframework.kafka.support.SendResult;
import org.springframework.stereotype.Component;

@Slf4j
@Component
public class OrderKafkaMessageHelper {

    public <T> void getKafkaCallback(SendResult<String, T> result, Throwable ex,
                                     String responseTopicName, T requestAvroModel, String orderId, String requestAvroModelName) {
        if (ex != null) {
            log.error("Error while sending {} message {} to topic {}", requestAvroModelName, requestAvroModel.toString(),
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
