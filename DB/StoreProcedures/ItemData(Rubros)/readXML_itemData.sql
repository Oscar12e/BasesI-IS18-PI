
CREATE PROCEDURE readXML_itemData
AS
BEGIN
	DECLARE @xml xml
	DECLARE @hdoc int
	BEGIN TRY 
		SELECT @xml = roow FROM OPENROWSET (BULK 'C:\data\SQL-Data\itemData.xml', SINGLE_BLOB) as itemData(roow)
		if (@xml IS NOT NULL)
		begin 
			begin tran
				EXEC sp_xml_preparedocument @hdoc OUTPUT, @xml

				SELECT * INTO #tmp_itemData FROM OPENXML(@hDoc, 'XML/itemData/item')
				WITH(

					name [nvarchar](50)
					
				)
				begin 
					INSERT INTO Rubros(Nombre)SELECT name FROM #tmp_itemData
					--EXEC dbo.Create_teacherData @Name = name,@Email = email,@Password = password;
				end
				DROP TABLE #tmp_itemData
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
