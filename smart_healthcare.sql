CREATE TABLE Clinic (
    name VARCHAR(100) NOT NULL,
    city VARCHAR(60),
    address VARCHAR(200),
    phone VARCHAR(20) NOT NULL,
    clinic_id INT PRIMARY KEY);

    CREATE TABLE Doctor (
    full_name VARCHAR(100) NOT NULL,
    specialty VARCHAR(80),
    phone VARCHAR(20) NOT NULL,
    email VARCHAR(100),
    doctor_id INT PRIMARY KEY,
    c_ID INT NOT NULL,
    FOREIGN KEY (c_ID) REFERENCES Clinic(clinic_id));

    CREATE TABLE Patient (
    full_name VARCHAR(100) NOT NULL,
    dob DATE NOT NULL,
    gender VARCHAR(10),
    phone VARCHAR(20),
    email VARCHAR(100),
    patient_id INT PRIMARY KEY,
    d_ID INT NOT NULL,
    c_ID INT NOT NULL,
    FOREIGN KEY (d_ID) REFERENCES Doctor(doctor_id),
    FOREIGN KEY (c_ID) REFERENCES Clinic(clinic_id));

CREATE TABLE DoctorSchedule (
    day_of_week VARCHAR(15) NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    schedule_id INT PRIMARY KEY, 
    d_ID INT NOT NULL,
    c_ID INT NOT NULL,
    FOREIGN KEY (d_ID) REFERENCES Doctor(doctor_id),
    FOREIGN KEY (c_ID) REFERENCES Clinic(clinic_id));

    
CREATE TABLE Appointment(
    start_time DATETIME NOT NULL,
    end_time DATETIME,
    status VARCHAR(20),
    reason VARCHAR(200),
    appointment_id INT PRIMARY KEY,
    p_ID INT NOT NULL,
    d_ID INT NOT NULL,
    c_ID INT NOT NULL,
    FOREIGN KEY (p_ID) REFERENCES Patient(patient_id),
    FOREIGN KEY (d_ID) REFERENCES Doctor(doctor_id),
    FOREIGN KEY (c_ID) REFERENCES Clinic(clinic_id));

CREATE TABLE Prescription(
    issued_at DATETIME NOT NULL,
    notes VARCHAR(500),
    prescription_id INT PRIMARY KEY,
    p_ID INT NOT NULL,
    d_ID INT NOT NULL,
    appt_ID INT NOT NULL,
    FOREIGN KEY (p_ID) REFERENCES Patient(patient_id),
    FOREIGN KEY (d_ID) REFERENCES Doctor(doctor_id),
    FOREIGN KEY (appt_ID) REFERENCES Appointment(appointment_id));

    CREATE TABLE Medicine(
    name VARCHAR(200) NOT NULL,
    form VARCHAR(50) NOT NULL,
    strength VARCHAR(50) NOT NULL,
    is_controlled BIT, -- In SQL server the data type 'BOOLEAN' is invalid, 'BIT' is replaced (0=FALSE, 1=TRUE)
    medicine_id INT PRIMARY KEY);

CREATE TABLE PrescriptionItem(
    dosage VARCHAR(100),
    frequency VARCHAR(100),
    duration_days INT,
    instructions VARCHAR(300),
    prescr_ID INT NOT NULL,
    m_ID INT NOT NULL,
    FOREIGN KEY (prescr_ID) REFERENCES Prescription(prescription_id),
    FOREIGN KEY (m_ID) REFERENCES Medicine(medicine_id),
    PRIMARY KEY (prescr_ID, m_ID));

CREATE TABLE Inventory(
    quantity INT NOT NULL,
    reorder_level INT,
    last_updated DATETIME,
    inventory_id INT,
    c_ID INT NOT NULL,
    m_ID INT NOT NULL,
    PRIMARY KEY (inventory_id),
    FOREIGN KEY (c_ID) REFERENCES Clinic(clinic_id),
    FOREIGN KEY (m_ID) REFERENCES Medicine(medicine_id));

