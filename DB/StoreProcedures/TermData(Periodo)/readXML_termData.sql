USE [MyDataBase]
GO
/****** Object:  StoredProcedure [dbo].[readXML_termData]    Script Date: 28/03/2018 1:44:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[readXML_termData]
	
AS
BEGIN
	DECLARE @xml xml
	DECLARE @hdoc int
	BEGIN TRY 
		SELECT @xml = roow FROM OPENROWSET (BULK 'C:\data\SQL-Data\termData.xml', SINGLE_BLOB) as termData(roow)
		if (@xml IS NOT NULL)
		begin 
			begin tran
				EXEC sp_xml_preparedocument @hdoc OUTPUT, @xml

				SELECT * INTO #tmp_termData FROM OPENXML(@hDoc, 'XML/termData/term')
				WITH(

					start [datetime],
					finish [datetime],
					active[nvarchar](20)
					
				)
				begin
				INSERT INTO Periodo(FechaI,FechaF,Estado)SELECT start,finish,active FROM #tmp_termData
					select * from #tmp_termData 
				end
				DROP TABLE #tmp_termData
		end
		commit tran
		return 1 --successful
	END TRY 
	BEGIN CATCH
			IF @@TRANCOUNT > 0 ROLLBACK; 
			return 0 --failed
	END CATCH
END
