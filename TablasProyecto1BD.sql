--create database algoDePrueba




create table Periodo(
	ID integer primary key identity (0,1),
	Estado  nvarchar(50) not null,
	FechaI datetime not null,
	FechaF datetime not null
);


create table EstadoGrupo(
	ID integer primary key identity (0,1),
	Nombre nvarchar(50) not null unique 
);

create TABLE Profesor(
	ID int primary key identity(1,1),
	Nombre nvarchar(50) not null,
	Email nvarchar(50) not null,
	contrasenna nvarchar(50) not null,
)

create TABLE Grupo(
	ID int primary key identity(1,1),
	Estado int foreign key references EstadoGrupo(ID),
	FK_Periodo int foreign key references Periodo(ID),
	FK_Profesor int foreign key references Profesor(ID),

	NombreCurso nvarchar(50) not null,
	CodigoGrupo nvarchar(50) not null	
)



create table EstadoEstudiante(
	ID int primary key identity(0,1),
	Nombre nvarchar(50) not null unique
)


create table Estudiante (
	ID int primary key identity(0,1),
	Nombre nvarchar(50) not null unique,
	Apellido nvarchar(50) not null,
	Telefono int not null,
	Email nvarchar(50) not null,
	Carne nvarchar(50) not null
)


create TABLE GrupoxEstudiante(
	ID int primary key identity(0,1),
	FK_Grupo int not null foreign key references Grupo(ID),
	FK_Estado int not null foreign key references EstadoEstudiante(ID),
	FK_Estudiante int not null foreign key references Estudiante(ID),
	NotaAcumulada int not null
)


create Table Rubros(
	ID int primary key identity(0,1),
	Nombre nvarchar(50) not null unique
)


create table GrupoxRubro(
	ID int primary key identity(0,1),
	FK_Grupo int not null foreign key references Grupo(ID),
	FK_Rubro int not null foreign key references Rubros(ID),
	Valor int not null,
	EsFijo char(1), check((EsFijo = 'y') or (EsFijo = 'n')),
	Q int not null
)

create table Evaluacion(
	ID int primary key identity(0,1),
	FK_Grupo_Rubro int not null foreign key references GrupoxRubro(ID),
	Nombre nvarchar(50) not null,
	Fecha datetime not null,
	ValorPorcentual int not null,
	Descripcion nvarchar(50) not null
) 


create table EvaluacionxEstudiante (
	ID int primary key identity(0,1),
	FK_Grupo_Estudiante int not null foreign key references GrupoxEstudiante(ID),
	FK_Evaluacion int not null foreign key references Evaluacion(ID),
	Nota int not null
)
