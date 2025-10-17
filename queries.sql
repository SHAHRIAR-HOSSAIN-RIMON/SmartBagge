-- =============================================
-- BAGGAGE TRACKING SYSTEM - COMPLETE SCRIPT
-- =============================================

-- =============================================
-- 1. TABLE CREATION
-- =============================================

-- Drop tables if they exist (to avoid errors on re-run)
DROP TABLE IF EXISTS Reports;
DROP TABLE IF EXISTS Baggage_Status;
DROP TABLE IF EXISTS Luggage;
DROP TABLE IF EXISTS Flight_Bookings;
DROP TABLE IF EXISTS Employees;
DROP TABLE IF EXISTS Passengers;
DROP TABLE IF EXISTS Flights;
DROP TABLE IF EXISTS Airport_Locations;

-- Airport_Locations Table (Create FIRST)
CREATE TABLE Airport_Locations (
    location_id INT PRIMARY KEY,
    airport_code VARCHAR(10) UNIQUE,
    location_name VARCHAR(100),
    city VARCHAR(100),
    country VARCHAR(100)
);

-- Flights Table
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

-- Passengers Table
CREATE TABLE Passengers (
    passenger_id INT PRIMARY KEY,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    passport_number VARCHAR(50) UNIQUE,
    email VARCHAR(100),
    phone_number VARCHAR(15)
);

-- Flight_Bookings Table (1:1 Relationship)
CREATE TABLE Flight_Bookings (
    booking_id INT PRIMARY KEY,
    passenger_id INT UNIQUE,
    flight_id INT,
    booking_date DATETIME,
    seat_number VARCHAR(10),
    FOREIGN KEY (passenger_id) REFERENCES Passengers(passenger_id),
    FOREIGN KEY (flight_id) REFERENCES Flights(flight_id)
);

-- Luggage Table
CREATE TABLE Luggage (
    luggage_id INT PRIMARY KEY,
    passenger_id INT,
    flight_id INT,
    weight DECIMAL(5,2),
    type VARCHAR(50),
    status VARCHAR(50),
    current_location_id INT,
    FOREIGN KEY (passenger_id) REFERENCES Passengers(passenger_id),
    FOREIGN KEY (flight_id) REFERENCES Flights(flight_id),
    FOREIGN KEY (current_location_id) REFERENCES Airport_Locations(location_id)
);

-- Baggage_Status Table
CREATE TABLE Baggage_Status (
    status_id INT PRIMARY KEY AUTO_INCREMENT,
    luggage_id INT,
    status VARCHAR(50),
    timestamp DATETIME,
    location_id INT,
    FOREIGN KEY (luggage_id) REFERENCES Luggage(luggage_id),
    FOREIGN KEY (location_id) REFERENCES Airport_Locations(location_id)
);

-- Employees Table
CREATE TABLE Employees (
    employee_id INT PRIMARY KEY,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    role VARCHAR(100),
    email VARCHAR(100),
    phone_number VARCHAR(15)
);

-- Reports Table
CREATE TABLE Reports (
    report_id INT PRIMARY KEY AUTO_INCREMENT,
    luggage_id INT,
    report_type VARCHAR(50),
    description TEXT,
    report_time DATETIME,
    status VARCHAR(50),
    employee_id INT,
    FOREIGN KEY (luggage_id) REFERENCES Luggage(luggage_id),
    FOREIGN KEY (employee_id) REFERENCES Employees(employee_id)
);

SELECT '=== ALL TABLES CREATED SUCCESSFULLY ===' AS status;

-- =============================================
-- 2. SAMPLE DATA INSERTION
-- =============================================

-- Insert Airport Locations
INSERT INTO Airport_Locations (location_id, airport_code, location_name, city, country) VALUES
(1, 'DAC', 'Hazrat Shahjalal International Airport', 'Dhaka', 'Bangladesh'),
(2, 'FCO', 'Leonardo da Vinci International Airport', 'Rome', 'Italy'),
(3, 'DXB', 'Dubai International Airport', 'Dubai', 'UAE'),
(4, 'JFK', 'John F. Kennedy International Airport', 'New York', 'USA'),
(5, 'LHR', 'Heathrow Airport', 'London', 'UK');

