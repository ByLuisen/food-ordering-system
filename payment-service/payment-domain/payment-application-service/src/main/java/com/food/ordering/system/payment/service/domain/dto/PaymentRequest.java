package com.food.ordering.system.payment.service.domain.dto;

import com.food.ordering.system.domain.valueobject.PaymentOrderStatus;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.UUID;

@Getter
@Builder
@AllArgsConstructor
public class PaymentRequest {
    private UUID id;
    private UUID sagaId;
    private UUID orderId;
    private UUID customerId;
    private BigDecimal price;
    private Instant createdAt;
    @Setter
    private PaymentOrderStatus paymentOrderStatus;

}
