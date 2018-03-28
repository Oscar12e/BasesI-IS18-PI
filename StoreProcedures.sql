--||||||Estudiante||||||||
--CrearEstudiante
use algoDePrueba
go

CREATE PROCEDURE Create_studentData(@Name nvarchar(50),@lastName nvarchar(50),@Email nvarchar(50),@Carnet nvarchar(50),@Phone int)
AS
BEGIN
	BEGIN TRY 
		IF not exists(SELECT * FROM Estudiante WHERE Estudiante.Carne = @Carnet AND Estudiante.Email = @Email)	
		begin 
			begin tran
				INSERT INTO Estudiante(Nombre,Apellido,Email,Carne,Telefono) VALUES (@Name,@lastName,@Email,@Carnet,@Phone)		
		end 
		commit tran
		return 1
	END TRY 
	BEGIN CATCH
			IF @@TRANCOUNT > 0 ROLLBACK; 
			return 0
	END CATCH
END
GO
--Crete_student_From_XML
CREATE PROCEDURE readXML_studentData
	
AS
BEGIN
	DECLARE @xml xml
	DECLARE @hdoc int
	BEGIN TRY 
		SELECT @xml = roow FROM OPENROWSET (BULK 'C:\data\SQL-Data\studentData.xml', SINGLE_BLOB) as studentData(roow)
		if (@xml IS NOT NULL)
		begin 
			begin tran
				EXEC sp_xml_preparedocument @hdoc OUTPUT, @xml

				SELECT * INTO #tmp_studentData FROM OPENXML(@hDoc, 'XML/studentData/student')
				WITH(

					name [nvarchar](50),
					lastName[nvarchar](50),
					email [nvarchar](50),
					carnet [nvarchar](50),
					phone[int]
				)
				begin 
					INSERT INTO Estudiante(Nombre,Apellido,Email,Carne,Telefono)SELECT name,lastName,email,carnet,phone FROM #tmp_studentData
					--EXEC dbo.Create_teacherData @Name = name,@Email = email,@Password = password;
				end
				DROP TABLE #tmp_studentData
		end
		commit tran
		return 1 --successful
	END TRY 
	BEGIN CATCH
			IF @@TRANCOUNT > 0 ROLLBACK; 
			return 0 --failed
	END CATCH
END
GO
--||||||Profesor||||||||
--Create_Profesor
CREATE PROCEDURE Create_techerData(@Name nvarchar(50),@Email nvarchar(50), @Password nvarchar(50))
AS
BEGIN
	BEGIN TRY 
		IF not exists(SELECT * FROM Profesor WHERE Profesor.Email = @Email)	
		begin 
			begin tran
				INSERT INTO Profesor(Nombre,Email,contrasenna) VALUES (@Name,@Email,@Password)		
		end 
		commit tran
		return 1	--successfully
	END TRY 
	BEGIN CATCH
			IF @@TRANCOUNT > 0 ROLLBACK; 
			return 0	--Error
	END CATCH

END
GO
--Create_Profesor_From_XML
CREATE PROCEDURE [dbo].[readXML_teacherData]

AS
BEGIN
	DECLARE @xml xml
	DECLARE @hdoc int
	DECLARE @pName nvarchar
	DECLARE @pEmail nvarchar
	DECLARE @pPassword nvarchar
	BEGIN TRY 
	--PONER EL ARCHIVO EN LA RUTA C:\data\SQL-Data\teacherData.xml
		SELECT @xml = roow FROM OPENROWSET (BULK 'C:\data\SQL-Data\teacherData.xml', SINGLE_BLOB) as teacherData(roow)
		if (@xml IS NOT NULL)
		begin 
			begin tran
				EXEC sp_xml_preparedocument @hdoc OUTPUT, @xml
				SELECT * INTO #tmp_teacherData FROM OPENXML(@hDoc, 'XML/teacherData/teacher')
				WITH(

					name [nvarchar](50),
					email [nvarchar](50),
					password [nvarchar](50)
				)
				begin 
					
					INSERT INTO Profesor (Nombre,Email,contrasenna) SELECT name,email,password FROM #tmp_teacherData
					--EXEC dbo.Create_teacherData @Name = name,@Email = email,@Password = password;
				end
				DROP TABLE #tmp_teacherData
		end
		commit tran
		return 1 --successful
	END TRY 
	BEGIN CATCH
			IF @@TRANCOUNT > 0 ROLLBACK; 
			return 0 --failed
	END CATCH
	END
--||||||EstadoEstudiante||||||||
--Create_EstadoEstudiante
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE Create_studentGroupStateData(@Estado nvarchar(50))
AS
BEGIN
	BEGIN TRY 
		IF not exists(SELECT * FROM EstadoEstudiante WHERE EstadoEstudiante.Nombre = @Estado)	
		begin 
			begin tran
				INSERT INTO EstadoEstudiante(Nombre) VALUES	(@Estado)	
		end 
		commit tran
		return 1
	END TRY 
	BEGIN CATCH
			IF @@TRANCOUNT > 0 ROLLBACK; 
			return 0
	END CATCH
	
END
GO

--Create_EstadoEstudiante_From_XML
 CREATE PROCEDURE [dbo].[readXML_studentGroupStateData] 
