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


--///////////////////////////////////Pessoa////////////////////////////////////////////////////////////

USE [ControleEntrada]
GO

/****** Object:  Table [dbo].[Pessoa_Sinc]    Script Date: 25/05/2018 14:13:30 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[Pessoa_Sinc](
	[PessoaID] [int] NULL,
	[Funcao] [varchar](1) NULL,
	[flagImportado] [int] NULL,
	[DtImportado] [date] NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


USE [ControleEntrada]
GO
/****** Object:  StoredProcedure [dbo].[sp_insPessoa]    Script Date: 25/05/2018 14:13:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[sp_insPessoa]
	@ID	int, 
	@Nome varchar(100), 
	@Sexo varchar(1), 
	@RG as varchar(30), 
	@CPF as varchar(14), 
	@Tipo as varchar(50),
	@BloqueiaAcesso as bit, 
	@NumeroVaga as varchar(10), 
	@Unidade as varchar(50), 
	@Bloco as varchar(50)
As

	Insert into Pessoa 
				(
				Nome, 
				Sexo, 
				RG, 
				CPF, 
				Tipo,
				BloqueiaAcesso, 
				NumeroVaga, 
				Unidade, 
				Bloco, 
				DataCadastro,
				DepartamentoID
				)
	Values		(
				@Nome, 
				@Sexo, 
				@RG, 
				@CPF, 
				@Tipo,
				@BloqueiaAcesso, 
				@NumeroVaga, 
				@Unidade, 
				@Bloco, 
				getdate(),
				(Select top 1 ID From Departamento Where Nome = @Bloco and DataExclusao is Null)
				)
	Select ID=@@IDENTITY


--ENABLE Trigger [dbo].[tI_Pessoa] on [dbo].[Pessoa];

USE [ControleEntrada]
GO
/****** Object:  StoredProcedure [dbo].[sp_updPessoa]    Script Date: 25/05/2018 14:14:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[sp_updPessoa]
	@ID	int, 
	@Nome varchar(100), 
	@Sexo varchar(1), 
	@RG as varchar(30), 
	@CPF as varchar(14), 
	@Tipo as varchar(50),
	@BloqueiaAcesso as bit, 
	@NumeroVaga as varchar(10), 
	@Unidade as varchar(50), 
	@Bloco as varchar(50)
As

	Update Pessoa Set 
				Nome=@Nome, 
				Sexo=@Sexo, 
				RG=@RG, 
				CPF=@CPF, 
				Tipo=@Tipo,
				BloqueiaAcesso=@BloqueiaAcesso, 
				NumeroVaga=@NumeroVaga, 
				Unidade=@Unidade, 
				Bloco=@Bloco, 
				DepartamentoID=(Select top 1 ID From Departamento Where Nome = @Bloco and DataExclusao is Null)
	Where
				ID=@ID

USE [ControleEntrada]
GO

/****** Object:  Trigger [dbo].[ti_Pessoa]    Script Date: 25/05/2018 14:14:33 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [dbo].[ti_Pessoa] ON [dbo].[Pessoa] 
FOR INSERT
AS
--Select * From Pessoa_Sinc Order By PessoaID, Funcao
--delete From Pessoa_Sinc
--Create table Pessoa_Sinc (PessoaID int, Funcao varchar(1), flagImportado int, DtImportado date)
Insert into Pessoa_Sinc (PessoaID, Funcao, flagImportado, DtImportado) (Select ID as PessoaID, Funcao='i', flagImportado=0, DtImportado=getdate() From inserted i)

GO

USE [ControleEntrada]
GO

/****** Object:  Trigger [dbo].[tU_Pessoa]    Script Date: 25/05/2018 14:14:47 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE trigger [dbo].[tU_Pessoa] on [dbo].[Pessoa]
--drop trigger [dbo].[tU_Pessoa]
  after update
  as
begin
	Set Nocount on
--	if (Select count(*) From Pessoa_Sinc where Funcao='u' And PessoaID in (Select ID From inserted i)) = 0
	begin
		Insert into Pessoa_Sinc (PessoaID, Funcao, flagImportado, DtImportado) (Select ID as PessoaID, Funcao='u', flagImportado=0, DtImportado=getdate() From inserted i)
	end
end

GO

--///////////////////////////////////////Veiculos//////////////////////////////////////////

USE [ControleEntrada]
GO

/****** Object:  Table [dbo].[Veiculo_Sinc]    Script Date: 25/05/2018 14:17:46 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[Veiculo_Sinc](
	[VeiculoID] [bigint] NULL,
	[Funcao] [varchar](1) NULL,
	[flagImportado] [bit] NULL,
	[DtImportado] [date] NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


USE [ControleEntrada]
GO

/****** Object:  Trigger [dbo].[ti_Veiculo]    Script Date: 25/05/2018 14:21:26 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [dbo].[ti_Veiculo] ON [dbo].[LinearDispositivo] 
FOR INSERT
AS
--Select * From Pessoa_Sinc Order By PessoaID, Funcao
--delete From Pessoa_Sinc
--Create table Pessoa_Sinc (PessoaID int, Funcao varchar(1), flagImportado int, DtImportado date)
Insert into Veiculo_Sinc (VeiculoID, Funcao, flagImportado, DtImportado) (Select ID as VeiculoID, Funcao='i', flagImportado=0, DtImportado=getdate() From inserted i)

GO

USE [ControleEntrada]
GO

/****** Object:  Trigger [dbo].[tU_Veiculo]    Script Date: 25/05/2018 14:21:36 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE trigger [dbo].[tU_Veiculo] on [dbo].[LinearDispositivo] 
--drop trigger [dbo].[tU_Pessoa]
  after update
  as
begin
	Set Nocount on
--	if (Select count(*) From Pessoa_Sinc where Funcao='u' And PessoaID in (Select ID From inserted i)) = 0
	begin
		Insert into Veiculo_Sinc (VeiculoID, Funcao, flagImportado, DtImportado) (Select ID as VeiculoID, Funcao='u', flagImportado=0, DtImportado=getdate() From inserted i)
	end
end
GO

USE [ControleEntrada]
GO

/****** Object:  StoredProcedure [dbo].[sp_insVeiculoIntegra]    Script Date: 25/05/2018 14:21:55 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[sp_insVeiculoIntegra]
@Unidade nvarchar(50),
@Bloco nvarchar(50),
@PessoaID varchar(255),
@MarcaVeiculo nvarchar(50),
@CorVeiculo nvarchar(50),
@PlacaVeiculo varchar(255),
@Foto varchar(255)

AS
DISABLE TRIGGER [dbo].[ti_Veiculo] ON [dbo].[LinearDispositivo]
Declare @LinearDispositivoID int
--sp_insVeiculoIntegra'52','INFOSECRET','30973','29','2','BQY3850',''
--Select * From Middleware2.dbo.Veiculo_sinc
--update Middleware2.dbo.Veiculo_sinc set UnidadeID = 52
--select Nome from Pessoa p inner join PessoaLinear pl on p.ID = pl.PessoaID where p.ID = '30973'
insert into LinearDispositivo values
('Controle','','',@Unidade,@Bloco,'',(select Nome from Pessoa p inner join PessoaLinear pl on p.ID = pl.PessoaID where p.ID = @PessoaID),0,@MarcaVeiculo,@CorVeiculo,@PlacaVeiculo,GETDATE(),null,@Foto)
set @LinearDispositivoID = @@IDENTITY
insert into PessoaLinear(LinearDispositivoID,PessoaID) values (@LinearDispositivoID,@PessoaID)

GO


USE [ControleEntrada]
GO

/****** Object:  StoredProcedure [dbo].[sp_updVeiculoIntegra]    Script Date: 25/05/2018 14:22:06 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[sp_updVeiculoIntegra]
@Unidade nvarchar(50),
@Bloco nvarchar(50),
@PessoaID varchar(255),
@MarcaVeiculo nvarchar(50),
@CorVeiculo nvarchar(50),
@PlacaVeiculo varchar(255),
@Foto varchar(255)

AS
DISABLE TRIGGER [dbo].[tU_Veiculo] ON [dbo].[LinearDispositivo]

--Select * from LinearDispositivo where id='4'
--Select * From Middleware2.dbo.Veiculo_sinc
--update Middleware2.dbo.Veiculo_sinc set UnidadeID = 52
--select Nome from Pessoa p inner join PessoaLinear pl on p.ID = pl.PessoaID where p.ID = '30973'
update LinearDispositivo set
tipo = 'Controle',Unidade = @Unidade,Bloco = @Bloco,Identificacao = (select Nome from Pessoa p inner join PessoaLinear pl on p.ID = pl.PessoaID where p.ID = @PessoaID),MarcaVeiculo = @MarcaVeiculo,CorVeiculo = @CorVeiculo,PlacaVeiculo = @PlacaVeiculo,LinearFoto = @Foto

GO










