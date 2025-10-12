

# ✈️ Luggage Tracking System (SQL-Based Project)

## 🧩 Overview

Airline passengers often face **lost, delayed, or mismanaged luggage** during check-in, transfer, or arrival. This project creates a **database-driven Luggage Tracking System** that helps airlines **track, monitor, and manage luggage efficiently**.

The system keeps each luggage item **linked to a passenger, a flight, and its real-time status**, ensuring transparency and accountability.

---

## 🎯 Objectives

* Maintain accurate luggage data — weight, type, size, and status.
* Link luggage with **specific passengers and flights**.
* Track luggage journey from **check-in → transit → arrival**.
* Alert on lost, delayed, or misplaced baggage.
* Generate **reports** for operational analysis.

---

## 🏗️ System Architecture

| Layer                            | Responsibility                                                                           |
| -------------------------------- | ---------------------------------------------------------------------------------------- |
| **Database Layer (SQL)**         | Stores and manages passengers, flights, luggage, status updates, reports, and employees. |
| **Application Layer (optional)** | Could be a simple web or desktop app to query data (Python + SQL, PHP + MySQL, etc.)     |
| **Visualization Layer**          | Displays reports and baggage status dashboards.                                          |

---

## 📊 Entity-Relationship (ER) Diagram

You can draw this in **draw.io**, **Lucidchart**, or **DBDiagram.io** using the following relationships:

```
Passengers (1)───< (M) Luggage >───(1) Flights
          │                        │
          │                        └── Tracks which flight luggage belongs to
          │
          ├──< (M) Baggage_Status ──> (1) Airport_Locations
          │
          └──< (M) Reports
          
Employees ──< (M) Reports
```

**Key Relationships:**

* Each passenger can have **multiple luggage**.
* Each luggage belongs to **one flight**.
* Each luggage can have **many status updates**.
* Employees handle **reports**.
* Each status update is linked to **an airport location**.

---

## 🔁 System Flow Diagram (Conceptual)

**Flow:**

1. ✈️ Passenger checks in → luggage registered in database.
2. 🎫 Luggage assigned to a specific flight.
3. 📡 During transit, system updates luggage location/status (via `Baggage_Status`).
4. 🧾 If luggage delayed/lost → record entered in `Reports`.
5. 👨‍💼 Employees review and resolve reports.

*(Draw boxes and arrows using “Passenger → Luggage → Flight → Status → Report → Employee” chain.)*

---

## 🧱 Database Schema Design (SQL)

### 1. Passengers Table

```sql
CREATE TABLE Passengers (
    passenger_id INT PRIMARY KEY,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    passport_number VARCHAR(50) UNIQUE,
    email VARCHAR(100),
    phone_number VARCHAR(15),
    flight_id INT,
    FOREIGN KEY (flight_id) REFERENCES Flights(flight_id)
);
```

### 2. Flights Table

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

### 4. Baggage_Status Table

```sql
CREATE TABLE Baggage_Status (
    status_id INT PRIMARY KEY,
    luggage_id INT,
    status VARCHAR(50), -- checked in, delayed, lost, etc.
    timestamp DATETIME,
    location VARCHAR(100),
    FOREIGN KEY (luggage_id) REFERENCES Luggage(luggage_id)
);
```

### 5. Reports Table

```sql
CREATE TABLE Reports (
    report_id INT PRIMARY KEY,
    luggage_id INT,
    report_type VARCHAR(50), -- lost, delayed, etc.
    description TEXT,
    report_time DATETIME,
    status VARCHAR(50), -- resolved, pending
    employee_id INT,
    FOREIGN KEY (luggage_id) REFERENCES Luggage(luggage_id),
    FOREIGN KEY (employee_id) REFERENCES Employees(employee_id)
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

### 7. Airport_Locations Table

```sql
CREATE TABLE Airport_Locations (
    location_id INT PRIMARY KEY,
    location_name VARCHAR(100),
    city VARCHAR(100),
    country VARCHAR(100)
);
```

---

## ⚙️ Example SQL Queries

### Insert Passenger

```sql
INSERT INTO Passengers (passenger_id, first_name, last_name, passport_number, email, phone_number, flight_id)
VALUES (1, 'John', 'Doe', 'A12345678', 'john.doe@example.com', '01712345678', 101);
```

### Insert Flight

```sql
INSERT INTO Flights (flight_id, flight_number, departure_city, arrival_city, departure_time, arrival_time)
VALUES (101, 'BG201', 'Dhaka', 'Rome', '2025-10-15 09:00:00', '2025-10-15 15:30:00');
```

### Register Luggage

```sql
INSERT INTO Luggage (luggage_id, passenger_id, flight_id, weight, size, type, status)
VALUES (1, 1, 101, 22.5, 'Large', 'checked-in', 'checked in');
```

### Update Luggage Status

```sql
UPDATE Luggage
SET status = 'in transit'
WHERE luggage_id = 1;
```

### Add Baggage Status

```sql
INSERT INTO Baggage_Status (status_id, luggage_id, status, timestamp, location)
VALUES (1, 1, 'checked in', NOW(), 'Dhaka Check-in Counter');
```

### Report Lost Luggage

```sql
INSERT INTO Reports (report_id, luggage_id, report_type, description, report_time, status, employee_id)
VALUES (1, 1, 'lost', 'Luggage misplaced at Rome Airport.', NOW(), 'pending', 2);
```

---

## 📈 Example Queries for Output Reports

| Use Case                            | SQL Query                                                               |
| ----------------------------------- | ----------------------------------------------------------------------- |
| Find all lost luggage               | `SELECT * FROM Reports WHERE report_type = 'lost';`                     |
| Show passenger’s luggage            | `SELECT * FROM Luggage WHERE passenger_id = 1;`                         |
| Check flight luggage status         | `SELECT * FROM Luggage WHERE flight_id = 101;`                          |
| View all pending reports            | `SELECT * FROM Reports WHERE status = 'pending';`                       |
| Track location history of a luggage | `SELECT * FROM Baggage_Status WHERE luggage_id = 1 ORDER BY timestamp;` |

---

## 🧠 Project Flow Summary

1. **Data Entry** – Enter flight, passenger, and luggage details.
2. **Status Tracking** – Update luggage status at each airport checkpoint.
3. **Error Handling** – Report lost or delayed luggage via the Reports table.
4. **Employee Review** – Assigned employees investigate and resolve cases.
5. **Report Generation** – Generate summary reports for management.

---

## 🧰 Tools & Technologies

* **DBMS**: MySQL / PostgreSQL / SQLite
* **Frontend (Optional)**: HTML + PHP / Python (Tkinter or Flask)
* **Visualization (Optional)**: Power BI / Tableau for luggage stats
* **Diagramming Tools**: Draw.io, Lucidchart, or DBDiagram.io



Would you like me to **generate the actual ER diagram (image)** and a **system flowchart** (e.g., draw.io-style visual) for this project so you can directly include them in your report or presentation PDF?
