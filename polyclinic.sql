CREATE DATABASE Polyclinic_PZ31;
GO
USE Polyclinic_PZ31;
GO

CREATE TABLE dbo.Specialties (
    SpecialtyID INT PRIMARY KEY,
    SpecialtyName NVARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE dbo.Doctors (
    DoctorID INT PRIMARY KEY,
    FullName NVARCHAR(100) NOT NULL,
    SpecialtyID INT NOT NULL,
    CONSTRAINT FK_Doctors_Specialties FOREIGN KEY (SpecialtyID)
        REFERENCES dbo.Specialties(SpecialtyID)
);

CREATE TABLE dbo.Patients (
    PatientID INT PRIMARY KEY,
    FullName NVARCHAR(100) NOT NULL,
    BirthDate DATE NOT NULL
);

CREATE TABLE dbo.Diagnoses (
    DiagnosisID INT PRIMARY KEY,
    DiagnosisName NVARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE dbo.Appointments (
    AppointmentID INT PRIMARY KEY,
    PatientID INT NOT NULL,
    DoctorID INT NOT NULL,
    DiagnosisID INT NOT NULL,
    AppointmentDate DATETIME2(0) NOT NULL,
    CONSTRAINT FK_Appointments_Patients FOREIGN KEY (PatientID)
        REFERENCES dbo.Patients(PatientID),
    CONSTRAINT FK_Appointments_Doctors FOREIGN KEY (DoctorID)
        REFERENCES dbo.Doctors(DoctorID),
    CONSTRAINT FK_Appointments_Diagnoses FOREIGN KEY (DiagnosisID)
        REFERENCES dbo.Diagnoses(DiagnosisID)
);

INSERT INTO dbo.Specialties (SpecialtyID, SpecialtyName) VALUES
(1, N'Терапевт'),
(2, N'Хирург'),
(3, N'Невролог'),
(4, N'Офтальмолог'),
(5, N'Кардиолог');

INSERT INTO dbo.Doctors (DoctorID, FullName, SpecialtyID) VALUES
(1, N'Иванов Иван Иванович', 1),
(2, N'Петров Пётр Петрович', 2),
(3, N'Сидорова Анна Олеговна', 3),
(4, N'Смирнова Ольга Игоревна', 4),
(5, N'Кузнецов Павел Андреевич', 5);

INSERT INTO dbo.Patients (PatientID, FullName, BirthDate) VALUES
(1, N'Волков Алексей Сергеевич', '20000312'),
(2, N'Орлова Мария Ивановна', '19950720'),
(3, N'Зайцев Олег Петрович', '19881105'),
(4, N'Белова Елена Андреевна', '20010214'),
(5, N'Соколов Дмитрий Олегович', '19930909');

INSERT INTO dbo.Diagnoses (DiagnosisID, DiagnosisName) VALUES
(1, N'ОРВИ'),
(2, N'Ушиб'),
(3, N'Мигрень'),
(4, N'Близорукость'),
(5, N'Гипертония');

INSERT INTO dbo.Appointments
    (AppointmentID, PatientID, DoctorID, DiagnosisID, AppointmentDate)
VALUES
(1, 1, 1, 1, '2026-11-10T09:00:00'),
(2, 2, 2, 2, '2026-11-10T10:00:00'),
(3, 3, 3, 3, '2026-11-11T11:00:00'),
(4, 1, 1, 1, '2026-11-12T09:00:00'),
(5, 4, 4, 4, '2026-11-12T12:00:00');

SELECT p.FullName AS Patient, a.AppointmentDate
FROM dbo.Patients AS p
LEFT JOIN dbo.Appointments AS a ON p.PatientID = a.PatientID
ORDER BY p.PatientID, a.AppointmentDate;

SELECT d.FullName AS Doctor, a.AppointmentDate
FROM dbo.Appointments AS a
RIGHT JOIN dbo.Doctors AS d ON a.DoctorID = d.DoctorID
ORDER BY d.DoctorID, a.AppointmentDate;

SELECT a.AppointmentID, p.FullName AS Patient, d.FullName AS Doctor,
       s.SpecialtyName, a.AppointmentDate, dg.DiagnosisName
FROM dbo.Appointments AS a
INNER JOIN dbo.Patients AS p ON a.PatientID = p.PatientID
INNER JOIN dbo.Doctors AS d ON a.DoctorID = d.DoctorID
INNER JOIN dbo.Specialties AS s ON d.SpecialtyID = s.SpecialtyID
INNER JOIN dbo.Diagnoses AS dg ON a.DiagnosisID = dg.DiagnosisID
ORDER BY a.AppointmentID;

SET XACT_ABORT ON;
BEGIN TRANSACTION;

ALTER TABLE dbo.Appointments
NOCHECK CONSTRAINT FK_Appointments_Patients;

UPDATE dbo.Appointments
SET PatientID = 999
WHERE AppointmentID = 5;

SELECT a.AppointmentID, a.PatientID
FROM dbo.Appointments AS a
LEFT JOIN dbo.Patients AS p ON a.PatientID = p.PatientID
WHERE p.PatientID IS NULL;

SELECT a.AppointmentID, a.PatientID
FROM dbo.Patients AS p
RIGHT JOIN dbo.Appointments AS a ON p.PatientID = a.PatientID
WHERE p.PatientID IS NULL;

UPDATE dbo.Appointments
SET PatientID = 4
WHERE AppointmentID = 5;

ALTER TABLE dbo.Appointments
WITH CHECK CHECK CONSTRAINT FK_Appointments_Patients;

COMMIT TRANSACTION;

SELECT a.AppointmentID, a.PatientID
FROM dbo.Appointments AS a
LEFT JOIN dbo.Patients AS p ON a.PatientID = p.PatientID
WHERE p.PatientID IS NULL;
