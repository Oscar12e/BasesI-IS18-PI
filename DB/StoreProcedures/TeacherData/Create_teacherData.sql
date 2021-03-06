USE [MyDataBase]
GO
/****** Object:  StoredProcedure [dbo].[Create_teacherData]    Script Date: 27/03/2018 5:36:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Create_teacherData](@Name nvarchar(50),@Email nvarchar(50), @Password nvarchar(50))

AS
BEGIN
	BEGIN TRY 
		IF not exists(SELECT * FROM Profesor WHERE Profesor.Email = @Email)	
		begin 
			begin tran
				INSERT INTO Profesor(Nombre,Email,contrasenna) VALUES (@Name,@Email,@Password)		
		end 
		commit tran
		return 1
	END TRY 
	BEGIN CATCH
			IF @@TRANCOUNT > 0 ROLLBACK; 
			return 0
	END CATCH

END
