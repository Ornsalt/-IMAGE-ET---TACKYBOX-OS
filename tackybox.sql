USE db;
-- Table Images doesn't need timestamp (Time is important when something happen, cf logs)
CREATE TABLE Images (
    Uid varchar(255),
    Name varchar(255),
    Birthday varchar(255),
    Type varchar(255),
    SOPInstanceUID varchar(255),
    Status varchar(255)
);

-- Contain logs about reception, sending, and errors in case of rsync failure
CREATE TABLE Logs (
    EventTime datetime,
    Type varchar(255), -- INFO, WARN, or ERR
    Message text
);