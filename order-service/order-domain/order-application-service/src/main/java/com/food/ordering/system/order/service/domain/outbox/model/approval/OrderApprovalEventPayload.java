package com.food.ordering.system.order.service.domain.outbox.model.approval;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.food.ordering.system.domain.valueobject.RestaurantOrderStatus;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;

import java.math.BigDecimal;
import java.time.ZonedDateTime;
import java.util.List;
import java.util.UUID;

@Getter
@Builder
@AllArgsConstructor
public class OrderApprovalEventPayload {
    @JsonProperty
    private UUID orderId;
    @JsonProperty
    private UUID restaurantId;
    @JsonProperty
    private BigDecimal price;
    @JsonProperty
    private ZonedDateTime createdAt;
    @JsonProperty
    private String restaurantOrderStatus;
    @JsonProperty
    private List<OrderApprovalEventProduct> products;
}
