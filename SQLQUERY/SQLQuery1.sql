CREATE TABLE PageContent (
    Id INT PRIMARY KEY IDENTITY(1,1), -- מזהה ייחודי לכל מקטע
    SectionName NVARCHAR(100) NOT NULL, -- שם המקטע (למשל "אודות", "צור קשר")
    Content NVARCHAR(MAX) NOT NULL, -- התוכן עצמו (טקסט ארוך)
    LastUpdated DATETIME DEFAULT GETDATE(), -- תאריך עדכון אחרון
    IsActive BIT DEFAULT 1 -- האם המקטע פעיל (לא מחוק)
);