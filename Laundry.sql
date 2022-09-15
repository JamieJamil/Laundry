USE Master
GO
IF DB_ID('BBB_Jami1379') IS NOT NULL
	BEGIN
		ALTER DATABASE BBB_Jami1379 SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
		DROP DATABASE BBB_Jami1379
	END
GO
CREATE DATABASE BBB_Jami1379
GO
USE BBB_Jami1379
GO

DROP TABLE IF EXISTS Laundry
CREATE TABLE Laundry(
ID INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
ShopName NVARCHAR(100),
OpeningTime TIME,
ClosingTime TIME
)

DROP TABLE IF EXISTS LaundryUser
CREATE TABLE LaundryUser(
UserID INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
Username NVARCHAR(100),
Email NVARCHAR(100) UNIQUE,
UserPassword NVARCHAR(100),
Account DECIMAL,
LaundryID INT NOT NULL,
AccountDate DATE,
CONSTRAINT FK_LaundryUserID FOREIGN KEY (LaundryID) REFERENCES Laundry(ID),
CONSTRAINT [Password_Length] CHECK (LEN(UserPassword) >= 5)
)

DROP TABLE IF EXISTS Machines
CREATE TABLE Machines(
Machines_ID INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
MachineName NVARCHAR(100),
Price DECIMAL(10,2),
TimeInMinutes INT,
LaundryID INT,
CONSTRAINT FK_LaundryID FOREIGN KEY (LaundryID) REFERENCES Laundry(ID),
)

DROP TABLE IF EXISTS Bookings
CREATE TABLE Bookings(
Booking_ID INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
BookingDate DATETIME,
UserID INT NOT NULL,
MachineID INT NOT NULL,
CONSTRAINT FK_UserID FOREIGN KEY (UserID) REFERENCES LaundryUser(UserID),
CONSTRAINT FK_MachineID FOREIGN KEY (MachineID) REFERENCES Machines(Machines_ID)
)

INSERT INTO Laundry (ShopName, OpeningTime, ClosingTime) VALUES ('Whitewash Inc.', '08:00', '20:00')
INSERT INTO Laundry (ShopName, OpeningTime, ClosingTime) VALUES ('Double Bubble', '02:00', '22:00')
INSERT INTO Laundry (ShopName, OpeningTime, ClosingTime) VALUES ('Wash & Coffee', '12:00', '20:00')

INSERT INTO LaundryUser (Username, Email, UserPassword, Account, LaundryID, AccountDate) VALUES ('John', 'john_doe66@gmail.com', 'password', 100.00, 2, '2021-02-15')
INSERT INTO LaundryUser (Username, Email, UserPassword, Account, LaundryID, AccountDate) VALUES ('Nel Armstrong', 'firstman@nasa.gov', 'eagleLander69', 1000.00, 1, '2021-02-10')
INSERT INTO LaundryUser (Username, Email, UserPassword, Account, LaundryID, AccountDate) VALUES ('Batman', 'noreply@thecave.com', 'Rob1n', 500.00, 3, '2020-03-10')
INSERT INTO LaundryUser (Username, Email, UserPassword, Account, LaundryID, AccountDate) VALUES ('Goldman Sachs', 'moneylaundering@gs.com', 'NotReconized', 100000.00, 1, '2021-01-01')
INSERT INTO LaundryUser (Username, Email, UserPassword, Account, LaundryID, AccountDate) VALUES ('50 Cent', '50cent@gmail.com', 'ItsMyBirthday', 00.50, 3, '2020-07-06')

INSERT INTO Machines (MachineName, Price, TimeInMinutes) VALUES ('Mielle 911 Turbo', 5.00, 60)
INSERT INTO Machines (MachineName, Price, TimeInMinutes) VALUES ('Siemons IClean', 10000.00, 30)
INSERT INTO Machines (MachineName, Price, TimeInMinutes) VALUES ('Electrolax FX-2', 15.00, 45)
INSERT INTO Machines (MachineName, Price, TimeInMinutes) VALUES ('NASA Spacewasher 8000', 500.00, 5)
INSERT INTO Machines (MachineName, Price, TimeInMinutes) VALUES ('The Lost Sock', 3.50, 90)
INSERT INTO Machines (MachineName, Price, TimeInMinutes) VALUES ('Yo Mama', 0.50, 120)

INSERT INTO Bookings (BookingDate, UserID, MachineID) VALUES ('2021-02-26 12:00',1,1)
INSERT INTO Bookings (BookingDate, UserID, MachineID) VALUES ('2021-02-26 16:00',1,3)
INSERT INTO Bookings (BookingDate, UserID, MachineID) VALUES ('2021-02-26 08:00',2,4)
INSERT INTO Bookings (BookingDate, UserID, MachineID) VALUES ('2021-02-26 15:00',3,5)
INSERT INTO Bookings (BookingDate, UserID, MachineID) VALUES ('2021-02-26 20:00',4,2)
INSERT INTO Bookings (BookingDate, UserID, MachineID) VALUES ('2021-02-26 19:00',4,2)
INSERT INTO Bookings (BookingDate, UserID, MachineID) VALUES ('2021-02-26 10:00',4,2)
INSERT INTO Bookings (BookingDate, UserID, MachineID) VALUES ('2021-02-26 16:00',5,6)


-- Transaction
BEGIN TRAN T1
INSERT INTO Bookings (BookingDate, UserID, MachineID) VALUES ('2022-09-15 12:00:00',4,2) 
COMMIT


-- VIEW
GO
CREATE VIEW BookingView AS
	SELECT BookingDate, LaundryUser.Username, Machines.MachineName, Machines.Price FROM Bookings
	JOIN LaundryUser ON Bookings.UserID = LaundryUser.UserID
	JOIN Machines ON Bookings.MachineID = Machines.Machines_ID
GO
SELECT * FROM BookingView


-- A)
SELECT * FROM LaundryUser WHERE Email like '%@gmail.com%'

-- B)
SELECT MachineName AS [Machine Name], 
	Price AS [Price per wash], 
	TimeInMinutes AS [Washing  Time(Minutes)], 
	Laundry.ShopName AS [Laundry Name], 
	Laundry.OpeningTime AS [Opening Time],
	Laundry.ClosingTime AS [Closing Time] FROM Machines
JOIN Laundry ON Machines.Machines_ID = Laundry.ID

-- C)
SELECT Machines.MachineName, COUNT(Booking_ID) AS [Usage] FROM Bookings
JOIN Machines ON Bookings.MachineID = Machines.Machines_ID GROUP BY MachineName 

-- D)
DELETE FROM Bookings WHERE CAST(BookingDate AS TIME) BETWEEN '12:00' AND '13:00'

-- E)
UPDATE LaundryUser SET UserPassword = 'SelinaKyle' WHERE UserPassword like '%Rob1n%' AND Email like '%noreply@thecave.com%'