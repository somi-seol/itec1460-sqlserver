CREATE TABLE Authors ( 
    AuthorID INT PRIMARY KEY, 
    FirstName VARCHAR(50), 
    LastName VARCHAR(50), 
    BirthDate DATE 
);

CREATE TABLE Books ( 
    BookID INT PRIMARY KEY, 
    Title VARCHAR(100), 
    AuthorID INT, 
    PublicationYear INT, 
    Price DECIMAL(10,2), 
    FOREIGN KEY (AuthorID) REFERENCES Authors(AuthorID) 
);

-- Insert data into Authors table
INSERT INTO Authors (AuthorID, FirstName, LastName, BirthDate) 
VALUES 
(1, 'Jane', 'Austen', '1775-12-16'), 
(2, 'George', 'Orwell', '1903-06-25'), 
(3, 'J.K.', 'Rowling', '1965-07-31'), 
(4, 'Ernest', 'Hemingway', '1899-07-21'), 
(5, 'Virginia', 'Woolf', '1882-01-25');

-- Insert data into Books table
INSERT INTO Books (BookID, Title, AuthorID, PublicationYear, Price)
VALUES 
(1, 'Pride and Prejudice', 1, 1813, 12.99),
(2, '1984', 2, 1949, 10.99),
(3, 'Harry Potter and the Philosopher''s Stone', 3, 1997, 15.99),
(4, 'The Old Man and the Sea', 4, 1952, 11.99),
(5, 'To the Lighthouse', 5, 1927, 13.99);

CREATE VIEW BookDetails AS
SELECT 
    b.BookID,
    b.Title,
    a.FirstName + ' ' + a.LastName AS AuthorName,
    b.PublicationYear,
    b.Price
FROM 
    Books b
JOIN 
    Authors a ON b.AuthorID = a.AuthorID;

CREATE VIEW RecentBooks AS
SELECT 
    BookID, 
    Title, 
    PublicationYear, 
    Price 
FROM 
    Books 
WHERE 
    PublicationYear > 1990;

CREATE VIEW AuthorStats AS
SELECT 
    a.AuthorID,
    a.FirstName + ' ' + a.LastName AS AuthorName,
    COUNT(b.BookID) AS BookCount,
    AVG(b.Price) AS AverageBookPrice
FROM 
    Authors a
LEFT JOIN 
    Books b ON a.AuthorID = b.AuthorID
GROUP BY 
    a.AuthorID, a.FirstName, a.LastName;

-- a) Retrieve all records from the BookDetails view; test
SELECT Title, Price FROM BookDetails;

-- b) List all books from the RecentBooks view; test
SELECT * FROM RecentBooks;

-- c) Show statistics for authors; test
SELECT * FROM AuthorStats;

CREATE VIEW AuthorContactInfo AS
SELECT 
    AuthorID,
    FirstName,
    LastName
FROM 
    Authors;

UPDATE AuthorContactInfo
SET FirstName = 'Joanne'
WHERE AuthorID = 3;

SELECT * FROM AuthorContactInfo;

CREATE TABLE BookPriceAudit (
    AuditID INT IDENTITY(1,1) PRIMARY KEY,
    BookID INT,
    OldPrice DECIMAL(10,2),
    NewPrice DECIMAL(10,2),
    ChangeDate DATETIME DEFAULT GETDATE()
);

CREATE TRIGGER trg_BookPriceChange
ON Books
AFTER UPDATE
AS
BEGIN
    IF UPDATE(Price)
    BEGIN
        INSERT INTO BookPriceAudit (BookID, OldPrice, NewPrice)
        SELECT 
            i.BookID,
            d.Price,
            i.Price
        FROM inserted i
        JOIN deleted d ON i.BookID = d.BookID
    END
END;

-- Update a book's price; test trigger
UPDATE Books
SET Price = 14.99
WHERE BookID = 1;

-- Check the audit table; test trigger update
SELECT * FROM BookPriceAudit;

-- part 2

CREATE TABLE BookReviews ( 
    ReviewID INT PRIMARY KEY, 
    BookID INT, 
    CustomerID NCHAR(5), 
    Rating INT CHECK (Rating BETWEEN 1 AND 5), 
    ReviewText NVARCHAR(MAX), 
    ReviewDate DATE, 
    FOREIGN KEY (BookID) REFERENCES Books(BookID), 
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

CREATE VIEW vw_BookReviewStats AS 
SELECT 
    Books.Title AS BookTitle, 
    COUNT(BookReviews.ReviewID) AS TotalNumberofReviews, 
    AVG(BookReviews.Rating) AS AvgRating, 
    MAX(BookReviews.ReviewDate) AS MostRecentReviewDate 
FROM 
    Books 
JOIN  
    BookReviews ON Books.BookID = BookReviews.BookID 
GROUP BY 
    Books.BookID, Books.Title

CREATE TRIGGER tr_ValidateReviewDate 
ON BookReviews 
AFTER INSERT 
AS 
BEGIN 
    IF EXISTS (SELECT 1 FROM INSERTED WHERE ReviewDate > GETDATE()) 
    BEGIN 
        RAISERROR('ReviewDate cannot be in the future', 16, 1) -- severity + identifier
        ROLLBACK TRANSACTION 
    END 
END

-- add AvgRating column sperately?
ALTER TABLE Books 
ADD AvgRating DECIMAL(3,2)

-- trigger update when review added
CREATE TRIGGER tr_UpdateBookRating
ON BookReviews
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    -- Update the AverageRating for the affected book
    UPDATE Books
    SET AverageRating = (SELECT AVG(Rating) FROM BookReviews WHERE BookID = @BookID)
    WHERE BookID = @BookID --?
END

-- Insert 3 reviews
INSERT INTO BookReviews 
( 
    ReviewID, 
    BookID, 
    CustomerID, 
    Rating, 
    ReviewText, 
    ReviewDate 
) 
VALUES 
( 
    1, 1, 'A1', 5, 'Highly recommended.', '2025-02-20' 
), 
( 
    2, 2, 'A2', 4, 'Very informative.', '2025-02-18' 
), 
( 
    3, 3, 'A3', 3, 'Okay read.', '2025-02-19' 
), 
( 
    4, 1, 'BLONP', 2, 'Not what I expected, had issues.', '2025-03-01' -- future date
)

-- check query
SELECT * FROM BookReviews

-- update review rating
UPDATE BookReviews 
SET Rating = 5 
WHERE ReviewID = 1

-- check rating update
SELECT 
    BookID, 
    AVG(Rating) AS AvgRating 
FROM 
    BookReviews 
WHERE 
    BookID = 1 
GROUP BY 
    BookID