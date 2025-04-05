package com.food.ordering.system.customer.service.messaging.publisher.kafka;

import com.food.ordering.system.customer.service.domain.config.CustomerServiceConfigData;
import com.food.ordering.system.customer.service.domain.event.CustomerCreatedEvent;
import com.food.ordering.system.customer.service.domain.ports.output.message.publisher.CustomerMessagePublisher;
import com.food.ordering.system.customer.service.messaging.mapper.CustomerMessagingDataMapper;
import com.food.ordering.system.kafka.order.avro.model.CustomerAvroModel;
import com.food.ordering.system.kafka.producer.service.KafkaProducer;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.kafka.clients.producer.RecordMetadata;
import org.springframework.stereotype.Component;

@Slf4j
@Component
@RequiredArgsConstructor
public class CustomerCreatedEventKafkaPublisher implements CustomerMessagePublisher {

    private final CustomerMessagingDataMapper customerMessagingDataMapper;
    private final KafkaProducer<String, CustomerAvroModel> kafkaProducer;
    private final CustomerServiceConfigData customerServiceConfigData;

    @Override
    public void publish(CustomerCreatedEvent customerCreatedEvent) {
        log.info("Received CustomerCreatedEvent for customer id: {}",
                customerCreatedEvent.getCustomer().getId().getValue());

        try {
            CustomerAvroModel customerAvroModel =
                    customerMessagingDataMapper.customerCreatedEventToCustomerAvroModel(customerCreatedEvent);

            kafkaProducer.send(customerServiceConfigData.getCustomerTopicName(), customerAvroModel.getId().toString(),
                            customerAvroModel)
                    .whenComplete((result, ex) -> {
                        if (ex != null) {
                            log.error("Error while sending message {} to topic {}",
                                    result.getProducerRecord().value().toString(),
                                    result.getRecordMetadata().topic(), ex);
                        } else {
                            RecordMetadata recordMetadata = result.getRecordMetadata();
                            log.info("Received new metadata. Topic: {}; Partition: {}; Offset: {}; " +
                                            "Timestamp: {}, at time: {}",
                                    recordMetadata.topic(),
                                    recordMetadata.partition(),
                                    recordMetadata.offset(),
                                    recordMetadata.timestamp(),
                                    System.nanoTime());
                        }
                    });

            log.info("CustomerCreatedEvent sent to Kafka for customer id: {}", customerAvroModel.getId());
        } catch (Exception e) {
            log.error("Error while sending CustomerCreatedEvent to Kafka for customer id: {}, error: {}",
                    customerCreatedEvent.getCustomer().getId().getValue(), e.getMessage());
        }
    }
}
