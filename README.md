
# ✈️ Luggage Tracking System (SQL-Based Project)

## Overview

Airline passengers often face **lost, delayed, or mismanaged luggage** during check-in, transfer, or arrival. This project creates a **database-driven Luggage Tracking System** that helps airlines **track, monitor, and manage luggage efficiently**.

The system keeps each luggage item **linked to a passenger, a flight, and its current location**, ensuring transparency and accountability.

## Objectives

- Maintain accurate luggage data — weight, type, and status.
- Link luggage with **specific passengers and flights**.
- Track luggage journey from **check-in → transit → arrival**.
- Alert on lost, delayed, or misplaced baggage.
- Generate **reports** for operational analysis.

## ER Diagram

  <img src="/Diagrams/ER-Diagram.png" alt="ide" width="500"/>

- Shows all entities and their relationships

- Clearly indicates primary keys (PK), foreign keys (FK), and unique constraints (UK)

- Demonstrates one-to-many and one-to-one relationships

## Schema Diagram

  <img src="/Diagrams/Schema-Diagram.png" alt="ide" width="500"/>

- Displays table structures with data types

- Shows foreign key relationships between tables

- Organized in a class-like structure for clarity

## Database Schema Design (SQL)

### 1. Airport_Locations Table

**Create this FIRST** (other tables reference it)

```sql
CREATE TABLE Airport_Locations (
    location_id INT PRIMARY KEY,
    airport_code VARCHAR(10) UNIQUE,
    location_name VARCHAR(100),
    city VARCHAR(100),
    country VARCHAR(100)
);
```

### 2. Flights Table

```sql
CREATE TABLE Flights (
    flight_id INT PRIMARY KEY,
    flight_number VARCHAR(50) UNIQUE,
    departure_airport_id INT,
    arrival_airport_id INT,
    departure_time DATETIME,
    arrival_time DATETIME,
    FOREIGN KEY (departure_airport_id) REFERENCES Airport_Locations(location_id),
    FOREIGN KEY (arrival_airport_id) REFERENCES Airport_Locations(location_id)
);
```

### 3. Passengers Table

```sql
CREATE TABLE Passengers (
    passenger_id INT PRIMARY KEY,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    passport_number VARCHAR(50) UNIQUE,
    email VARCHAR(100),
    phone_number VARCHAR(15)
);
```

### 4. Luggage Table

**KEY FIX:** Added `current_location_id` to track where luggage is NOW

```sql
CREATE TABLE Luggage (
    luggage_id INT PRIMARY KEY,
    passenger_id INT,
    flight_id INT,
    weight DECIMAL(5,2),
    type VARCHAR(50), -- 'carry-on' or 'checked-in'
    status VARCHAR(50), -- 'checked in', 'in transit', 'arrived', 'lost'
    current_location_id INT,
    FOREIGN KEY (passenger_id) REFERENCES Passengers(passenger_id),
    FOREIGN KEY (flight_id) REFERENCES Flights(flight_id),
    FOREIGN KEY (current_location_id) REFERENCES Airport_Locations(location_id)
);
```

### 5. Baggage_Status Table

**Tracks movement history of luggage**

```sql
CREATE TABLE Baggage_Status (
    status_id INT PRIMARY KEY AUTO_INCREMENT,
    luggage_id INT,
    status VARCHAR(50),
    timestamp DATETIME,
    location_id INT,
    FOREIGN KEY (luggage_id) REFERENCES Luggage(luggage_id),
    FOREIGN KEY (location_id) REFERENCES Airport_Locations(location_id)
);
```

### 6. Employees Table

```sql
CREATE TABLE Employees (
    employee_id INT PRIMARY KEY,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    role VARCHAR(100),
    email VARCHAR(100),
    phone_number VARCHAR(15)
);
```

### 7. Reports Table

```sql
CREATE TABLE Reports (
    report_id INT PRIMARY KEY AUTO_INCREMENT,
    luggage_id INT,
    report_type VARCHAR(50), -- 'lost', 'delayed', 'damaged'
    description TEXT,
    report_time DATETIME,
    status VARCHAR(50), -- 'resolved', 'pending'
    employee_id INT,
    FOREIGN KEY (luggage_id) REFERENCES Luggage(luggage_id),
    FOREIGN KEY (employee_id) REFERENCES Employees(employee_id)
);
```

