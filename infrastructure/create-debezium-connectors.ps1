#!/usr/bin/env pwsh

$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers.Add("Content-Type", "application/json")

$body = @"
{
  `"name`": `"order-payment-connector`",
  `"config`": {
    `"connector.class`": `"io.debezium.connector.postgresql.PostgresConnector`",
    `"tasks.max`": `"1`",
    `"database.hostname`": `"food-ordering-system-db`",
    `"database.port`": `"5432`",
    `"database.user`": `"postgres`",
    `"database.password`": `"admin`",
    `"database.dbname`" : `"postgres`",
    `"database.server.name`": `"PostgreSQL-15`",
    `"table.include.list`": `"order.payment_outbox`",
    `"topic.prefix`": `"debezium`",
    `"tombstones.on.delete`" : `"false`",
    `"slot.name`" : `"order_payment_outbox_slot`",
    `"plugin.name`": `"pgoutput`"
  }
}
"@

$response = Invoke-RestMethod 'http://localhost:8083/connectors' -Method 'POST' -Headers $headers -Body $body
$response | ConvertTo-Json

Start-Sleep -Seconds 2

$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers.Add("Content-Type", "application/json")

$body = @"
{
  `"name`": `"order-restaurant-connector`",
  `"config`": {
    `"connector.class`": `"io.debezium.connector.postgresql.PostgresConnector`",
    `"tasks.max`": `"1`",
    `"database.hostname`": `"food-ordering-system-db`",
    `"database.port`": `"5432`",
    `"database.user`": `"postgres`",
    `"database.password`": `"admin`",
    `"database.dbname`" : `"postgres`",
    `"database.server.name`": `"PostgreSQL-15`",
    `"table.include.list`": `"order.restaurant_approval_outbox`",
    `"topic.prefix`": `"debezium`",
    `"tombstones.on.delete`" : `"false`",
    `"slot.name`" : `"order_restaurant_approval_outbox_slot`",
    `"plugin.name`": `"pgoutput`"
  }
}
"@

Start-Sleep -Seconds 2

$response = Invoke-RestMethod 'http://localhost:8083/connectors' -Method 'POST' -Headers $headers -Body $body
$response | ConvertTo-Json

$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers.Add("Content-Type", "application/json")

$body = @"
{
  `"name`": `"payment-order-connector`",
  `"config`": {
    `"connector.class`": `"io.debezium.connector.postgresql.PostgresConnector`",
    `"tasks.max`": `"1`",
    `"database.hostname`": `"food-ordering-system-db`",
    `"database.port`": `"5432`",
    `"database.user`": `"postgres`",
    `"database.password`": `"admin`",
    `"database.dbname`" : `"postgres`",
    `"database.server.name`": `"PostgreSQL-15`",
    `"table.include.list`": `"payment.order_outbox`",
    `"topic.prefix`": `"debezium`",
    `"tombstones.on.delete`" : `"false`",
    `"slot.name`" : `"payment_order_outbox_slot`",
    `"plugin.name`": `"pgoutput`"
  }
}
"@

Start-Sleep -Seconds 2

$response = Invoke-RestMethod 'http://localhost:8083/connectors' -Method 'POST' -Headers $headers -Body $body
$response | ConvertTo-Json

$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers.Add("Content-Type", "application/json")

$body = @"
{
  `"name`": `"restaurant-order-connector`",
  `"config`": {
    `"connector.class`": `"io.debezium.connector.postgresql.PostgresConnector`",
    `"tasks.max`": `"1`",
    `"database.hostname`": `"food-ordering-system-db`",
    `"database.port`": `"5432`",
    `"database.user`": `"postgres`",
    `"database.password`": `"admin`",
    `"database.dbname`" : `"postgres`",
    `"database.server.name`": `"PostgreSQL-15`",
    `"table.include.list`": `"restaurant.order_outbox`",
    `"topic.prefix`": `"debezium`",
    `"tombstones.on.delete`" : `"false`",
    `"slot.name`" : `"restaurant_order_outbox_slot`",
    `"plugin.name`": `"pgoutput`"
  }
}
"@

$response = Invoke-RestMethod 'http://localhost:8083/connectors' -Method 'POST' -Headers $headers -Body $body
$response | ConvertTo-Json