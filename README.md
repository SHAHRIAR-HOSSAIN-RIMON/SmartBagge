# ✈️ Luggage Tracking System (SQL-Based Project)

## Overview

Airline passengers often face **lost, delayed, or mismanaged luggage** during check-in, transfer, or arrival. This project creates a **database-driven Luggage Tracking System** that helps airlines **track, monitor, and manage luggage efficiently**.

The system keeps each luggage item **linked to a passenger, a flight, and its current location**, ensuring transparency and accountability.

## System Flow

1.  Passenger creates booking for a specific flight.
2.  Passenger checks in → luggage registered and linked to booking.
3.  Luggage assigned initial location (check-in counter).
4.  During transit, system updates luggage location (via `Baggage_Status` table).
5.  If luggage delayed/lost → record created in `Reports` table.
6.  Employees review and resolve reports.

<img src="/Diagrams/simple-workflow.png" alt="ide" width="1000" height="1000" />

## Entity-Relationship (ER) Diagram

**Relationship name (e.g., "has", "owns", "carries")** <br/>
**Cardinality (e.g., 1:1, 1:M, M:1)**

  <img src="/Diagrams/ER-Diagram.png" alt="ide" width="500"/>

### Color Coding:

🟠 Orange: Passenger & Booking entities <br/>
🔵 Blue: Airport & Flight entities <br/>
🟣 Purple: Luggage entities <br/>
🟢 Green: Report & Employee entities <br/>
🟡 Yellow: All relationships (diamond shapes)

### Relationship Summary

| Relationship Type | Example                            | Tables Involved                    |
| ----------------- | ---------------------------------- | ---------------------------------- |
| **1:1**           | One passenger → One booking        | Passengers ↔ Flight_Bookings       |
| **1:M**           | One passenger → Many luggage       | Passengers → Luggage               |
| **1:M**           | One flight → Many luggage          | Flights → Luggage                  |
| **1:M**           | One luggage → Many status records  | Luggage → Baggage_Status           |
| **1:M**           | One employee → Many reports        | Employees → Reports                |
| **M:1**           | Many luggage → One location        | Luggage → Airport_Locations        |
| **M:1**           | Many status records → One location | Baggage_Status → Airport_Locations |
| **M:1**           | Many reports → One luggage         | Reports → Luggage                  |
| **M:N**           | Many flights ↔ Many airports       | Flights ↔ Airport_Locations        |

## Schema Diagram

<img src="/Diagrams/Schema-Diagram.png" alt="ide" width="500"/>

**Displaying table structures with the data types** <br/>

**Showing foreign key relationships between the tables**

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

### 4. Flight_Bookings Table (NEW - Creates 1:1 Relationship)

```sql
CREATE TABLE Flight_Bookings (
    booking_id INT PRIMARY KEY,
    passenger_id INT UNIQUE,
    flight_id INT,
    booking_date DATETIME,
    seat_number VARCHAR(10),
    FOREIGN KEY (passenger_id) REFERENCES Passengers(passenger_id),
    FOREIGN KEY (flight_id) REFERENCES Flights(flight_id)
);
```

### 5. Luggage Table

**Tracks current location of each bag**

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

### 6. Baggage_Status Table

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

### 7. Employees Table

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

### 8. Reports Table

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


## Example SQL Queries

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

### Step 4: Create Flight Booking (NEW)

```sql
INSERT INTO Flight_Bookings (booking_id, passenger_id, flight_id, booking_date, seat_number)
VALUES (1001, 1, 101, '2025-10-10 14:30:00', '12A');
```

### Step 5: Register Luggage (with current location)

```sql
INSERT INTO Luggage (luggage_id, passenger_id, flight_id, weight, type, status, current_location_id)
VALUES (1, 1, 101, 22.5, 'checked-in', 'checked in', 1);
```

### Step 6: Track Luggage Movement (Add to history)

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

### Step 7: Report Lost Luggage

```sql
INSERT INTO Reports (luggage_id, report_type, description, report_time, status, employee_id)
VALUES (1, 'lost', 'Luggage did not arrive at Rome Airport.', NOW(), 'pending', 2);

UPDATE Luggage SET status = 'lost' WHERE luggage_id = 1;
```

