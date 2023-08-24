if exists (select * from sysobjects where name='Operations' and xtype='U')
	drop table Operations;

if exists (select * from sysobjects where name='Containers' and xtype='U')
	drop table Containers;

create table Containers (
	Id int identity(1, 1) not null,
	Number int not null,
	[Type] nvarchar(50) not null,
	[Length] float not null,
	Width float not null,
	Height float not null,
	[Weight] float not null, 
	[Empty] bit not null,
	ReceiptDate datetime not null,
	primary key (Id)
);

create table Operations (
	Id int identity(1, 1) not null,
	ContainerId int not null,
	BeginDate datetime not null,
	EndDate datetime not null,
	[Type] nvarchar(50) not null,
	OperatorName nvarchar(200) not null,
	InspectionLocation nvarchar(500) not null,
	primary key (Id),
	foreign key (ContainerId) references Containers(Id)
);

set identity_insert Containers on;

insert into Containers(Id, Number, [Type], [Length], Width, Height, [Weight], [Empty], ReceiptDate)
values (1, 789, 'Medium', 12.5, 4, 3, 900, 0, '2023/08/24 13:56:00'),
	(2, 356, 'Small', 6, 3, 2, 100, 1, '2023/08/24 13:56:00'),
	(3, 999, 'Large', 18, 6, 5, 1500, 0, '2023/08/24 13:56:00');

set identity_insert Containers off;

set identity_insert Operations on;

insert into Operations(Id, ContainerId, BeginDate, EndDate, [Type], OperatorName, InspectionLocation)
values (1, 1, '2023/08/24 13:56:00', '2023/08/24 14:00:00', 'Load', 'Wesley Snipes', 'Boston, Massachusetts'),
	(2, 2, '2023/08/24 13:56:00', '2023/08/24 14:00:00', 'Unload', 'Wesley Snipes', 'Boston, Massachusetts'),
	(3, 3, '2023/08/24 13:56:00', '2023/08/24 14:00:00', 'Load', 'Wesley Snipes', 'Boston, Massachusetts'),
	(4, 1, '2023/08/24 14:15:00', '2023/08/24 14:20:00', 'Unload', 'Wesley Snipes', 'Boston, Massachusetts'),
	(5, 3, '2023/08/24 14:15:00', '2023/08/24 14:20:00', 'Unload', 'Wesley Snipes', 'Boston, Massachusetts');

set identity_insert Operations off;

declare @ContainersJSON nvarchar(max);

select @ContainersJSON = coalesce(@ContainersJSON + ', ', '') + 
	concat('{"id": ', Id, ', "number": ', Number, ', "type": "', [Type], 
		'", "length": ', [Length], ', "width": ', Width, ', "height": ', Height, 
		', "weight": ', [Weight], ', "empty": ', [Empty], ', "receiptDate": "', format(ReceiptDate, 'yyyy/MM/dd HH:mm:ss'), '"}'
	)
from Containers;

select concat('[', @ContainersJSON, ']') as ContainersJSON;

declare @OperationsJSON nvarchar(max);

select @OperationsJSON = coalesce(@OperationsJSON + ', ', '') + 
	concat('{"id": ', Id, ', "containerId": ', ContainerId, ', "beginDate": "', format(BeginDate, 'yyyy/MM/dd HH:mm:ss'), '", "endDate": "', format(EndDate, 'yyyy/MM/dd HH:mm:ss'), 
		'", "type": "', [Type], '", "operatorName": "', OperatorName, '", "inspectionLocation": "', InspectionLocation, '"}'
	)
from Operations;

select concat('[', @OperationsJSON, ']') as OperationsJSON;

drop table Operations;
drop table Containers;