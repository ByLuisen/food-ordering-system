package com.food.ordering.system.domain.valueobject;

import com.food.ordering.system.domain.entity.BaseEntity;

import java.util.UUID;

public class ProductId extends BaseId<UUID> {

    public ProductId(UUID value) {
        super(value);
    }
}
