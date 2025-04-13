package com.food.ordering.system.domain.event.payload;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;

import java.time.ZonedDateTime;
import java.util.List;
import java.util.UUID;

@Getter
@Builder
@AllArgsConstructor
public class RestaurantOrderEventPayload {
    @JsonProperty
    private UUID orderId;
    @JsonProperty
    private UUID restaurantId;
    @JsonProperty
    private ZonedDateTime createdAt;
    @JsonProperty
    private String orderApprovalStatus;
    @JsonProperty
    private List<String> failureMessages;
}
