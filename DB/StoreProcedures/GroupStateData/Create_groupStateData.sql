SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE Create_groupStateData (@Estado nvarchar(50))
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