CREATE TABLE Invoice(
    total_amount DECIMAL(10,2) NOT NULL,
    paid_amount DECIMAL(10,2) NOT NULL,
    status VARCHAR(20),
    issued_at DATETIME NOT NULL,
    invoice_id INT PRIMARY KEY,
    c_ID INT NOT NULL,
    p_ID INT NOT NULL,
    appt_ID INT NOT NULL,
    FOREIGN KEY (c_ID) REFERENCES Clinic(clinic_id),
    FOREIGN KEY (p_ID) REFERENCES Patient(patient_id),
    FOREIGN KEY (appt_ID) REFERENCES Appointment(appointment_id));

CREATE TABLE InvoiceItem(
    description VARCHAR(300),
    amount DECIMAL(10,2) NOT NULL,
    invoice_item_id INT PRIMARY KEY,
    inv_ID INT NOT NULL,
    FOREIGN KEY (inv_ID) REFERENCES Invoice(invoice_id) );

CREATE TABLE Role(
    role_id INT PRIMARY KEY,
    role_name VARCHAR(50) NOT NULL);

CREATE TABLE Users( -- ‘User’ is a reserved keyword in SQL server, so it was renamed to ‘Users’ to avoid syntax errors.
    username VARCHAR(90) UNIQUE NOT NULL,
    password_hash VARCHAR(200) NOT NULL,
    person_type VARCHAR(10) NOT NULL CHECK (person_type IN ('PATIENT' , 'DOCTOR' , 'STAFF')),
    person_id INT NOT NULL,
    user_id INT PRIMARY KEY,
    role_ID INT NOT NULL,
    FOREIGN KEY (role_ID) REFERENCES Role(role_id));

CREATE TABLE Permission(
    code VARCHAR(50) UNIQUE NOT NULL,
    description VARCHAR(300), 
    permission_id INT PRIMARY KEY);

CREATE TABLE RolePermission(
    role_ID INT NOT NULL,
    perm_ID INT NOT NULL,
    PRIMARY KEY (role_ID, perm_ID),
    FOREIGN KEY (role_ID) REFERENCES Role(role_id),
    FOREIGN KEY (perm_ID) REFERENCES Permission(permission_id));

INSERT INTO Clinic(name, city, address, phone, clinic_id) VALUES 
('Al Noor Clinic', 'Makkah', '73 Main Blvd', '05512345678', 101),
('Salam Clinic', 'Riyadh', '122 King St', '0554328765', 102),
('Najd Health Center', 'Jeddah', '67 Health St', '0551357911', 103),
('Dar Al Seha Clinic', 'Riyadh', '33 Hope Ave', '0556644887', 104),
('Al Shifa Center', 'Madinah', '92 Al Waha Lane', '0556325872', 105),
('Al Amal Clinic', 'Jeddah', '333 Safinah Rd', '0559878688', 106),
('Wellness Center', 'Riyadh', '118 Janan Rd', '0555347156', 107),
('Al Ishraq Clinic', 'Dammam', '433 Al Badar St', '0551174761', 108),
('Hayat Clinic', 'Jeddah', '51 Al Bahar Rd', '0558842989', 109),
('Al Naseem Center', 'Dammam', '87 Al Matar Rd', '0556112865', 110);

