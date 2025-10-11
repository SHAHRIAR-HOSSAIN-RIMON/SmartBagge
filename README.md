

# Luggage Tracking System Project

## Project Overview

Passengers face difficulties handling their luggage, especially with baggage check-ins, tracking, and retrieval at the destination. This can lead to issues like lost baggage, delays, or confusion. Our goal is to design a system that helps streamline luggage handling by keeping track of each piece of luggage and associating it with specific passengers, flights, and baggage details.

The system will:
- Track luggage information (size, weight, type).
- Link luggage to specific passengers and flights.
- Record and track baggage from check-in to destination arrival.
- Provide real-time tracking updates to the user.
- Offer reports on baggage status (delayed, lost, etc.).

---

## System Development Plan

### 1. Problem Definition
Passengers encounter multiple issues during their journey, primarily concerning luggage management. These issues include baggage check-in errors, delays, lost luggage, and confusion around retrieval. This system aims to solve these issues by creating an efficient way to track luggage, linking it to passengers, flights, and real-time statuses.

### 2. Objectives
- **Track luggage information** such as weight, size, type, and status.
- **Link luggage to specific passengers** and their corresponding flights.
- **Monitor baggage** from check-in until it arrives at the destination.
- **Provide real-time tracking updates** and send alerts when luggage statuses change.
- **Generate reports** for lost, delayed, or misplaced luggage.

### 3. Key Features
- **Luggage Information**: Track details like luggage weight, size, type (carry-on, checked-in), and more.
- **Passenger Details**: Link luggage to passengers’ flights and bookings.
- **Flight Information**: Track which flight the luggage is associated with.
- **Luggage Status Tracking**: Track statuses of luggage, e.g., "checked in," "in transit," "arrived."
- **Reporting**: Create reports to manage luggage that is lost, delayed, or misplaced.

---

## Updated Database Schema Design

### 1. Passengers Table
Stores passenger information and their associated flights.

```sql
CREATE TABLE Passengers (
    passenger_id INT PRIMARY KEY,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    passport_number VARCHAR(50) UNIQUE,
    email VARCHAR(100),
    phone_number VARCHAR(15),
    flight_id INT
);
````

### 2. Flights Table

Stores flight details, including flight number, departure/arrival cities, and times.

```sql
CREATE TABLE Flights (
    flight_id INT PRIMARY KEY,
    flight_number VARCHAR(50) UNIQUE,
    departure_city VARCHAR(100),
    arrival_city VARCHAR(100),
    departure_time DATETIME,
    arrival_time DATETIME
);
```

### 3. Luggage Table

Contains information about luggage, linked to passengers and flights.

```sql
CREATE TABLE Luggage (
    luggage_id INT PRIMARY KEY,
    passenger_id INT,
    flight_id INT,
    weight DECIMAL(5,2),
    size VARCHAR(50),
    type VARCHAR(50), -- carry-on, checked-in
    status VARCHAR(50), -- checked in, in transit, arrived
    FOREIGN KEY (passenger_id) REFERENCES Passengers(passenger_id),
    FOREIGN KEY (flight_id) REFERENCES Flights(flight_id)
);
```

### 4. Baggage Status Table

Tracks status updates for each piece of luggage at different stages.

```sql
CREATE TABLE Baggage_Status (
    status_id INT PRIMARY KEY,
    luggage_id INT,
    status VARCHAR(50), -- checked in, delayed, lost, etc.
    timestamp DATETIME,
    location VARCHAR(100), -- e.g., Check-in counter, In Transit
    FOREIGN KEY (luggage_id) REFERENCES Luggage(luggage_id)
);
```

### 5. Reports Table

Generates reports for luggage that has been lost, delayed, or is otherwise problematic.

```sql
CREATE TABLE Reports (
    report_id INT PRIMARY KEY,
    luggage_id INT,
    report_type VARCHAR(50), -- lost, delayed, etc.
    description TEXT,
    report_time DATETIME,
    status VARCHAR(50), -- resolved, pending
    FOREIGN KEY (luggage_id) REFERENCES Luggage(luggage_id)
);
```

### 6. Employees Table

New table to store information about airline staff interacting with the system. Staff will be responsible for luggage tracking and report handling.

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

### 7. Airport Locations Table

New table to store airport location data, which will help track the location of luggage at various points (e.g., Check-in counter, In Transit, Arrival Gate).

```sql
CREATE TABLE Airport_Locations (
    location_id INT PRIMARY KEY,
    location_name VARCHAR(100),
    city VARCHAR(100),
    country VARCHAR(100)
);
```

---

## SQL Queries for Common Use Cases

### 1. Insert New Passenger

```sql
INSERT INTO Passengers (passenger_id, first_name, last_name, passport_number, email, phone_number, flight_id)
VALUES (1, 'John', 'Doe', 'A12345678', 'john.doe@example.com', '1234567890', 101);
```

### 2. Track Luggage for a Passenger

```sql
INSERT INTO Luggage (luggage_id, passenger_id, flight_id, weight, size, type, status)
VALUES (1, 1, 101, 20.5, 'Large', 'checked-in', 'checked in');
```

### 3. Update Luggage Status

```sql
UPDATE Luggage
SET status = 'in transit'
WHERE luggage_id = 1;
```

### 4. Track Baggage Status

```sql
INSERT INTO Baggage_Status (status_id, luggage_id, status, timestamp, location)
VALUES (1, 1, 'checked in', NOW(), 'Check-in Counter');
```

### 5. Generate Report for Lost Luggage

```sql
INSERT INTO Reports (report_id, luggage_id, report_type, description, report_time, status)
VALUES (1, 1, 'lost', 'Luggage misplaced at arrival airport.', NOW(), 'pending');
```
