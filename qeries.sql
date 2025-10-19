
-- =============================================
-- SMARTBAGGAGE / LUGGAGE TRACKING SYSTEM
-- FULL DATABASE CREATION + POPULATION SCRIPT
-- =============================================

-- 1️⃣ DROP TABLES (in reverse FK order)
DROP TABLE IF EXISTS Reports;
DROP TABLE IF EXISTS Baggage_Status;
DROP TABLE IF EXISTS Luggage;
DROP TABLE IF EXISTS Flight_Bookings;
DROP TABLE IF EXISTS Employees;
DROP TABLE IF EXISTS Passengers;
DROP TABLE IF EXISTS Flights;
DROP TABLE IF EXISTS Airport_Locations;

-- =============================================
-- 2️⃣ CREATE TABLES
-- =============================================

-- Airport_Locations Table (Create FIRST)
-- =============================================
-- ✅ FIXED TABLE STRUCTURE (With Safe CASCADING)
-- =============================================

-- Airport_Locations Table
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
    FOREIGN KEY (departure_airport_id)
        REFERENCES Airport_Locations(location_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (arrival_airport_id)
        REFERENCES Airport_Locations(location_id)
        ON DELETE CASCADE ON UPDATE CASCADE
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
    FOREIGN KEY (passenger_id)
        REFERENCES Passengers(passenger_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (flight_id)
        REFERENCES Flights(flight_id)
        ON DELETE CASCADE ON UPDATE CASCADE
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
    FOREIGN KEY (passenger_id)
        REFERENCES Passengers(passenger_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (flight_id)
        REFERENCES Flights(flight_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (current_location_id)
        REFERENCES Airport_Locations(location_id)
        ON DELETE SET NULL ON UPDATE CASCADE
);

-- Baggage_Status Table
CREATE TABLE Baggage_Status (
    status_id INT PRIMARY KEY AUTO_INCREMENT,
    luggage_id INT,
    status VARCHAR(50),
    timestamp DATETIME,
    location_id INT,
    FOREIGN KEY (luggage_id)
        REFERENCES Luggage(luggage_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (location_id)
        REFERENCES Airport_Locations(location_id)
        ON DELETE SET NULL ON UPDATE CASCADE
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
    FOREIGN KEY (luggage_id)
        REFERENCES Luggage(luggage_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (employee_id)
        REFERENCES Employees(employee_id)
        ON DELETE SET NULL ON UPDATE CASCADE
);

SELECT '=== ALL TABLES CREATED SUCCESSFULLY ===' AS status;

-- =============================================
-- 3️⃣ INSERT SAMPLE DATA (15+ rows each)
-- =============================================

-- AIRPORT LOCATIONS (15)
INSERT INTO Airport_Locations (location_id, airport_code, location_name, city, country) VALUES
(1, 'DAC', 'Hazrat Shahjalal International Airport', 'Dhaka', 'Bangladesh'),
(2, 'FCO', 'Leonardo da Vinci International Airport', 'Rome', 'Italy'),
(3, 'DXB', 'Dubai International Airport', 'Dubai', 'UAE'),
(4, 'JFK', 'John F. Kennedy International Airport', 'New York', 'USA'),
(5, 'LHR', 'Heathrow Airport', 'London', 'UK'),
(6, 'SIN', 'Changi Airport', 'Singapore', 'Singapore'),
(7, 'LAX', 'Los Angeles International Airport', 'Los Angeles', 'USA'),
(8, 'HND', 'Tokyo Haneda Airport', 'Tokyo', 'Japan'),
(9, 'CDG', 'Charles de Gaulle Airport', 'Paris', 'France'),
(10, 'YYZ', 'Toronto Pearson Airport', 'Toronto', 'Canada'),
(11, 'SYD', 'Sydney Kingsford Smith Airport', 'Sydney', 'Australia'),
(12, 'MUC', 'Munich Airport', 'Munich', 'Germany'),
(13, 'IST', 'Istanbul Airport', 'Istanbul', 'Turkey'),
(14, 'DOH', 'Hamad International Airport', 'Doha', 'Qatar'),
(15, 'BOM', 'Chhatrapati Shivaji Airport', 'Mumbai', 'India');

-- FLIGHTS (15)
INSERT INTO Flights (flight_id, flight_number, departure_airport_id, arrival_airport_id, departure_time, arrival_time) VALUES
(101, 'BG201', 1, 2, '2025-10-15 09:00:00', '2025-10-15 15:30:00'),
(102, 'BG202', 2, 1, '2025-10-16 10:00:00', '2025-10-16 16:30:00'),
(103, 'EK203', 3, 4, '2025-10-17 08:00:00', '2025-10-17 14:00:00'),
(104, 'BA204', 5, 3, '2025-10-18 11:00:00', '2025-10-18 19:00:00'),
(105, 'SQ305', 6, 7, '2025-10-19 09:00:00', '2025-10-19 17:00:00'),
(106, 'JL401', 8, 9, '2025-10-19 10:00:00', '2025-10-19 17:45:00'),
(107, 'AF555', 9, 10, '2025-10-20 11:00:00', '2025-10-20 15:30:00'),
(108, 'QF601', 11, 3, '2025-10-20 13:30:00', '2025-10-20 21:00:00'),
(109, 'LH702', 12, 8, '2025-10-21 08:00:00', '2025-10-21 14:00:00'),
(110, 'TK888', 13, 4, '2025-10-21 09:30:00', '2025-10-21 18:00:00'),
(111, 'QR901', 14, 5, '2025-10-22 07:00:00', '2025-10-22 14:00:00'),
(112, 'AI100', 15, 1, '2025-10-22 06:00:00', '2025-10-22 13:00:00'),
(113, 'EK501', 3, 15, '2025-10-23 04:30:00', '2025-10-23 10:30:00'),
(114, 'BA777', 5, 9, '2025-10-23 08:45:00', '2025-10-23 14:30:00'),
(115, 'CX909', 8, 6, '2025-10-24 09:15:00', '2025-10-24 18:30:00');

-- PASSENGERS (15)
INSERT INTO Passengers (passenger_id, first_name, last_name, passport_number, email, phone_number) VALUES
(1, 'John', 'Doe', 'A12345678', 'john.doe@example.com', '01712345678'),
(2, 'Jane', 'Smith', 'B87654321', 'jane.smith@example.com', '01787654321'),
(3, 'Mike', 'Johnson', 'C11223344', 'mike.johnson@example.com', '01711223344'),
(4, 'Sarah', 'Wilson', 'D55667788', 'sarah.wilson@example.com', '01755667788'),
(5, 'Emily', 'Brown', 'E99887766', 'emily.brown@example.com', '01799887766'),
(6, 'Alex', 'Turner', 'F44332211', 'alex.turner@example.com', '01744332211'),
(7, 'Olivia', 'Martin', 'G66778899', 'olivia.martin@example.com', '01766778899'),
(8, 'Daniel', 'Clark', 'H55443322', 'daniel.clark@example.com', '01755443322'),
(9, 'Sophia', 'Taylor', 'I11224455', 'sophia.taylor@example.com', '01711224455'),
(10, 'Liam', 'Anderson', 'J33445566', 'liam.anderson@example.com', '01733445566'),
(11, 'Chloe', 'Harris', 'K77889900', 'chloe.harris@example.com', '01777889900'),
(12, 'Ethan', 'Wright', 'L99001122', 'ethan.wright@example.com', '01799001122'),
(13, 'Ava', 'King', 'M55667788', 'ava.king@example.com', '01755667788'),
(14, 'Noah', 'Green', 'N22334455', 'noah.green@example.com', '01722334455'),
(15, 'Grace', 'Scott', 'O88990011', 'grace.scott@example.com', '01788990011');

-- FLIGHT BOOKINGS (15)
INSERT INTO Flight_Bookings (booking_id, passenger_id, flight_id, booking_date, seat_number) VALUES
(1001, 1, 101, '2025-10-10 14:30:00', '12A'),
(1002, 2, 101, '2025-10-10 15:00:00', '15B'),
(1003, 3, 103, '2025-10-11 09:30:00', '08C'),
(1004, 4, 104, '2025-10-12 11:00:00', '22D'),
(1005, 5, 105, '2025-10-13 10:00:00', '18A'),
(1006, 6, 106, '2025-10-13 11:30:00', '14C'),
(1007, 7, 107, '2025-10-14 08:00:00', '21B'),
(1008, 8, 108, '2025-10-14 12:00:00', '06F'),
(1009, 9, 109, '2025-10-14 13:00:00', '13D'),
(1010, 10, 110, '2025-10-15 09:30:00', '09A'),
(1011, 11, 111, '2025-10-15 10:15:00', '16E'),
(1012, 12, 112, '2025-10-15 11:45:00', '04C'),
(1013, 13, 113, '2025-10-16 14:00:00', '19B'),
(1014, 14, 114, '2025-10-17 07:45:00', '23F'),
(1015, 15, 105, '2025-10-17 09:15:00', '08A');

-- EMPLOYEES (15)
INSERT INTO Employees (employee_id, first_name, last_name, role, email, phone_number) VALUES
(1, 'Robert', 'Brown', 'Baggage Handler', 'robert.brown@airport.com', '01811111111'),
(2, 'Lisa', 'Davis', 'Customer Service', 'lisa.davis@airport.com', '01822222222'),
(3, 'David', 'Wilson', 'Supervisor', 'david.wilson@airport.com', '01833333333'),
(4, 'Natalie', 'Brooks', 'Technician', 'natalie.brooks@airport.com', '01844444444'),
(5, 'Aaron', 'White', 'Baggage Handler', 'aaron.white@airport.com', '01855555555'),
(6, 'Ella', 'Miller', 'Security Officer', 'ella.miller@airport.com', '01866666666'),
(7, 'James', 'Moore', 'Customer Support', 'james.moore@airport.com', '01877777777'),
(8, 'Henry', 'Evans', 'Technician', 'henry.evans@airport.com', '01888888888'),
(9, 'Isabella', 'Hall', 'Manager', 'isabella.hall@airport.com', '01899999999'),
(10, 'Lucas', 'Allen', 'Baggage Supervisor', 'lucas.allen@airport.com', '01810101010'),
(11, 'Mia', 'Young', 'Lost & Found', 'mia.young@airport.com', '01811112222'),
(12, 'Mason', 'Hill', 'Maintenance', 'mason.hill@airport.com', '01813131313'),
(13, 'Ella', 'Carter', 'Security', 'ella.carter@airport.com', '01814141414'),
(14, 'Jack', 'Bennett', 'Cleaner', 'jack.bennett@airport.com', '01815151515'),
(15, 'Grace', 'Mitchell', 'Duty Manager', 'grace.mitchell@airport.com', '01816161616');

-- LUGGAGE (15)
INSERT INTO Luggage (luggage_id, passenger_id, flight_id, weight, type, status, current_location_id) VALUES
(1, 1, 101, 22.5, 'checked-in', 'checked in', 1),
(2, 1, 101, 8.0, 'carry-on', 'with passenger', 1),
(3, 2, 101, 18.0, 'checked-in', 'in transit', 3),
(4, 3, 103, 25.0, 'checked-in', 'arrived', 4),
(5, 4, 104, 15.5, 'checked-in', 'lost', 5),
(6, 5, 105, 20.0, 'checked-in', 'in transit', 6),
(7, 6, 106, 23.5, 'checked-in', 'arrived', 9),
(8, 7, 107, 25.0, 'checked-in', 'arrived', 10),
(9, 8, 108, 15.0, 'carry-on', 'with passenger', 3),
(10, 9, 109, 26.0, 'checked-in', 'in transit', 8),
(11, 10, 110, 28.0, 'checked-in', 'arrived', 4),
(12, 11, 111, 19.5, 'checked-in', 'arrived', 5),
(13, 12, 112, 21.5, 'checked-in', 'in transit', 15),
(14, 13, 113, 30.0, 'checked-in', 'lost', 3),
(15, 14, 114, 27.5, 'checked-in', 'delayed', 9);

-- BAGGAGE STATUS (24 total)
INSERT INTO Baggage_Status (luggage_id, status, timestamp, location_id) VALUES
(1, 'checked in', '2025-10-15 07:30:00', 1),
(1, 'in transit', '2025-10-15 09:15:00', 1),
(1, 'in transit', '2025-10-15 12:00:00', 3),
(3, 'checked in', '2025-10-15 08:00:00', 1),
(3, 'in transit', '2025-10-15 09:15:00', 1),
(3, 'in transit', '2025-10-15 12:00:00', 3),
(4, 'checked in', '2025-10-17 06:30:00', 3),
(4, 'in transit', '2025-10-17 08:15:00', 3),
(4, 'arrived', '2025-10-17 14:30:00', 4),
(5, 'checked in', '2025-10-18 09:00:00', 5),
(5, 'in transit', '2025-10-18 11:15:00', 5),
(5, 'lost', '2025-10-18 19:30:00', 5),
(6, 'checked in', '2025-10-19 07:00:00', 6),
(6, 'in transit', '2025-10-19 09:30:00', 7),
(7, 'checked in', '2025-10-19 08:30:00', 8),
(7, 'arrived', '2025-10-19 17:30:00', 9),
(8, 'checked in', '2025-10-19 09:45:00', 9),
(8, 'arrived', '2025-10-19 15:00:00', 10),
(10, 'checked in', '2025-10-20 07:30:00', 12),
(10, 'in transit', '2025-10-20 12:30:00', 8),
(11, 'arrived', '2025-10-21 18:30:00', 4),
(12, 'arrived', '2025-10-22 13:30:00', 5),
(13, 'in transit', '2025-10-22 10:00:00', 15),
(14, 'lost', '2025-10-23 12:00:00', 3),
(15, 'delayed', '2025-10-23 18:00:00', 9);

-- REPORTS (15)
INSERT INTO Reports (luggage_id, report_type, description, report_time, status, employee_id) VALUES
(5, 'lost', 'Luggage did not arrive at Dubai Airport.', '2025-10-18 20:00:00', 'pending', 2),
(1, 'delayed', 'Luggage missed connecting flight.', '2025-10-15 16:00:00', 'resolved', 1),
(6, 'delayed', 'Luggage delayed due to weather.', '2025-10-19 19:00:00', 'resolved', 4),
(7, 'damaged', 'Handle broken during transit.', '2025-10-19 19:30:00', 'pending', 5),
(8, 'missing tag', 'Tag detached during loading.', '2025-10-20 08:00:00', 'resolved', 6),
(9, 'info', 'Passenger confirmed carry-on bag.', '2025-10-20 09:00:00', 'closed', 7),
(10, 'delayed', 'Flight delay caused luggage reroute.', '2025-10-20 18:00:00', 'pending', 8),
(11, 'damaged', 'Wheel cracked.', '2025-10-21 20:00:00', 'resolved', 9),
(12, 'info', 'Luggage located at Heathrow.', '2025-10-22 10:30:00', 'resolved', 10),
(13, 'inquiry', 'Passenger asked for luggage update.', '2025-10-22 11:45:00', 'closed', 11),
(14, 'lost', 'Not found at destination.', '2025-10-23 15:30:00', 'pending', 12),
(15, 'delayed', 'Missed connection in Paris.', '2025-10-23 19:00:00', 'pending', 13),
(2, 'damaged', 'Scratch on side panel.', '2025-10-15 18:00:00', 'resolved', 3),
(3, 'info', 'Rechecked baggage after security.', '2025-10-15 19:00:00', 'closed', 4),
(4, 'arrived', 'Confirmed received by passenger.', '2025-10-17 19:00:00', 'closed', 2);

SELECT '=== ALL DATA INSERTED SUCCESSFULLY ===' AS status;

-- =============================================
-- 4️⃣ USEFUL QUERIES FOR ANALYSIS (WITH UPDATE + DELETE IN EACH)
-- =============================================

-- Query 1: Passenger Booking Details
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

-- UPDATE ➤ Change passenger phone number
UPDATE Passengers SET phone_number = '01700000000' WHERE passenger_id = 1;

-- DELETE ➤ Delete a canceled booking (if exists)
DELETE FROM Flight_Bookings WHERE booking_id = 1016;


-- Query 2: Current Luggage Location
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

-- UPDATE ➤ Mark luggage as 'arrived'
UPDATE Luggage SET status = 'arrived' WHERE luggage_id = 1;

-- DELETE ➤ Remove luggage entry for testing
DELETE FROM Luggage WHERE luggage_id = 16;


-- Query 3: Complete Luggage Journey
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

-- UPDATE ➤ Adjust timestamp for clarity
UPDATE Baggage_Status SET timestamp = '2025-10-15 08:00:00' WHERE status_id = 1;

-- DELETE ➤ Delete outdated status record
DELETE FROM Baggage_Status WHERE timestamp < '2025-10-17 00:00:00';


-- Query 4: All Lost Luggage
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

-- UPDATE ➤ Recover lost luggage
UPDATE Luggage SET status = 'found' WHERE status = 'lost' LIMIT 1;

-- DELETE ➤ Delete duplicate lost luggage records
DELETE FROM Luggage WHERE status = 'lost' AND luggage_id > 20;


-- Query 5: Luggage on Specific Flight (BG201)
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

-- UPDATE ➤ Update luggage weight for correction
UPDATE Luggage SET weight = 23.0 WHERE flight_id = 101 AND luggage_id = 1;

-- DELETE ➤ Remove test luggage linked to BG201
DELETE FROM Luggage WHERE flight_id = 101 AND luggage_id = 16;


-- Query 6: Pending Reports
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

-- UPDATE ➤ Mark one report as resolved
UPDATE Reports SET status = 'resolved' WHERE status = 'pending' LIMIT 1;

-- DELETE ➤ Remove old resolved reports
DELETE FROM Reports WHERE status = 'resolved' AND report_time < '2025-10-20';


-- Query 7: Passengers and Luggage Count
SELECT '=== PASSENGERS AND LUGGAGE COUNT ===' AS query_title;
SELECT
    p.passenger_id,
    p.first_name,
    p.last_name,
    COUNT(l.luggage_id) AS total_luggage
FROM Passengers p
LEFT JOIN Luggage l ON p.passenger_id = l.passenger_id
GROUP BY p.passenger_id, p.first_name, p.last_name;

-- UPDATE ➤ Correct passenger name typo
UPDATE Passengers SET first_name = 'Jon' WHERE first_name = 'John';

-- DELETE ➤ Remove passenger with no luggage
DELETE FROM Passengers WHERE passenger_id NOT IN (SELECT DISTINCT passenger_id FROM Luggage);


-- Query 8: Flights Using Dubai Airport
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

-- UPDATE ➤ Delay a Dubai flight
UPDATE Flights SET departure_time = DATE_ADD(departure_time, INTERVAL 1 HOUR) WHERE departure_airport_id = 3;

-- DELETE ➤ Remove old flight record
DELETE FROM Flights WHERE flight_id > 115;


-- Query 9: Luggage Status Summary
SELECT '=== LUGGAGE STATUS SUMMARY ===' AS query_title;
SELECT 
    status,
    COUNT(*) as count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Luggage), 2) as percentage
FROM Luggage 
GROUP BY status;

-- UPDATE ➤ Normalize status text
UPDATE Luggage SET status = 'Checked-In' WHERE status = 'checked-in';

-- DELETE ➤ Remove temporary luggage data
DELETE FROM Luggage WHERE status = 'temporary';


-- Query 10: Employee Assignment Summary
SELECT '=== EMPLOYEE REPORT ASSIGNMENTS ===' AS query_title;
SELECT
    e.employee_id,
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
    e.role,
    COUNT(r.report_id) AS assigned_reports
FROM Employees e
LEFT JOIN Reports r ON e.employee_id = r.employee_id
GROUP BY e.employee_id, e.first_name, e.last_name, e.role;

-- UPDATE ➤ Promote employee
UPDATE Employees SET role = 'Senior Supervisor' WHERE employee_id = 3;

-- DELETE ➤ Remove inactive employees
DELETE FROM Employees WHERE employee_id > 15;

SELECT '=== ALL OPERATIONS COMPLETED SUCCESSFULLY ===' AS final_status;