INSERT INTO Doctor(full_name, specialty, phone, email, doctor_id, c_ID) VALUES
('Dr. Ahmed Al-Tamimi', 'Cardiology', '0553220690', 'ahmed.alsaud@example.com', 201, 101),
('Dr. Sara Al-Harbi', 'Dermatology', '0552975678', 'sara.alharbi@example.com', 202, 102),
('Dr. Khalid Al-Fahad', 'Neurology', '0553656789', 'khalid.alfahad@example.com', 203, 103),
('Dr. Laila Alsaleh', 'Internal Medicine', '0554597490', 'laila.alsaleh@example.com', 204, 104),
('Dr. Mohammed Al-Rashid', 'Orthopedics', '0555271901', 'mohammed.alrashid@example.com', 205, 105),
('Dr. Aisha Al-Zahrani', 'Gynecology', '0556749012', 'aisha.alzahrani@example.com', 206, 106),
('Dr. Faisal Al-Fahad', 'ENT', '0557890143', 'faisal.alfahad@example.com', 207, 107),
('Dr. Hana Al-Amri', 'Ophthalmology', '0557501214', 'hana.alamri@example.com', 208, 108),
('Dr. Nasser Al-Qahtani', 'Internal Medicine', '0558574439', 'nasser.alqahtani@example.com', 209, 109),
('Dr. Reem Al-Harbi', 'Dentistry', '0550786743', 'reem.alharbi@example.com', 210, 110),
('Dr. Fatimah Al-Shehri', 'Dermatology', '0559876543', 'fatimah.alshehri@example.com', 211, 101),
('Dr. Khalid Al-Harbi', 'Pediatrics', '0551234567', 'khalid.alharbi@example.com', 212, 101);

INSERT INTO Patient(full_name, dob, gender, phone, email, patient_id, d_ID, c_ID) VALUES
('Mariam Al-Musa','2003-11-07', 'Female', '0556632980', 'mariam.almusa@example.com', 301, 201, 101),
('Fahad Al-Mutairi', '1985-03-15', 'Male', '0551342334', 'fahad.mutairi@example.com', 302, 202, 102),
('Nora Alkhaled', '1990-07-22', 'Female', '0552549445', 'nora.alkhaled@example.com', 303, 203, 103),
('Omar Al-Fahad', '1956-12-01', 'Male', '0559304750', 'omar.alfahad@example.com', 304, 204, 104),
('Huda Al-Qahtani', '1995-05-30', 'Female', '0554455667', 'huda.alqahtani@example.com', 305, 205, 105),
('Youssef Ahmad', '1997-09-17', 'Male', '0555566778', 'youssef.ahmad@example.com', 306, 206, 106),
('Mona Al-Zahrani', '1999-11-11', 'Female', '0556677889', 'mona.alzahrani@example.com', 307, 207, 107),
('Fahad Al-Ghamdi', '2001-02-20', 'Male', '0557788990', 'fahad.alghamdi@example.com', 308, 208, 108),
('Dana Al-Rashid', '1986-08-08', 'Female', '0558899001', 'dana.alrashidi@example.com', 309, 209, 109),
('Khaled Al-Qahtani', '1978-01-05', 'Male', '0559900112', 'khaled.alqahtani@example.com', 310, 210, 110);

INSERT INTO DoctorSchedule(day_of_week, start_time, end_time, schedule_id, d_ID, c_ID) VALUES
('Sunday', '09:00', '16:00', 401, 201, 101),
('Monday', '10:00', '17:00', 402, 202, 102),
('Tuesday', '08:00', '15:00', 403, 203, 103),
('Wednesday', '12:00', '19:00', 404, 204, 104),
('Thursday', '08:00', '15:00', 405, 205, 105),
('Sunday', '12:00', '19:00', 406, 206, 106),
('Monday', '08:00', '15:00', 407, 207, 107),
('Tuesday', '11:00', '18:00', 408, 208, 108),
('Wednesday', '14:00', '21:00', 409, 209, 109),
('Thursday', '08:00', '15:00', 410, 210, 110);

