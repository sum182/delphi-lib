---- Helpers ---------------------------------------------------------------------
Atalhos:
Alt+F1 = Ver tabela
CTrl+R = Esconder janela de resultados 
----------------------------------------------------------------------------------





---- Helpers ---------------------------------------------------------------------
sisProc 'TabTipoAvaria'       -- Find de Procedure CTRL+3
sisPrc  'TabTipoAvariaExclui' -- Estrutura da Procedure CTRL+4
sisTab 'TipoAvaria'           -- Find de Tabela CTRL+5
sisStr 'EntradaVeiculo'       -- Estrutura de Tabela CTRL+6
----------------------------------------------------------------------------------







---- Helpers para manipular os objetos no BD--------------------------------------
SisCriaCampo
SisAlteraCampo
SisApagaCampo
SisCriaTabela
SisCriaRela
SisApagaProcedure

SisListaProcedure        
Para conhecer todas as Procedures de Ajuda existentes execute o comando
SisProc 'Sis'      

--procura nos objetos do BD
o primeiro parametro é o módulo exemplo.....'STO' e 'BAL'
'','CalcVol20PesoBal'                   
----------------------------------------------------------------------------------


sisProc '%fnConvDiaHora' 



----principais tabelas do sistema--------------------------------------------------
Destinatario - Cliente/Emitente/Transportadora/Fornecedor
Motorista - Motoristas
Usuarios - Usuários
EntradaVeiculo/EntradaVeiculoItem - Entrada do Veículo no Terminal
CheckList/CheckListItem - Check List do Veículo
WebStoPlanejaVeiculo - Agendamento de Veículos
PlanejCarga - Planejamento de Carga/Descarga
OpCarga - Autorizações de Carga
OpDescarga - Autorização de Descarga
Configuracoes - Configurações
MovProdSemLiber - Produtos sem Liberação
MovProdLiberados - Produtos Liberados
NotaFiscal/NotaFiscalItem - Notas Fiscais
----------------------------------------------------------------------------------





----comandos gerais---------------------------------------------------------------
select * from TipoAvaria 
where DtOperInc >= '2013-29-04'


select * from TipoAvaria 
where DtOperInc between '2013-29-04' and '2014-03-04'

-- setar variaveis
set @Descricao   = '' 
set @Cpf         = '' 
set @TipoDoc     = ''
set @Doc         = ''   


chamar uma funcao
select dbo.TiraAcento('TesteÉ')


select * from Configuracoes
where valor = '0'
----------------------------------------------------------------------------------









----Criação de tabela--------------------------------------------------------------------

if not exists ( select Name
                from   SysObjects
                where  id = object_id( 'TipoMovimentacaoContrato') and
                       OBJECTPROPERTY( id, 'IsTable') = 1) begin

  CREATE TABLE [dbo].[TipoMovimentacaoContrato](
	  [CodTipoMovContr] [int] NOT NULL,
	  [DescrTipoMovContr] [varchar](60) NULL,
)

  exec SisCriaPrimary 'TipoMovimentacaoContrato', 'PK_TipoMovimentacaoContrato', 'CodTipoMovContr'
  
  exec SisCriaDescr 'TipoMovimentacaoContrato', 'CodTipoMovContr', 'Código do Tipo de Movimentação de Contrato'
  exec SisCriaDescr 'TipoMovimentacaoContrato', 'DescrTipoMovContr', 'Descrição do Tipo de Movimentação de Contrato'
  

  insert into TipoMovimentacaoContrato values( 1, 'Contábil')
  insert into TipoMovimentacaoContrato values( 2, 'Fiscal')
  

end
GO
----------------------------------------------------------------------------------



----Controle de Versão -----------------------------------------------------------
sisversao

select * from SisAtualizacoes
----------------------------------------------------------------------------------