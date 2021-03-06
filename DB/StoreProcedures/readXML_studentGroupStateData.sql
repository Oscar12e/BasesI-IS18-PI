USE [MyDataBase]
GO
/****** Object:  StoredProcedure [dbo].[readXML_studentGroupStateData]    Script Date: 27/03/2018 7:53:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

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