SELECT '=== AIRPORT LOCATIONS INSERTED ===' AS status;
SELECT * FROM Airport_Locations;

-- Insert Flights
INSERT INTO Flights (flight_id, flight_number, departure_airport_id, arrival_airport_id, departure_time, arrival_time) VALUES
(101, 'BG201', 1, 2, '2025-10-15 09:00:00', '2025-10-15 15:30:00'),
(102, 'BG202', 2, 1, '2025-10-16 10:00:00', '2025-10-16 16:30:00'),
(103, 'EK203', 3, 4, '2025-10-17 08:00:00', '2025-10-17 14:00:00'),
(104, 'BA204', 5, 3, '2025-10-18 11:00:00', '2025-10-18 19:00:00');

SELECT '=== FLIGHTS INSERTED ===' AS status;
SELECT * FROM Flights;

-- Insert Passengers
INSERT INTO Passengers (passenger_id, first_name, last_name, passport_number, email, phone_number) VALUES
(1, 'John', 'Doe', 'A12345678', 'john.doe@example.com', '01712345678'),
(2, 'Jane', 'Smith', 'B87654321', 'jane.smith@example.com', '01787654321'),
(3, 'Mike', 'Johnson', 'C11223344', 'mike.johnson@example.com', '01711223344'),
(4, 'Sarah', 'Wilson', 'D55667788', 'sarah.wilson@example.com', '01755667788');

SELECT '=== PASSENGERS INSERTED ===' AS status;
SELECT * FROM Passengers;

-- Insert Flight Bookings
INSERT INTO Flight_Bookings (booking_id, passenger_id, flight_id, booking_date, seat_number) VALUES
(1001, 1, 101, '2025-10-10 14:30:00', '12A'),
(1002, 2, 101, '2025-10-10 15:00:00', '15B'),
(1003, 3, 103, '2025-10-11 09:30:00', '08C'),
(1004, 4, 104, '2025-10-12 11:00:00', '22D');

SELECT '=== FLIGHT BOOKINGS INSERTED ===' AS status;
SELECT * FROM Flight_Bookings;

-- Insert Employees
INSERT INTO Employees (employee_id, first_name, last_name, role, email, phone_number) VALUES
(1, 'Robert', 'Brown', 'Baggage Handler', 'robert.brown@airport.com', '01811111111'),
(2, 'Lisa', 'Davis', 'Customer Service', 'lisa.davis@airport.com', '01822222222'),
(3, 'David', 'Wilson', 'Supervisor', 'david.wilson@airport.com', '01833333333');

SELECT '=== EMPLOYEES INSERTED ===' AS status;
SELECT * FROM Employees;

-- Insert Luggage
INSERT INTO Luggage (luggage_id, passenger_id, flight_id, weight, type, status, current_location_id) VALUES
(1, 1, 101, 22.5, 'checked-in', 'checked in', 1),
(2, 1, 101, 8.0, 'carry-on', 'with passenger', 1),
(3, 2, 101, 18.0, 'checked-in', 'in transit', 3),
(4, 3, 103, 25.0, 'checked-in', 'arrived', 4),
(5, 4, 104, 15.5, 'checked-in', 'lost', 5);

SELECT '=== LUGGAGE INSERTED ===' AS status;
SELECT * FROM Luggage;

-- Insert Baggage Status History
INSERT INTO Baggage_Status (luggage_id, status, timestamp, location_id) VALUES
-- Luggage 1 journey
(1, 'checked in', '2025-10-15 07:30:00', 1),
(1, 'in transit', '2025-10-15 09:15:00', 1),
(1, 'in transit', '2025-10-15 12:00:00', 3),

-- Luggage 3 journey
(3, 'checked in', '2025-10-15 08:00:00', 1),
(3, 'in transit', '2025-10-15 09:15:00', 1),
(3, 'in transit', '2025-10-15 12:00:00', 3),

-- Luggage 4 journey
(4, 'checked in', '2025-10-17 06:30:00', 3),
(4, 'in transit', '2025-10-17 08:15:00', 3),
(4, 'arrived', '2025-10-17 14:30:00', 4),

