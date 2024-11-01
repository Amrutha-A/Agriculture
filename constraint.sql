use dbms;

ALTER TABLE Farmer
ADD CONSTRAINT unique_farmer_credentials UNIQUE (FarmerName, VillageID, PasswordHash);
