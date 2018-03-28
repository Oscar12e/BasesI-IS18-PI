
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
