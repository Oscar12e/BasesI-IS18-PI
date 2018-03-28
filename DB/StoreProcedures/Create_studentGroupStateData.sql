
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