## Example SQL Queries

### Step 1: Insert Airport Locations

```sql
INSERT INTO Airport_Locations (location_id, airport_code, location_name, city, country)
VALUES
(1, 'DAC', 'Hazrat Shahjalal International Airport', 'Dhaka', 'Bangladesh'),
(2, 'FCO', 'Leonardo da Vinci International Airport', 'Rome', 'Italy'),
(3, 'DXB', 'Dubai International Airport', 'Dubai', 'UAE');
```

### Step 2: Insert Flight

```sql
INSERT INTO Flights (flight_id, flight_number, departure_airport_id, arrival_airport_id, departure_time, arrival_time)
VALUES (101, 'BG201', 1, 2, '2025-10-15 09:00:00', '2025-10-15 15:30:00');
```

### Step 3: Insert Passenger

```sql
INSERT INTO Passengers (passenger_id, first_name, last_name, passport_number, email, phone_number)
VALUES (1, 'John', 'Doe', 'A12345678', 'john.doe@example.com', '01712345678');
```

### Step 4: Register Luggage (with current location)

```sql
INSERT INTO Luggage (luggage_id, passenger_id, flight_id, weight, type, status, current_location_id)
VALUES (1, 1, 101, 22.5, 'checked-in', 'checked in', 1);
```

### Step 5: Track Luggage Movement (Add to history)

```sql
-- Luggage checked in at Dhaka
INSERT INTO Baggage_Status (luggage_id, status, timestamp, location_id)
VALUES (1, 'checked in', NOW(), 1);

-- Luggage arrives at Dubai (transit)
INSERT INTO Baggage_Status (luggage_id, status, timestamp, location_id)
VALUES (1, 'in transit', NOW(), 3);

-- Update current location in Luggage table
UPDATE Luggage SET current_location_id = 3, status = 'in transit' WHERE luggage_id = 1;
```

### Step 6: Report Lost Luggage

```sql
INSERT INTO Reports (luggage_id, report_type, description, report_time, status, employee_id)
VALUES (1, 'lost', 'Luggage did not arrive at Rome Airport.', NOW(), 'pending', 2);

UPDATE Luggage SET status = 'lost' WHERE luggage_id = 1;
```

## Useful Queries for Reports

### Find Current Location of Luggage

```sql
SELECT
    l.luggage_id,
    p.first_name,
    p.last_name,
    l.status,
    al.location_name AS current_location,
    al.city
FROM Luggage l
JOIN Passengers p ON l.passenger_id = p.passenger_id
JOIN Airport_Locations al ON l.current_location_id = al.location_id
WHERE l.luggage_id = 1;
```

### Track Complete Journey of Luggage

```sql
SELECT
    bs.status_id,
    bs.status,
    bs.timestamp,
    al.location_name,
    al.city
FROM Baggage_Status bs
JOIN Airport_Locations al ON bs.location_id = al.location_id
WHERE bs.luggage_id = 1
ORDER BY bs.timestamp;
```

### Find All Lost Luggage

```sql
SELECT
    l.luggage_id,
    p.first_name,
    p.last_name,
    f.flight_number,
    l.status
FROM Luggage l
JOIN Passengers p ON l.passenger_id = p.passenger_id
JOIN Flights f ON l.flight_id = f.flight_id
WHERE l.status = 'lost';
```

### Show All Luggage on a Specific Flight

```sql
SELECT
    l.luggage_id,
    p.first_name,
    p.last_name,
    l.weight,
    l.status,
    al.location_name AS current_location
FROM Luggage l
JOIN Passengers p ON l.passenger_id = p.passenger_id
JOIN Airport_Locations al ON l.current_location_id = al.location_id
WHERE l.flight_id = 101;
```

### View All Pending Reports

```sql
SELECT
    r.report_id,
    r.report_type,
    r.description,
    p.first_name,
    p.last_name,
    e.first_name AS employee_name
FROM Reports r
JOIN Luggage l ON r.luggage_id = l.luggage_id
JOIN Passengers p ON l.passenger_id = p.passenger_id
LEFT JOIN Employees e ON r.employee_id = e.employee_id
WHERE r.status = 'pending';
```

## Tools & Technologies

- **DBMS**: MySQL
- **Backend (Optional)**: Node / Next.js
- **Frontend (Optional)**: React / Next.js
