USE [MyDataBase]
GO
/****** Object:  StoredProcedure [dbo].[readXML_teacherData]    Script Date: 27/03/2018 5:37:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[readXML_teacherData]

AS
BEGIN
	DECLARE @xml xml
	DECLARE @hdoc int
	DECLARE @pName nvarchar
	DECLARE @pEmail nvarchar
	DECLARE @pPassword nvarchar
	
	


	BEGIN TRY 
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
