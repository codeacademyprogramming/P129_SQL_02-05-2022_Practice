--Kitabxana database-i qurursunuz
Create Database Library

Use Library

--Books (Id, Name, PageCount)
--Books-un Name columu minimum 2 simvol maksimum 100 simvol deyer ala bileceyi serti olsun.
--Books-un PageCount columu minimum 10 deyerini ala bileceyi serti olsun.
Create Table Books
(
	Id int primary key identity,
	Name nvarchar(100) Check(Len(Name) >=2),
	PageCount int Not Null Check(PageCount >= 10)
)

--Authors (Id, Name, Surname)
Create Table Authors
(
	Id int primary key identity,
	Name nvarchar(255) Not Null,
	SurName nvarchar(255) Not Null
)

INSERT INTO Authors(Name, SurName)
VALUES
('Stephen', 'King'),
('J.K.', 'Rowling'),
('Amy', 'Tan'),
('Khaled', 'Hosseini'),
('Tana', 'French')

--Books ve Authors table-larinizin mentiqi uygun elaqesi olsun.
Alter Table Books
Add AuthorId int Foreign Key References Authors(Id)

INSERT INTO Books(Name, PageCount, AuthorId)
VALUES
('It', 543, 1),
('The Shining', 524, 1),
('Misery', 629, 1),
('Carrie', 785, 1),
('Harry Potter', 683, 2),
('Harry Potter 2', 755, 2),
('Harry Potter 3', 531, 2),
('Harry Potter 4', 624, 2),
('Harry Potter 5', 764, 2),
('The Joy Luck Club', 311, 3),
('The Kitchen Gods Wife', 855, 3),
('The Hundred Secret Senses', 345, 3),
('The Bonesetters Daughter', 286, 3),
('The Valley of Amazement', 717, 3),
('THE KITE RUNNER', 863, 4),
('And the Mountains Echoed', 433, 4),
('A Thousand Splendid Suns', 866, 4),
('Sea Prayer', 865, 4),
('The Kite Runner', 326, 4),
('The Searcher', 289, 5),
('The Likeness', 429, 5),
('Faithful Place', 678, 5),
('The Secret Place', 435, 5)

--Id, Name, PageCount ve AuthorFullName columnlarinin valuelarini qaytaran bir view yaradin
Alter View usv_GetBooks
as
Select b.Id, b.Name, b.PageCount, (a.Name+' '+a.SurName) 'AuthorFullName' From Books b
Join Authors a On b.AuthorId = a.Id

Select * From usv_GetBooks

--Gonderilmis axtaris deyirene gore hemin axtaris deyeri name ve ya authorFullNamelerinde olan Book-lari Id, Name, PageCount, AuthorFullName columnlari seklinde gostern procedure yazin
Create Procedure usp_SearchBook 
@search nvarchar(255)
As
Begin
	Select * From usv_GetBooks where Name Like '%'+@search+'%' Or AuthorFullName Like '%'+@search+'%'
End

exec usp_SearchBook 'ing'
--Authors tableinin insert, update ve deleti ucun (her biri ucun ayrica) procedure yaradin
Create Procedure usp_CreateAuthor
@name nvarchar(255),
@surName nvarchar(255)
As
Begin
	Insert Into Authors(Name, SurName) Values(@name, @surName)
End

exec usp_CreateAuthor 'Viktor','Hugo'

Alter Procedure usp_UpdateAuthor
@id int,
@name nvarchar(255),
@surName nvarchar(255)
As
Begin
	Update Authors Set Name = @name, SurName = @surName Where Id = @id 
End

exec usp_UpdateAuthor 6, 'Nizami', 'Genceji'

Create Procedure usp_DeleteAuthor
@id int
As
Begin
	Delete Authors Where Id = @id
End

exec usp_DeleteAuthor 6
--Authors-lari Id,FullName,BooksCount,MaxPageCount seklinde qaytaran view yaradirsiniz 
--Id-author id-si, FullName - Name ve Surname birlesmesi, BooksCount - Hemin authorun 
--elaqeli oldugu kitablarin sayi, MaxPageCount - hemin authorun elaqeli oldugu kitablarin 
--icerisindeki max pagecount deyeri
Create View usv_GetAuthorsInfo
As
Select a.Id, (a.Name+' '+a.SurName) 'FullName', COUNT(*) 'BooksCount', MAX(b.PageCount) 'MaxPageCount', SUM(b.PageCount) 'Total Page Count' From Authors a
Join Books b On a.Id = b.AuthorId
Group By a.Id, a.Name, a.SurName


--Additional
select * from usv_GetAuthorsInfo Order By  MaxPageCount Asc
select * from usv_GetAuthorsInfo Order By  MaxPageCount Desc

Select Top  1  * From usv_GetAuthorsInfo

Select Top 5 * from Books Order By PageCount desc

Select Id, ISNULL(Name,'Adi Yoxdur'), PageCount From Books

Select b.Id, ISNULL(b.Name, a.Name), PageCount From Books b
Join Authors a On b.AuthorId = a.Id

Select b.Id, IIF(b.PageCount > 500,'Coxdur', 'Azdir') 'Sehife', PageCount From Books b
Join Authors a On b.AuthorId = a.Id