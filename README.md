# Vehicle Rental System - Database Design & SQL Queries

## Project Overview

This project implements a **Vehicle Rental System** database using **PostgreSQL**. It focuses on **database design, relationships, constraints, and practical SQL queries** commonly used in a real-world rental system.

The system manages:

- **Users**: Admins and Customers
- **Vehicles**: Cars, Bikes, and Trucks with availability status
- **Bookings**: Rental records with dates, status, and cost

This project demonstrates:

- Proper use of **Primary Keys** and **Foreign Keys**
- Enforcing data validity using **CHECK constraints**
- Writing meaningful SQL queries using **JOIN, EXISTS, WHERE, GROUP BY, and HAVING**

---

## Tech Stack

- **Database:** PostgreSQL
- **SQL Dialect:** PostgreSQL (psql-compatible)
- **ERD:** drawSQL
- **Client tools:** Beekeeper Studio, psql, or any PostgreSQL-compatible client


## Database Schema

### Users Table

```sql
CREATE TABLE users (
  user_id SERIAL PRIMARY KEY,
  name VARCHAR(150),
  email VARCHAR(100) UNIQUE NOT NULL,
  phone VARCHAR(20),
  role VARCHAR(20) CHECK (role IN ('Admin', 'Customer'))
);
```

- **Purpose:** Stores system users (admins and customers)
- **Notes:** Email uniqueness and role validation using CHECK constraint.

### Vehicles Table

```sql
CREATE TABLE vehicles (
  vehicle_id SERIAL PRIMARY KEY,
  name VARCHAR(150),
  type VARCHAR(20) CHECK (type IN ('car', 'bike', 'truck')),
  model INT,
  registration_number VARCHAR(50) UNIQUE,
  rental_price INT,
  status VARCHAR(20) CHECK (status IN ('available', 'rented', 'maintenance'))
);
```

- **Purpose:** Stores vehicle details and availability status
- **Notes:** Controlled vehicle types and status values.

### Bookings Table

```sql
CREATE TABLE bookings (
  booking_id SERIAL PRIMARY KEY,
  user_id INT REFERENCES users(user_id),
  vehicle_id INT REFERENCES vehicles(vehicle_id),
  start_date DATE NOT NULL,
  end_date DATE NOT NULL CHECK (end_date > start_date),
  status VARCHAR(20) NOT NULL CHECK (
    status IN ('pending', 'confirmed', 'completed', 'cancelled')
  ),
  total_cost INT
);
```

- **Purpose:** Tracks vehicle rentals by users
- **Notes:** Date validation, booking status control, and relational integrity.

### Entity Relationship Diagram (ERD)

Relationships:

- One User can have many Bookings
- One Vehicle can have many Bookings
- Each Booking is linked to exactly one User and one Vehicle

ERD includes:

- Primary Keys (PK)
- Foreign Keys (FK)
- Relationship cardinality

ERD Link:

[Vehicle Rental System ERD](https://drawsql.app/teams/abu-bakkar-siddique/diagrams/vehicle-rental-system-database-design-sql-queries-a3)

---

## SQL Queries (queries.sql)

Below are the core SQL queries implemented in this project.

### Query 1: JOIN — Retrieve booking details with customer and vehicle names

```sql
SELECT
    bookings.booking_id,
    users.name AS customer_name,
    vehicles.name AS vehicle_name,
    bookings.start_date,
    bookings.end_date,
    bookings.status
FROM
    bookings
    INNER JOIN users ON bookings.user_id = users.user_id
    INNER JOIN vehicles ON bookings.vehicle_id = vehicles.vehicle_id;
```

Concepts Used: INNER JOIN

Purpose: Combines booking, user, and vehicle data into a single result.

### Query 2: EXISTS — Find all vehicles that have never been booked

```sql
SELECT
    vehicles.vehicle_id,
    vehicles.name,
    vehicles.type,
    vehicles.model,
    vehicles.registration_number,
    vehicles.rental_price,
    vehicles.status
FROM
    vehicles
WHERE
    NOT EXISTS (
        SELECT
            1
        FROM
            bookings
        WHERE
            bookings.vehicle_id = vehicles.vehicle_id
    );
```

Concepts Used: NOT EXISTS

Purpose: Identifies vehicles with zero booking history.

### Query 3: WHERE — Retrieve available vehicles of a specific type

```sql
SELECT
    *
FROM
    vehicles
WHERE
    status = 'available'
    AND type = 'car';
```

Concepts Used: WHERE

Purpose: Filters vehicles based on availability and type.

### Query 4: GROUP BY and HAVING — Find vehicles with more than 2 bookings

```sql
SELECT
    vehicles.name AS vehicle_name,
    COUNT(bookings.booking_id) AS total_bookings
FROM
    vehicles
    INNER JOIN bookings ON vehicles.vehicle_id = bookings.vehicle_id
GROUP BY
    vehicles.name
HAVING
    COUNT(bookings.booking_id) > 2;
```

Concepts Used: GROUP BY, HAVING

Purpose: Identifies high-demand vehicles based on booking count.

---