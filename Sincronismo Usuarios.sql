--/////////////////////////////////////////////////////////////////////////////Usuario////////////////////////////////////////////

USE [ControleEntrada]
GO
/****** Object:  StoredProcedure [dbo].[sp_insUsuarioIntegra]    Script Date: 25/05/2018 11:39:37 ******/
SET ANSI_NULLS ON


GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[sp_insUsuarioIntegra]
	@Nome nvarchar(255),
	@Login nvarchar(255),
	@Senha varchar(255)

AS
DISABLE TRIGGER [dbo].[ti_Usuario] ON [dbo].[Usuario]

insert into Usuario values
 (NEWID(),@Nome,@Login,@Senha,4,GETDATE(),NULL)


GO
/****** Object:  StoredProcedure [dbo].[sp_updUsuarioIntegra]    Script Date: 25/05/2018 11:39:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[sp_updUsuarioIntegra]
	@ID nvarchar(255),
	@Nome nvarchar(255),
	@Login nvarchar(255),
	@Senha varchar(255)

AS
DISABLE TRIGGER [dbo].[ti_Usuario] ON [dbo].[Usuario]

Update Usuario set Nome = @Nome,Login = @Login,Senha = @Senha where Usuario.id = @ID


GO
/****** Object:  Trigger [dbo].[ti_Usuario]    Script Date: 25/05/2018 11:40:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[ti_Usuario] ON [dbo].[Usuario] 
FOR INSERT
AS
--Select * From Pessoa_Sinc Order By PessoaID, Funcao
--delete From Pessoa_Sinc
--Create table Pessoa_Sinc (PessoaID int, Funcao varchar(1), flagImportado int, DtImportado date)
Insert into Usuario_sinc (UsuarioID, Funcao, flagImportado, DtImportado) (Select ID as UsuarioID, Funcao='i', flagImportado=0, DtImportado=getdate() From inserted i where PerfilID = 4)


GO

/****** Object:  Table [dbo].[Usuario_sinc]    Script Date: 25/05/2018 11:40:38 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[Usuario_sinc](
	[UsuarioID] [uniqueidentifier] NULL,
	[Funcao] [varchar](1) NULL,
	[flagImportado] [bit] NULL,
	[DtImportado] [date] NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO
