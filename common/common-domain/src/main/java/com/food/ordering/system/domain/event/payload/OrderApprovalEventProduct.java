package com.food.ordering.system.domain.event.payload;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;

import java.util.UUID;

@Getter
@Builder
@AllArgsConstructor
public class OrderApprovalEventProduct {
    @JsonProperty
    private UUID id;
    @JsonProperty
    private Integer quantity;

}
