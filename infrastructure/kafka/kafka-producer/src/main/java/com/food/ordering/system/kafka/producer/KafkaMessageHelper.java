package com.food.ordering.system.kafka.producer;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.food.ordering.system.order.service.domain.exception.OrderDomainException;
import com.food.ordering.system.outbox.OutboxStatus;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.kafka.clients.producer.RecordMetadata;
import org.springframework.kafka.support.SendResult;
import org.springframework.stereotype.Component;

import java.util.UUID;
import java.util.function.BiConsumer;

@Slf4j
@Component
@RequiredArgsConstructor
public class KafkaMessageHelper {

    private final ObjectMapper objectMapper;

    public <T, U> void getKafkaCallback(SendResult<String, T> result, Throwable ex,
                                        String responseTopicName, T avroModel, U outboxMessage,
                                        BiConsumer<U, OutboxStatus> outboxStatus,
                                        UUID orderId, String avroModelName) {
        if (ex != null) {
            log.error("Error while sending {} message: {} and outbox type: {} to topic {}", avroModelName,
                    avroModel.toString(), outboxMessage.getClass().getName(), responseTopicName, ex);
            outboxStatus.accept(outboxMessage, OutboxStatus.FAILED);
        } else {
            RecordMetadata recordMetadata = result.getRecordMetadata();
            log.info("Received successful response from kafka for order id: {}" +
                            " Topic: {} Partition: {} Offset: {} Timestamp: {}",
                    orderId,
                    recordMetadata.topic(),
                    recordMetadata.partition(),
                    recordMetadata.offset(),
                    recordMetadata.timestamp());
            outboxStatus.accept(outboxMessage, OutboxStatus.COMPLETED);
        }
    }

    public <T> T getOrderEventPayload(String payload, Class<T> outputType) {
        try {
            return objectMapper.readValue(payload, outputType);
        } catch (JsonProcessingException e) {
            log.error("Could not read {} object!", outputType.getName(), e);
            throw new OrderDomainException("Could not read " + outputType +  " object!", e);
        }
    }

}
