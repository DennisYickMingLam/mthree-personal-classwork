USE ConsumerComplaints;
GO

SELECT 
	DateReceived, 
	Product, 
	Company, 
	[State]
FROM 
	Complaint;

SELECT *
FROM Complaint;


-- Two dashes is a SQL comment. This line is ignored.
-- If your query has many columns, you may want to stack them for readability. 
-- Whitespace is ignored.
SELECT 
    DateReceived, 
    Product, 
    Issue, 
    Company
FROM Complaint
WHERE [State] = 'LA';

--use parenthesis to guarantee order of precedence
SELECT *
FROM Complaint
WHERE State = 'LA'
AND (Product = 'Mortgage' OR Product = 'Debt collection');

--without parenthesis we are returning complaints that are from LA and are the 
--product Mortgage or any Product that is Debt collection
SELECT *
FROM Complaint
WHERE State = 'LA'
AND Product = 'Mortgage' OR Product = 'Debt collection';


SELECT 
    Product, 
    Issue, 
    Company, 
    ResponseToConsumer
FROM Complaint
WHERE ConsumerDisputed = 1
AND ConsumerConsent = 1
AND Product NOT IN ('Mortgage', 'Debt collection');

-- Doesn't work.
SELECT *
FROM Complaint
WHERE SubProduct = NULL;

-- But neither does this!
SELECT *
FROM Complaint
WHERE SubProduct != NULL;

-- Doesn't complain, but doesn't find anything.
SELECT *
FROM Complaint
WHERE ComplaintId BETWEEN 15000 AND NULL;

-- Nope.
SELECT *
FROM Complaint
WHERE SubIssue IN ('Account status', NULL);


SELECT *
FROM Complaint
WHERE SubProduct IS NULL;

SELECT *
FROM Complaint
WHERE SubProduct IS NOT NULL;

SELECT *
FROM Complaint
WHERE ComplaintId > 15000 OR ComplaintId IS NULL;

SELECT *
FROM Complaint
WHERE SubIssue = 'Account status'
OR SubIssue IS NULL;

-- All Complaints with a value for ComplaintNarrative. 
-- Exclude null values.
SELECT *
FROM Complaint
WHERE ComplaintNarrative IS NOT NULL;



select 
*
from
Complaint
where
[SubmissionMethod] like '%mail%';