## Useful Queries for Reports

### Find Passenger Booking Details

```sql
SELECT
    p.first_name,
    p.last_name,
    fb.booking_id,
    fb.seat_number,
    f.flight_number,
    dep.city AS departure_city,
    arr.city AS arrival_city
FROM Passengers p
JOIN Flight_Bookings fb ON p.passenger_id = fb.passenger_id
JOIN Flights f ON fb.flight_id = f.flight_id
JOIN Airport_Locations dep ON f.departure_airport_id = dep.location_id
JOIN Airport_Locations arr ON f.arrival_airport_id = arr.location_id
WHERE p.passenger_id = 1;
```

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

### Show All Passengers and Their Luggage Count

```sql
SELECT
    p.passenger_id,
    p.first_name,
    p.last_name,
    COUNT(l.luggage_id) AS total_luggage
FROM Passengers p
LEFT JOIN Luggage l ON p.passenger_id = l.passenger_id
GROUP BY p.passenger_id, p.first_name, p.last_name;
```

### Find All Flights Using a Specific Airport

```sql
SELECT
    f.flight_number,
    dep.city AS departure,
    arr.city AS arrival,
    f.departure_time
FROM Flights f
JOIN Airport_Locations dep ON f.departure_airport_id = dep.location_id
JOIN Airport_Locations arr ON f.arrival_airport_id = arr.location_id
WHERE f.departure_airport_id = 1 OR f.arrival_airport_id = 1;
```

## Tools & Technologies

- **DBMS**: MySQL
- **Backend (Optional)**: Node / Next.js
- **Frontend (Optional)**: React / Next.js


## 🚀 Future Vision & Roadmap

We aim to transform this SQL-based **Luggage Tracking System** into a fully integrated, real-time airline management solution.  
The roadmap below outlines our **phased development plan** from academic prototype to national-level deployment.

### 🏢 Phase 1 — Integration with National Flights
- Collaborate with **domestic airlines and airports** to pilot the system using real flight and passenger data.  
- Assign every bag a **unique digital Luggage ID** for scanning and tracking across all checkpoints.  
- Integrate directly with **check-in counters, security zones, and baggage belts** through connected terminals and scanners.

### 📡 Phase 3 — Real-Time Smart Tracking (IoT Integration)
- Develop **IoT-enabled luggage tags** using RFID + GPS sensors.  
- Provide passengers and staff a **live-tracking dashboard** (web + mobile).  
- Send **automated alerts** on status changes — *arrived*, *delayed*, *misrouted*, etc.

### 🌍 Phase 2 — International Expansion
- Extend coverage to **partner airports worldwide** for cross-border luggage tracking.  
- Add **multi-language** and **multi-timezone** support for international operations.  
- Sync with **Airline Management Systems (AMS)** and **customs databases** to prevent lost or misrouted baggage.


### 🤖 Phase 4 — Predictive Analytics & AI Assistance
- Implement **machine-learning models** to predict potential baggage delays or losses based on flight patterns and weather.  
- Use AI insights to help airlines **optimize luggage flow** and **reduce mishandling incidents**.



### 🧩 Phase 5 — Passenger Portal & Mobile Access
- Launch a secure **public web/mobile portal** where passengers can:
  - Track luggage status in real time  
  - View last scanned location  
  - File or view reports on lost/delayed baggage  
  - Chat with airline representatives
 
### 🪪 Phase 6 — National Aviation Database Integration
- Partner with **civil aviation authorities** to link the system with national **air traffic and passenger databases**.  
- Establish a **centralized Luggage Identity System** accessible by all airports and airlines in real time.

---
### 🌟 Vision Statement
> “To make air travel stress-free by ensuring **every bag has a digital identity — traceable, transparent, and always accounted for.**”

---

⭐ **Contributors Welcome!**  
If you’re interested in collaborating, optimizing performance, or integrating real-time tracking APIs, feel free to **open a pull request** or reach out via GitHub Discussions.

---

⭐ **Resources**  
https://drive.google.com/drive/folders/1COHfFsRsTUZZxj9RJMeOQGSXkM44G1x2

---
