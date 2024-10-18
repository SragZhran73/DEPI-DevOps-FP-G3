CREATE TABLE [Hotel] (
    [HotelID] uniqueidentifier DEFAULT NEWID() PRIMARY KEY,
    [Chief] VARCHAR(255),
    [Name] VARCHAR(255),
    [Location] VARCHAR(255),
    [Rating] INT,
    [Facilities] VARCHAR(255)
);


