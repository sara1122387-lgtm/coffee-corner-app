
# Coffee Corner — Database Contract

## 1. Project Overview

Coffee Corner is a customer-facing Flutter application.
Supabase is used for authentication and cloud database storage.

The application does not include online payments or a separate admin dashboard.

Currency: IQD (Iraqi Dinar).

## 2. Database Tables

### profiles

Stores customer profile information.

| Column | Type | Description |
|---|---|---|
| id | UUID | References auth.users.id |
| display_name | TEXT | Customer name |
| phone | TEXT | Customer phone |
| created_at | TIMESTAMPTZ | Creation date |

### products

Stores available coffee shop products.

| Column | Type | Description |
|---|---|---|
| id | UUID | Product identifier |
| name | TEXT | Product name |
| description | TEXT | Product description |
| category | TEXT | Product category |
| price | INTEGER | Base price in IQD |
| image_url | TEXT | Product image URL |
| is_available | BOOLEAN | Availability |
| available_sizes | JSONB | Available sizes and price differences |
| available_add_ons | JSONB | Available add-ons and prices |
| created_at | TIMESTAMPTZ | Creation date |

### orders

Stores customer orders.

| Column | Type | Description |
|---|---|---|
| id | UUID | Order identifier |
| user_id | UUID | Customer identifier |
| total_price | INTEGER | Verified total in IQD |
| status | TEXT | Current order status |
| created_at | TIMESTAMPTZ | Order date |

Allowed statuses:

- pending
- preparing
- ready
- completed
- cancelled

### order_items

Stores products included in each order.

| Column | Type | Description |
|---|---|---|
| id | UUID | Item identifier |
| order_id | UUID | Parent order |
| product_id | UUID | Original product, nullable |
| product_name | TEXT | Product name snapshot |
| unit_price | INTEGER | Final unit price in IQD |
| quantity | INTEGER | Quantity |
| selected_size | TEXT | Selected size |
| sugar_level | TEXT | Selected sugar level |
| selected_add_ons | JSONB | Selected add-ons |
| created_at | TIMESTAMPTZ | Creation date |

## 3. Product Customization Contract

### Available sizes

Example:

```json
[
  {"name": "Small", "price_delta": 0},
  {"name": "Medium", "price_delta": 1000},
  {"name": "Large", "price_delta": 2000}
]
```

### Available add-ons

Example:

```json
[
  {"name": "Extra Shot", "price": 1000},
  {"name": "Caramel", "price": 500}
]
```

### Sugar levels

The application uses these fixed options:

- No sugar
- Low sugar
- Regular
- Extra sugar

Sugar selection does not affect price in the current version.

### Price calculation

Final unit price:

Base product price
+ selected size price difference
+ selected add-on prices

Order total:

Sum of (final unit price × quantity) for all order items.

The server must validate product availability and customization options,
and calculate prices from trusted database values.
The client must not be trusted as the source of final prices.

## 4. Cart Contract

The cart is maintained locally inside the Flutter application.

It is not stored in a separate Supabase table.

A cart item contains:

- Product ID
- Product name
- Base price
- Selected size
- Size price difference
- Sugar level
- Selected add-ons
- Final unit price
- Quantity

The cart is submitted for server-side validation when the customer confirms an order.

## 5. Order Creation

Order creation must be handled as one trusted server-side operation.

The operation must:

1. Identify the authenticated customer.
2. Validate product IDs and availability.
3. Validate selected sizes and add-ons.
4. Recalculate unit prices and order total.
5. Create the order and its items atomically.
6. Return the created order information.

A failed order creation must not leave a partial order.

## 6. Security

- Row Level Security (RLS) is enabled on all four public tables.
- Customers can read their own profiles and orders.
- Customers can read public product information.
- Customers cannot directly change order status.
- Service role keys must never be included in the Flutter application.
- Final prices must be calculated by a trusted server-side operation.

## 7. Team Ownership

### Rassel — Authentication & Profile

- Supabase Auth
- Sign up, login and logout
- Profile display and update
- Session handling

### Rabab — Products & Customization

- Product retrieval
- Product list and details
- Product customization
- Size and add-on price calculation
- Configured product data for the cart

### Sara — Cart & Orders

- Local cart management
- Quantity and total calculation
- Order confirmation
- Order history and status display
- Integration and end-to-end testing

## 8. Important Implementation Rule

All team members must use the same database column names,
JSON structures, price rules and shared data contracts.

Any proposed contract change must be discussed before implementation.
