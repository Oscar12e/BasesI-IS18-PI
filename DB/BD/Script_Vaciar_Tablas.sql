-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the procedure.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE usp_VaciarTablas
AS
BEGIN
	EXEC sp_MSForEachTable 'DISABLE TRIGGER ALL ON ?';
	EXEC sp_MSForEachTable 'ALTER TABLE ? NOCHECK CONSTRAINT ALL';
	EXEC sp_MSForEachTable 'DELETE FROM ?';
	EXEC sp_MSForEachTable 'ALTER TABLE ? CHECK CONSTRAINT ALL';
	EXEC sp_MSForEachTable 'ENABLE TRIGGER ALL ON ?';
	EXEC sp_MSforeachtable @command1 = 'DBCC CHECKIDENT(''?'', RESEED, 0)'
END
