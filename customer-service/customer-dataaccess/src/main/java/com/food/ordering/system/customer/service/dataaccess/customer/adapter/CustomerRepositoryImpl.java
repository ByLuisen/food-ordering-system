package com.food.ordering.system.customer.service.dataaccess.customer.adapter;

import com.food.ordering.system.customer.service.dataaccess.customer.mapper.CustomerDataaccessMapper;
import com.food.ordering.system.customer.service.dataaccess.customer.repository.CustomerJpaRepository;
import com.food.ordering.system.customer.service.domain.entity.Customer;
import com.food.ordering.system.customer.service.domain.ports.output.repository.CustomerRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
public class CustomerRepositoryImpl implements CustomerRepository {

    private final CustomerJpaRepository customerJpaRepository;
    private final CustomerDataaccessMapper customerDataaccessMapper;

    @Override
    public Customer createCustomer(Customer customer) {
        return customerDataaccessMapper
                .customerEntityToCustomer(customerJpaRepository
                        .save(customerDataaccessMapper
                                .customerToCustomerEntity(customer)));
    }
}
