package com.food.ordering.system.restaurant.service.domain.dto;

import com.food.ordering.system.domain.valueobject.RestaurantOrderStatus;
import com.food.ordering.system.restaurant.service.domain.entity.Product;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.List;
import java.util.UUID;

@Getter
@Builder
@AllArgsConstructor
public class RestaurantApprovalRequest {
    private UUID id;
    private UUID sagaId;
    private UUID restaurantId;
    private UUID orderId;
    private RestaurantOrderStatus restaurantOrderStatus;
    private List<Product> products;
    private BigDecimal price;
    private Instant createdAt;
}