INSERT INTO Appointment(start_time, end_time, status, reason, appointment_id, p_ID, d_ID, c_ID) VALUES
('2025-11-17 09:00', '2025-11-17 09:40', 'Cancelled', 'Routine checkup', 501, 301, 201, 101),
('2025-11-18 10:00', '2025-11-18 10:30', 'Completed', 'Skin rash', 502, 302, 202, 102),
('2025-11-19 11:00', '2025-11-19 11:30', 'Completed', 'Headache', 503, 303, 203, 103),
('2025-11-20 12:00', '2025-11-20 13:00', 'Completed', 'Hypertension follow-up', 504, 304, 204, 104), 
('2025-11-21 13:00', '2025-11-21 13:35', 'Cancelled', 'Knee pain', 505, 305, 205, 105),
('2025-11-22 14:00', '2025-11-22 14:40', 'Completed', 'Pregnancy check', 506, 306, 206, 106),
('2025-11-23 09:00', '2025-11-23 09:30', 'Completed', 'Routine check', 511, 301, 201, 101),
('2025-11-23 15:00', '2025-11-23 15:30', 'Completed', 'Ear infection', 507, 307, 207, 107),
('2025-11-24 09:00', '2025-11-24 09:35', 'Completed', 'Migraine follow-up', 514, 303, 203, 103),
('2025-11-24 16:00', '2025-11-24 16:30', 'Completed', 'Eye check', 508, 308, 208, 108),
('2025-11-25 09:30', '2025-11-25 10:30', 'Completed', 'Diabetes follow-up', 509, 309, 209, 109),
('2025-11-26 10:30', '2025-11-26 11:00', 'Cancelled', 'Dental cleaning', 510, 310, 210, 110),
('2025-11-26 10:00', '2025-11-26 10:30', 'Completed', 'Follow-up visit', 512, 301, 201, 101),
('2025-12-10 10:00', '2025-11-29 10:30', 'Scheduled', 'Lab results review', 515, 303, 203, 103),
('2025-12-10 11:00', '2025-12-10 11:30', 'Scheduled', 'Dermatology follow-up', 513, 302, 202, 102);

INSERT INTO Prescription(issued_at, notes, prescription_id, p_ID, d_ID, appt_ID) VALUES
('2025-11-17 09:30', 'Increase water intake and take vitamin supplement.', 601, 301, 201, 501),
('2025-11-18 10:45', 'Avoid scented soaps and apply cream twice daily.', 602, 302, 202, 502),
('2025-11-19 11:30', 'Recommend hydration, rest, and analgesic as prescribed.', 603, 303, 203, 503),
('2025-11-20 12:30', 'Take medication as instructed', 604, 304, 204, 504), 
('2025-11-21 13:30', 'Prescribed pain relief and advised cold compress twice daily.', 605, 305, 205, 505),
('2025-11-22 14:30', 'Continue prenatal vitamins and hydration.', 606, 306, 206, 506),
('2025-11-23 15:30', 'Prescribed antibiotic ear drops', 607, 307, 207, 507),
('2025-11-24 16:30', 'Prescribed eye drops', 608, 308, 208, 508),
('2025-11-25 10:00', 'Continue current medication and diet plan.',609,  309, 209, 509),
('2025-11-26 11:00', 'Recommend brushing twice daily and flossing.', 610, 310, 210, 510);

INSERT INTO Medicine(name, form, strength, is_controlled, medicine_id) VALUES
('Ibuprofen', 'Tablet', '200mg', 0, 701),
('Vitamin D', 'Tablet', '1000IU', 0, 702),
('Cream I', 'Ointment', '20g', 0, 703),
('Ear Drops', 'Liquid', '5ml', 0, 704),
('Eye Drops', 'Liquid', '10ml', 0, 705),
('Dental Paste', 'Gel', '50g', 0, 706),
('Insulin', 'Injection', '10ml', 1, 707),
('paracetamol', 'Tablet', '500mg', 0, 708),
('prednisolone', 'Tablet', '5mg', 1, 709), 
('carvedilol', 'Tablet', '3.125mg', 0, 710);

INSERT INTO PrescriptionItem(prescr_ID, m_ID, dosage, frequency, duration_days, instructions) VALUES
(601, 702, '1 tablet', 'once daily', 60, 'Take with the main meal'),
(602, 703, '1g', 'twice daily', 7, 'Apply on affected area'),
(603, 708, '1 tablet', 'twice daily', 5, 'Take during headaches'),
(604, 710, '1 tablet', 'once daily', 30, 'Take in the morning'),
(605, 701, '1 tablet', 'twice daily', 7, 'After meal when feeling pain'),
(606, 702, '1 tablet', 'once daily', 60, 'Take with breakfast'),
(607, 704, '5 drops', '3 times daily', 5, 'Insert into ear'),
(608, 705, '2 drops', 'twice daily', 10, 'Use in eye'),
(609, 707, '5 units', 'twice daily', 30, 'Inject under skin before meals'),
(610, 706, 'As needed', 'twice daily', 7, 'Use after brushing teeth');


