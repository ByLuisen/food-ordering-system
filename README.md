<h1 align="center">
  Food Ordering System
</h1>

<br>

A microservices order creation system (Customer, Order, Payment, Restaurant) designed using Hexagonal Architecture and Domain-Driven Design. Each microservice is deployed with Docker. It is built with Java using Spring MVC, with persistence via JPA on PostgreSQL. For integration and eventual consistency it uses Kafka together with the Outbox pattern and Debezium; it also applies advanced patterns (CQRS, Saga) and performance optimizations (concurrency control for customers credit entry, indexes, batch inserts, and load testing with JMeter — 7,000 users) to be resilient, scalable and reliable.

## 🔀 Create order flow

## 🔥 Features

- ✅ Resilience when publishing events thanks to the Outbox pattern and Debezium.
- ✅ Exception handling: [GlobalExceptionHandler.java](https://github.com/ByLuisen/food-ordering-system/blob/debezium-cdc/common/common-application/src/main/java/com/food/ordering/system/application/handler/GlobalExceptionHandler.java), [CustomerGlobalExceptionHandler.java](https://github.com/ByLuisen/food-ordering-system/blob/debezium-cdc/customer-service/customer-application/src/main/java/com/food/ordering/system/customer/service/application/handler/CustomerGlobalExceptionHandler.java) and [OrderGlobalExceptionHandler.java](https://github.com/ByLuisen/food-ordering-system/blob/debezium-cdc/order-service/order-application/src/main/java/com/food/ordering/system/order/service/application/exception/handler/OrderGlobalExceptionHandler.java).
- ✅ Concurrency control in customer credit entry: [CreditEntryJpaRepository.java](https://github.com/ByLuisen/food-ordering-system/blob/debezium-cdc/payment-service/payment-dataaccess/src/main/java/com/food/ordering/system/payment/service/dataaccess/creditentry/repository/CreditEntryJpaRepository.java).
- ✅ Concurrency and performance tests with JMeter for 7000 concurrent users using [food-ordering-system-load-test.jmx](https://github.com/ByLuisen/food-ordering-system/blob/debezium-cdc/test/performance/scripts/food-ordering-system-load-test.jmx)
- ✅ Batch insert configured in the database connection: [application.yml](https://github.com/ByLuisen/food-ordering-system/blob/debezium-cdc/order-service/order-container/src/main/resources/application.yml)

## 🕹️ Usage/Examples

🚨 **Important:** If you want to follow this example, you need to have the [project running](#run-locally).

1. Create a customer: 

    ```
    POST http://localhost:8184/v1/customers 
    ```

    * Resquest body: 
    ```
    {
      "customerId": "d215b5f8-0249-4dc5-89a3-51fd148cfb41",
      "username": "user_1",
      "firstName": "First",
      "lastName": "User"
    }
    ```

    * Output example:
    ```
    {
      "customerId": "d215b5f8-0249-4dc5-89a3-51fd148cfb41",
      "message": "Customer saved successfully!"
    }
    ```

2. Place an order:

    ```
    POST http://localhost:8181/v1/orders
    ```

    * Request body:
    ```
    {
      "customerId": "d215b5f8-0249-4dc5-89a3-51fd148cfb41",
      "restaurantId": "d215b5f8-0249-4dc5-89a3-51fd148cfb45",
      "address": {
        "street": "street_1",
        "postalCode": "1000AB",
        "city": "Amsterdam"
      },
      "price": 1.00,
      "items": [
        {
          "productId": "d215b5f8-0249-4dc5-89a3-51fd148cfb48",
          "quantity": 1,
          "price": 1.00,
          "subTotal": 1.00
        }
      ]
    }
    ```

    * Output example:
    ```
    {
      "orderTrackingId": "d9f1cfc9-9c30-46f7-8d2d-3fdecce5ee1e",
      "orderStatus": "PENDING",
      "message": "Order created successfully"
    }
    ```

4. Track the order status:

    ```
    GET http://localhost:8181/v1/orders/{trackingId}
    ```

    * Output example:
    ```
    {
      "orderTrackingId": "d9f1cfc9-9c30-46f7-8d2d-3fdecce5ee1e",
      "orderStatus": "APPROVED",
      "failureMessages": []
    }
    ```

## 📐 Project structure (Monorepo, Hexagonal Architecture & DDD)

```
📁 food-ordering-system/ 
 ┣ 📁 common/                                       # Reusable microservices objects 
 ┃  ┣ 📁 common-application/
 ┃  ┣ 📁 common-dataaccess/                              
 ┃  ┣ 📁 common-domain/                              
 ┃  ┣ 📁 common-messaging/                              
 ┃  ┗ 📄 pom.xml 
 ┣ 📁 customer-service/                             # Common microservices structure
 ┃  ┣ 📁 customer-application/                      # REST layer
 ┃  ┣ 📁 customer-container/                        # Submodule that runs the application by calling the other submodules
 ┃  ┣ 📁 customer-dataaccess/
 ┃  ┣ 📁 customer-domain/
 ┃  ┃  ┣ 📁 customer-application-service/                              
 ┃  ┃  ┗ 📁 customer-domain-core/  
 ┃  ┣ 📁 customer-messaging/
 ┃  ┗ 📄 pom.xml 
 ┣ 📁 infrastructure/       
 ┃  ┣ 📁 docker-compose/                            # Docker, PostgreSQL configuration
 ┃  ┣ 📁 kafka/                                     # Reusable Kafka configuration
 ┃  ┃  ┣ 📁 kafka-config-data/
 ┃  ┃  ┣ 📁 kafka-consumer/                              
 ┃  ┃  ┣ 📁 kafka-model/                              
 ┃  ┃  ┣ 📁 kafka-producer/                              
 ┃  ┃  ┗ 📄 pom.xml 
 ┃  ┣ 📁 outbox/                                    # Reusable Outbox objects
 ┃  ┣ 📁 saga/                                      # Reusable Saga objects
 ┃  ┣ 📄 create-debezium-connectors.ps1             # PowerShell script for create debezium connectors
 ┃  ┣ 📄 create-debezium-connectors.sh              # Shell script for create debezium connectors
 ┃  ┣ 📄 pom.xml              
 ┃  ┗ 📄 tag-and-push-images.sh                     # Shell script for tag and push images to GKE
 ┣ 📁 order-service/       
 ┣ 📁 payment-service/       
 ┣ 📁 restaurant-service/       
 ┣ 📁 test/   
 ┃  ┣ 📁 api/                                       # Postman collection
 ┃  ┣ 📁 json-files/                                # Debezium connectors, create customer and order
 ┃  ┣ 📁 performance/                               # JMeter concurrency and performance testing
 ┃  ┗ 📁 sql-files/                                 # Insert statements for Debezium behavior
 ┗ 📄 pom.xml
```

## 💻 Tech Stack

### Infrastructure & DevOps
  
  * Docker

### Backend & Frameworks

  * Java • Maven
  * Spring MVC • Spring Data JPA
  * PostgreSQL • CloudBeaver

### Messaging & Data Streaming

  * Apache Kafka • Kafka Connect • Debezium Change Event Envelope • Conduktor

### Testing

  * JMeter (performance testing)

### Architecture & Patterns

  * Clean Code • Hexagonal Architecture • Domain‑Driven Design (DDD)
  * RESTful • CQRS • Outbox Pattern • Saga Pattern
  * Factory • Builder • Repository

<a name="run-locally"></a>
## 🚀 Run Locally (PowerShell, macOS & Linux)

  * Prerequists:
    * [Git](https://git-scm.com/downloads)
    * [Docker Desktop](https://www.docker.com/products/docker-desktop/) (Windows & macOS) or [Docker Engine](https://docs.docker.com/engine/install/) (Linux)
    * Java 21

Clone the project, navigate to the docker-compose directory, change the branch to debezium-cdc, and start the basic and essential services (database.yml) to compile the project.

```bash
git clone https://github.com/ByLuisen/food-ordering-system.git
cd food-ordering-system/infrastructure/docker-compose
git checkout debezium-cdc
docker compose -f common.yml -f database.yml -f queue.yml up -d
```

Compile the project by installing dependencies, applying migrations, installing the artifacts, and finally building the Docker images for each microservice.

```bash
../../mvnw -f ../../pom.xml clean install
```

Create the Kafka topics with 3 partitions and 3 replicas if this is your first time or if you want to reset the Kafka topics.

```bash
docker compose -f common.yml -f init_kafka.yml up -d
```

Start the four microservices (Customer, Order, Payment, Restaurant).

```bash
docker compose -f common.yml -f app.yml up -d
```

### On macOS & Linux

Create the Debezium Kafka connectors that will publish the event to the Kafka cluster as soon as it is inserted into the database.

```bash
../create-debezium-connectors.sh
```

### On Windows (PowerShell)

Create the Debezium Kafka connectors that will publish the event to the Kafka cluster as soon as it is inserted into the database.

```powershell
Set-ExecutionPolicy ByPass -Scope Process -Force; ../create-debezium-connectors.ps1
```

### Tools Deployed with Docker

* **Cloudbeaver:** Tool to explore, manage, and query databases 
  * http://localhost:8978  
* **Conduktor:** Visual platform that simplifies the management, monitoring, and usage of Apache Kafka.
  * http://localhost:8080  
