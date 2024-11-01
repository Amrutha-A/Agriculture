use dbms;

-- Creating Village table
CREATE TABLE Village (
    VillageID INT AUTO_INCREMENT PRIMARY KEY,
    VillageName VARCHAR(100) NOT NULL
);

-- Creating Farmer table with unique constraint and phone number
CREATE TABLE Farmer (
    FarmerID INT AUTO_INCREMENT PRIMARY KEY,
    FarmerName VARCHAR(100) NOT NULL,
    VillageID INT NOT NULL,
    PasswordHash VARCHAR(255) NOT NULL,
    PhoneNo VARCHAR(15) NOT NULL,
    
    -- Ensuring no duplicate farmers based on name, village, and phone number
    CONSTRAINT unique_farmer UNIQUE (FarmerName, VillageID, PhoneNo),
    
    -- Ensuring phone number is unique across all farmers
    CONSTRAINT unique_phone UNIQUE (PhoneNo),

    -- Foreign key with DELETE CASCADE on Village
    FOREIGN KEY (VillageID) REFERENCES Village(VillageID) ON DELETE CASCADE
);

-- Creating the Crop table
CREATE TABLE Crop (
    CropID INT AUTO_INCREMENT PRIMARY KEY,
    CropName VARCHAR(100) NOT NULL
);

-- Creating the FarmerCrop table with DELETE CASCADE
CREATE TABLE FarmerCrop (
    FarmerCropID INT AUTO_INCREMENT PRIMARY KEY,
    FarmerID INT NOT NULL,
    CropID INT NOT NULL,
    Acreage DECIMAL(10, 2) NOT NULL,
    
    -- Foreign key 
    FOREIGN KEY (FarmerID) REFERENCES Farmer(FarmerID) ON DELETE CASCADE,
    
    -- Foreign key 
    FOREIGN KEY (CropID) REFERENCES Crop(CropID) ON DELETE CASCADE
);



-- Creating a table to login farmer registrations with DELETE CASCADE
CREATE TABLE IF NOT EXISTS FarmerRegistrationLog (
    LogID INT AUTO_INCREMENT PRIMARY KEY,
    FarmerID INT NOT NULL,
    RegisteredAt DATETIME NOT NULL,
    -- Foreign key 
    FOREIGN KEY (FarmerID) REFERENCES Farmer(FarmerID) ON DELETE CASCADE
);

INSERT INTO Village (VillageName) VALUES
('Pune'),
('Nagpur'),
('Ahmednagar'),
('Nashik'),
('Aurangabad');

INSERT INTO Crop (CropName) VALUES
('Wheat'),
('Rice'),
('Sugarcane'),
('Cotton'),
('Maize');


-- Trigger to login farmer registration or updates
DELIMITER //
CREATE TRIGGER log_farmer_registration
AFTER INSERT ON Farmer
FOR EACH ROW
BEGIN
    INSERT INTO FarmerRegistrationLog (FarmerID, RegisteredAt)
    VALUES (NEW.FarmerID, NOW());
END //
DELIMITER ;