INSERT INTO Inventory(quantity, reorder_level, last_updated, inventory_id, c_ID, m_ID) VALUES
(100, 20, '2025-12-03', 801, 101, 701),
(20, 50, '2025-12-03', 802, 102, 702),
(30, 50, '2025-12-03', 803, 103, 703),
(15, 30, '2025-12-03', 804, 104, 704),
(75, 55, '2025-12-03', 805, 105, 705),
(20, 50, '2025-12-03', 806, 106, 706),
(80, 40, '2025-12-03', 807, 107, 707),
(90, 25, '2025-12-03', 808, 108, 708),
(120, 30, '2025-12-03', 809, 109, 709),
(40, 10, '2025-12-03', 810, 110, 710);


INSERT INTO Invoice(total_amount, paid_amount, status, issued_at, invoice_id, c_ID, p_ID, appt_ID) VALUES
(175.00, 175.00, 'Paid', '2025-11-17', 901, 101, 301, 501),
(140.00, 0.00, 'Paid', '2025-11-18', 902, 102, 302, 502),
(170.00, 170.00, 'Paid', '2025-11-19', 903, 103, 303, 503),
(300.00, 300.00, 'Pending', '2025-11-20', 904, 104, 304, 504),
(250.00, 250.00, 'Paid', '2025-11-21', 905, 105, 305, 505),
(250.00, 0.00, 'Pending', '2025-11-22', 906, 106, 306, 506),
(160.00, 0.00, 'Pending', '2025-11-23', 907, 107, 307, 507),
(180.00, 180.00, 'Paid', '2025-11-24', 908, 108, 308, 508),
(200.00, 200.00, 'Paid', '2025-11-25', 909, 109, 309, 509),
(190.00, 190.00, 'Paid', '2025-11-26', 910, 110, 310, 510);

INSERT INTO InvoiceItem (description, amount, invoice_item_id, inv_ID) VALUES
('Consultation Fee', 50.00, 1001, 901),
('Medication', 50.00, 1002, 901),
('Consultation Fee', 50.00, 1003, 902),
('Medication', 0.00, 1004, 902),
('Consultation Fee', 100.00, 1005, 903),
('Medication', 100.00, 1006, 903),
('Consultation Fee', 75.00, 1007, 904),
('Medication', 0.00, 1008, 904),
('Consultation Fee', 60.00, 1009, 905),
('Consultation Fee', 70.00, 1010, 910);

INSERT INTO Role (role_id, role_name) VALUES
(11, 'Admin'),
(12, 'Doctor'),
(13, 'Nurse'),
(14, 'Receptionist'),
(15, 'Pharmacist'),
(16, 'Lab Technician'),
(17, 'Accountant'),
(18, 'Manager'),
(19, 'IT Support'),
(20, 'Patient');

INSERT INTO Users (user_id, username, password_hash, person_type, person_id, role_ID) VALUES
(110, 'ad_khaled', 'bx12f9', 'STAFF', 111, 11),
(120, 'dr_ahmed', 'ar92x1', 'DOCTOR', 201, 12),
(130, 'dr_sara', 'pb77k3', 'DOCTOR', 202, 12),
(140, 'mariam03_', 'sc88p4', 'PATIENT', 301, 20),
(150, 'fahad_m21', 'b567ab', 'PATIENT', 302, 20),
(160, 'nrs_mona', 'its9b1', 'STAFF', 333, 13),
(170, 'acct_anwar', 'usr5q7', 'STAFF', 777, 17),
(180, 'pharm_amal', 'a678xd', 'STAFF', 555, 15),
(190, 'recpst_reem', 'rcp4v8', 'STAFF', 444, 14),
(200, 'it_support', 'phr6t9', 'STAFF', 999, 19);

