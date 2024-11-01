-- Insert into Village
INSERT INTO Village (VillageName, District, SoilType) VALUES
('Sangrur', 'Punjab', 'Loamy'),
('Jodhpur', 'Rajasthan', 'Sandy'),
('Kolar', 'Karnataka', 'Clay'),
('Bhubaneswar', 'Odisha', 'Alluvial'),
('Aligarh', 'Uttar Pradesh', 'Loamy');

-- Insert into Crop
INSERT INTO Crop (CropName, CropType, IdealSeason) VALUES
('Wheat', 'Cereal', 'Winter'),
('Rice', 'Cereal', 'Summer'),
('Sugarcane', 'Cash Crop', 'Monsoon'),
('Pulses', 'Pulse', 'Winter'),
('Cotton', 'Cash Crop', 'Summer');

-- Insert into MarketPrice
INSERT INTO MarketPrice (CropID, Year, PricePerUnit) VALUES
(1, 2023, 25.50),  -- Wheat
(2, 2023, 30.00),  -- Rice
(3, 2023, 40.00),  -- Sugarcane
(4, 2023, 20.00),  -- Pulses
(5, 2023, 35.00);  -- Cotton

-- Insert into CropSuggestion
INSERT INTO CropSuggestion (VillageID, CropID, SuggestedYear, Reason) VALUES
(1, 2, 2024, 'Rice is recommended in Sangrur due to high demand and market value.'),
(2, 3, 2024, 'Sugarcane is a profitable option for Jodhpur given the soil type and climate.'),
(3, 5, 2024, 'Cotton is suitable for Kolar as it aligns with the summer season and soil type.'),
(4, 1, 2024, 'Wheat can be a good option in Bhubaneswar due to favorable weather conditions.'),
(5, 4, 2024, 'Pulses are recommended for Aligarh to maintain soil fertility and ensure a good yield.');