-- Luggage 5 journey
(5, 'checked in', '2025-10-18 09:00:00', 5),
(5, 'in transit', '2025-10-18 11:15:00', 5),
(5, 'lost', '2025-10-18 19:30:00', 5);

SELECT '=== BAGGAGE STATUS HISTORY INSERTED ===' AS status;
SELECT * FROM Baggage_Status;

-- Insert Reports
INSERT INTO Reports (luggage_id, report_type, description, report_time, status, employee_id) VALUES
(5, 'lost', 'Luggage did not arrive at Dubai Airport.', '2025-10-18 20:00:00', 'pending', 2),
(1, 'delayed', 'Luggage missed connecting flight.', '2025-10-15 16:00:00', 'resolved', 1);

SELECT '=== REPORTS INSERTED ===' AS status;
SELECT * FROM Reports;

-- =============================================
-- 3. USEFUL QUERIES FOR REPORTS
-- =============================================

-- Query 1: Find Passenger Booking Details
SELECT '=== PASSENGER BOOKING DETAILS ===' AS query_title;
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

-- Query 2: Find Current Location of Luggage
SELECT '=== CURRENT LUGGAGE LOCATION ===' AS query_title;
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

-- Query 3: Track Complete Journey of Luggage
SELECT '=== COMPLETE LUGGAGE JOURNEY ===' AS query_title;
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

-- Query 4: Find All Lost Luggage
SELECT '=== ALL LOST LUGGAGE ===' AS query_title;
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

-- Query 5: Show All Luggage on a Specific Flight
SELECT '=== LUGGAGE ON FLIGHT BG201 ===' AS query_title;
SELECT
    l.luggage_id,
    p.first_name,
    p.last_name,
    l.weight,
    l.type,
    l.status,
    al.location_name AS current_location
FROM Luggage l
JOIN Passengers p ON l.passenger_id = p.passenger_id
JOIN Airport_Locations al ON l.current_location_id = al.location_id
WHERE l.flight_id = 101;

-- Query 6: View All Pending Reports
SELECT '=== PENDING REPORTS ===' AS query_title;
SELECT
    r.report_id,
    r.report_type,
    r.description,
    p.first_name,
    p.last_name,
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name
FROM Reports r
JOIN Luggage l ON r.luggage_id = l.luggage_id
JOIN Passengers p ON l.passenger_id = p.passenger_id
LEFT JOIN Employees e ON r.employee_id = e.employee_id
WHERE r.status = 'pending';

-- Query 7: Show All Passengers and Their Luggage Count
SELECT '=== PASSENGERS AND LUGGAGE COUNT ===' AS query_title;
SELECT
    p.passenger_id,
    p.first_name,
    p.last_name,
    COUNT(l.luggage_id) AS total_luggage
FROM Passengers p
LEFT JOIN Luggage l ON p.passenger_id = l.passenger_id
GROUP BY p.passenger_id, p.first_name, p.last_name;

-- Query 8: Find All Flights Using a Specific Airport
SELECT '=== FLIGHTS USING DUBAI AIRPORT ===' AS query_title;
SELECT
    f.flight_number,
    dep.city AS departure,
    arr.city AS arrival,
    f.departure_time
FROM Flights f
JOIN Airport_Locations dep ON f.departure_airport_id = dep.location_id
JOIN Airport_Locations arr ON f.arrival_airport_id = arr.location_id
WHERE f.departure_airport_id = 3 OR f.arrival_airport_id = 3;

-- Query 9: Get Luggage Status Summary
SELECT '=== LUGGAGE STATUS SUMMARY ===' AS query_title;
SELECT 
    status,
    COUNT(*) as count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Luggage), 2) as percentage
FROM Luggage 
GROUP BY status;

-- Query 10: Employee Assignment to Reports
SELECT '=== EMPLOYEE REPORT ASSIGNMENTS ===' AS query_title;
SELECT
    e.employee_id,
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
    e.role,
    COUNT(r.report_id) AS assigned_reports
FROM Employees e
LEFT JOIN Reports r ON e.employee_id = r.employee_id
GROUP BY e.employee_id, e.first_name, e.last_name, e.role;

SELECT '=== ALL OPERATIONS COMPLETED SUCCESSFULLY ===' AS final_status;