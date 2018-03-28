
CREATE PROCEDURE readXML_groupData
AS
BEGIN
	DECLARE @xml xml
	DECLARE @hdoc int
	BEGIN TRY 
		SELECT @xml = roow FROM OPENROWSET (BULK 'C:\data\SQL-Data\groupData.xml', SINGLE_BLOB) as groupData(roow)
		if (@xml IS NOT NULL)
		begin 
			begin tran
				EXEC sp_xml_preparedocument @hdoc OUTPUT, @xml

				SELECT * INTO #tmp_groupData FROM OPENXML(@hDoc, 'XML/groupData/group')
				WITH(
					 groupStateID[int],
					 teacherID[int],
					 termID[int],
					 courseName[nvarchar](50),
					 code[nvarchar](50)
					
				)
				begin 
					--SELECT * FROM #tmp_groupData
					 
					INSERT INTO Grupo(FK_Estado,FK_Profesor,FK_Periodo,NombreCurso,CodigoGrupo)SELECT groupStateID,teacherID,termID,courseName,code FROM #tmp_groupData
					--EXEC dbo.Create_teacherData @Name = name,@Email = email,@Password = password;
				end
				DROP TABLE #tmp_groupData
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
