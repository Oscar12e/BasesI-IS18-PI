
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
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
