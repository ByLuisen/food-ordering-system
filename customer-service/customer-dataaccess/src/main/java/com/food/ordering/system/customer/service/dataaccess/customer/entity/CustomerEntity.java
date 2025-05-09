package com.food.ordering.system.customer.service.dataaccess.customer.entity;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.*;

import java.util.UUID;

@Getter
@Setter
@Entity
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "customers")
public class CustomerEntity {

    @Id
    private UUID id;
    private String username;
    private String firstName;
    private String lastName;
}
