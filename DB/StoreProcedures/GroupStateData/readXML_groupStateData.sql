
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
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