INSERT INTO Permission (permission_id, code, description) VALUES
(1, 'VIEW_APPOINTMENTS', 'Shows appointments'),
(2, 'EDIT_APPOINTMENTS', 'Can edit appointments'),
(3, 'VIEW_PATIENTS', 'View patient info'),
(4, 'EDIT_PATIENTS', 'Can edit patient info'),
(5, 'VIEW_BILLING', 'View billing records'),
(6, 'EDIT_BILLING', 'Can edit billing records'),
(7, 'VIEW_INVENTORY', 'Can view inventory'),
(8, 'EDIT_INVENTORY', 'Can edit inventory'),
(9, 'MANAGE_USERS', 'To create or edit users'),
(10, 'MANAGE_ROLES', 'To manage roles and permissions');

INSERT INTO RolePermission (role_ID, perm_ID) VALUES
(11, 1),(11, 2),(11, 3),(11, 4),(11, 5),(11, 6),(11, 7),(11, 8),(11, 9),(11, 10),
(12, 1),(12, 3),(12, 7),
(13, 1),(13, 2),(13, 9),
(14, 1),(14, 2),
(15, 7),(15, 8),
(16, 3),
(17, 5),(17, 6),
(18, 1),
(19, 1),(19, 3),(19, 5),
(20, 1);
-- listing the patients with more than two appointments in the last month
SELECT 
    p.full_name,
    p.phone,
    p.email,
    COUNT(a.appointment_id) AS appointment_count
FROM Patient p
JOIN Appointment a 
    ON p.patient_id = a.p_ID
WHERE a.start_time >= DATEADD(MONTH, -1, GETDATE())
GROUP BY p.full_name, p.phone, p.email
HAVING COUNT(a.appointment_id) > 2;

SELECT 
    d.full_name AS doctor_name,
    d.specialty,
    d.phone,
    d.email
FROM Doctor d
JOIN Clinic c ON d.c_ID = c.clinic_id
WHERE c.name = 'Al Noor Clinic'
ORDER BY d.specialty, d.full_name;

SELECT 
    p.prescription_id,
    p.issued_at,
    p.notes,
    p.p_ID AS patient_id,
    pat.full_name AS patient_name,
    p.d_ID AS doctor_id,
    d.full_name AS doctor_name,
    p.appt_ID AS appointment_id
FROM Prescription p
JOIN Doctor d ON p.d_ID = d.doctor_id
JOIN Patient pat ON p.p_ID = pat.patient_id
WHERE p.d_ID = 204
  AND p.issued_at BETWEEN '2025-11-01' AND '2025-11-30';

SELECT 
    c.name AS clinic_name,
    c.city,
    m.name AS medicine_name,
    i.quantity,
    i.reorder_level
FROM Inventory i
JOIN Clinic c ON i.c_ID = c.clinic_id
JOIN Medicine m ON i.m_ID = m.medicine_id
WHERE i.quantity < i.reorder_level
ORDER BY c.name, m.name;

SELECT
    a.appointment_id,
    a.start_time,
    a.end_time,
    DATEDIFF(MINUTE, a.start_time, a.end_time) AS appointment_duration,
    p.full_name AS patient_name,
    d.full_name AS doctor_name,
    d.specialty,
    c.name AS clinic_name
FROM Appointment a
JOIN Patient p ON a.p_ID = p.patient_id
JOIN Doctor d ON a.d_ID = d.doctor_id
JOIN Clinic c ON a.c_ID = c.clinic_id
WHERE DATEDIFF(MINUTE, a.start_time, a.end_time) > 30
ORDER BY appointment_duration;

SELECT 
    cl.city,
    cl.name AS clinic_name,
    SUM(inv.total_amount) AS total_revenue
FROM Clinic cl
JOIN Invoice inv ON cl.clinic_id = inv.c_ID
GROUP BY cl.city, cl.name
ORDER BY cl.city, total_revenue;