AS
BEGIN
DECLARE @xml xml
	DECLARE @hdoc int
	BEGIN TRY 
		SELECT @xml = roow FROM OPENROWSET (BULK 'C:\data\SQL-Data\studentGroupStateData.xml', SINGLE_BLOB) as studentGroupStateData(roow)
		if (@xml IS NOT NULL)
		begin 
			begin tran
				EXEC sp_xml_preparedocument @hdoc OUTPUT, @xml

				SELECT * INTO #tmp_studentGroupStateData FROM OPENXML(@hDoc, 'XML/studentGroupStateData/studentGroupState')
				WITH(

					name [nvarchar](50)
				)
				begin 
					INSERT INTO EstadoEstudiante(Nombre) SELECT name FROM #tmp_studentGroupStateData
					--EXEC dbo.Create_teacherData @Name = name,@Email = email,@Password = password;
				end
				DROP TABLE #tmp_studentGroupStateData
		end
		commit tran
		return 1 --successful
	END TRY 
	BEGIN CATCH
			IF @@TRANCOUNT > 0 ROLLBACK; 
			return 0 --failed
	END CATCH
END
Go
--||||||   GRUPO   ||||||||
--||||||EstadoGrupo||||||||
--Create_EstadoGrupo
CREATE PROCEDURE [dbo].[Create_groupStateData] (@Estado nvarchar(50))
AS
BEGIN
	BEGIN TRY 
		IF not exists(SELECT * FROM EstadoGrupo WHERE EstadoGrupo.Nombre = @Estado)	
		begin 
			begin tran
				INSERT INTO EstadoGrupo(Nombre)VALUES (@Estado)	
		end 
		commit tran
		return 1
	END TRY 
	BEGIN CATCH
			IF @@TRANCOUNT > 0 ROLLBACK; 
			return 0
	END CATCH
END
GO
--readXML_groupStateData
CREATE PROCEDURE readXML_groupStateData
AS
BEGIN
	DECLARE @xml xml
	DECLARE @hdoc int
	BEGIN TRY 
		SELECT @xml = roow FROM OPENROWSET (BULK 'C:\data\SQL-Data\groupStateData.xml', SINGLE_BLOB) as groupStateData(roow)
		if (@xml IS NOT NULL)
		begin 
			begin tran
				EXEC sp_xml_preparedocument @hdoc OUTPUT, @xml

				SELECT * INTO #tmp_groupStateData FROM OPENXML(@hDoc, 'XML/groupStateData/groupState')
				WITH(

					name [nvarchar](50)
					
				)
				begin 
					INSERT INTO EstadoGrupo(Nombre)SELECT name FROM #tmp_groupStateData
					--EXEC dbo.Create_teacherData @Name = name,@Email = email,@Password = password;
				end
				DROP TABLE #tmp_groupStateData
		end
		commit tran
		return 1 --successful
	END TRY 
	BEGIN CATCH
			IF @@TRANCOUNT > 0 ROLLBACK; 
			return 0 --failed
	END CATCH
END
GO

----||||||Stores Generales||||||||
--Borrar datos de Tablas
CREATE PROCEDURE [dbo].[VaciarTablas]
AS
BEGIN
	EXEC sp_MSForEachTable 'DISABLE TRIGGER ALL ON ?';
	EXEC sp_MSForEachTable 'ALTER TABLE ? NOCHECK CONSTRAINT ALL';
	EXEC sp_MSForEachTable 'DELETE FROM ?';
	EXEC sp_MSForEachTable 'ALTER TABLE ? CHECK CONSTRAINT ALL';
	EXEC sp_MSForEachTable 'ENABLE TRIGGER ALL ON ?';
	EXEC sp_MSforeachtable @command1 = 'DBCC CHECKIDENT(''?'', RESEED, 0)'
END
GO
--Ejecutar simulacion.


go
--- READ ---

-- Read_studentData ---
CREATE PROCEDURE Read_studentData
AS
BEGIN
begin tran
	select E.Nombre, E.Apellido, E.Carne, E.Telefono, E.Email
	from Estudiante E
commit tran
END
GO

--- Read_TeacherData -- 
CREATE PROCEDURE Read_TeacherData
AS
BEGIN
begin tran
	select P.Nombre, P.Email
	from Profesor P
commit tran
END
GO

--- Nombre -- 

CREATE PROCEDURE Read_studentGroupStateData
AS
BEGIN
begin tran
	select  E.Nombre
	from EstadoEstudiante E
commit tran
END

GO


CREATE PROCEDURE Read_groupStateData
AS
BEGIN
begin tran
	select E.Nombre
	from EstadoGrupo E
commit tran
END
GO


CREATE PROCEDURE Read_groupData
AS
BEGIN
begin tran
	select G.NombreCurso as 'Curso', PR.Nombre as 'Profesor', PE.FechaI 'Inicio', PE.FechaF 'Fin'
	from Grupo G
	inner join Profesor PR on G.FK_Profesor = PR.ID
	inner join Periodo PE on G.FK_Periodo = PE.ID
commit tran
END

GO

CREATE PROCEDURE Read_groupByStudentData
AS
BEGIN
begin tran
	select E.Nombre as 'Estudiante', G.NombreCurso as 'Curso', EE.Nombre as 'Estado'
	from GrupoxEstudiante GE
	inner join Estudiante E on GE.FK_Estudiante = E.ID
	inner join Grupo G on GE.FK_Grupo = G.ID
	inner join EstadoEstudiante EE on GE.FK_Estado = EE.ID

	order by 1
commit tran
END

GO

/*
--- Nombre -- 

CREATE PROCEDURE Read_
AS
BEGIN
begin tran
	select
	from 
commit tran
END

GO
*/