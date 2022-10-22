CREATE DATABASE MechaniclesCarRepairShop
go

Create SCHEMA Employee
go

Create SCHEMA Customer
go

CREATE TABLE Employee.Employees(
	EmpleadoId int not null,
	FirstName varchar(50) not null,
	LastName varchar(50) not null,
	StarDate datetime not null,
)

CREATE TABLE Customer.Customer(
	CustomerId int not null,
	FirstName varchar(50) not null,
	LastName varchar(50) not null,

)