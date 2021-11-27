//////////////////////////////////////////////////////////////////////////
// Criacao...........: 10/2002
// Sistema...........: Netuno - Controle de Patrimonio
// Integracao........: Olimpo - Automacao Comercial
// Analistas.........: Marilene Esquiavoni & Denny Paulista Azevedo Filho
// Desenvolvedores...: Marilene Esquiavoni & Denny Paulista Azevedo Filho
// Copyright.........: Marilene Esquiavoni & Denny Paulista Azevedo Filho
//////////////////////////////////////////////////////////////////////////

unit UnitRelPatrimonio;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SpeedBar, StdCtrls, RXSplit, fcButton, fcImgBtn, RXCtrls,
  ExtCtrls, jpeg, DCChoice;

type
  TFrmRelPatrimonio = class(TForm)
    Image2: TImage;
    Label2: TLabel;
    Panel1: TPanel;
    RxLabel3: TRxLabel;
    Label1: TLabel;
    RxLabel5: TRxLabel;
    RxLabel4: TRxLabel;
    fclGravar: TfcImageBtn;
    RxSplitter1: TRxSplitter;
    RxSplitter2: TRxSplitter;
    cmbClassif: TComboBox;
    SpeedBar1: TSpeedBar;
    SpeedbarSection1: TSpeedbarSection;
    Btnimprimir: TSpeedItem;
    BtnSair: TSpeedItem;
    Label3: TLabel;
    cmbDestino: TDCComboBox;
    procedure BtnSairClick(Sender: TObject);
    procedure cmbDestinoExit(Sender: TObject);
    procedure cmbClassifChange(Sender: TObject);
    procedure BtnimprimirClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cmbDestinoChange(Sender: TObject);
    procedure cmbDestinoCloseUp(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmRelPatrimonio: TFrmRelPatrimonio;

implementation

uses UnitDMDados, UnitQRPatri, UnitQRVendidos, UnitPrincipal;

{$R *.dfm}

procedure TFrmRelPatrimonio.BtnSairClick(Sender: TObject);
begin
  close;
end;

procedure TFrmRelPatrimonio.cmbDestinoExit(Sender: TObject);
Var
  x:integer;
  Flag:Boolean;
begin
 If cmbDestino.Text= '' then
      Begin
      ShowMessage('� obrigat�rio informar o destino do relat�rio');
      cmbDestino.SetFocus;
      End
   Else
      Begin
      Flag:=True;
      For x:=0 to cmbDestino.Items.Count-1 Do
        If cmbDestino.Text=cmbDestino.Items[x] Then
          Flag:=False;
      If Flag Then
        Begin
        ShowMessage('Valor inv�lido');
        cmbDestino.SetFocus;
        End
      else
        begin
        speedbar1.SetFocus;
        btnImprimir.Enabled:=true;
        end;
      end;
end;

procedure TFrmRelPatrimonio.cmbClassifChange(Sender: TObject);
begin
If cmbClassif.Text= 'N�mero' Then
	dmdados.tbpatrimonio.IndexFieldNames:= 'NumPatri';
If cmbClassif.Text= 'Descri��o' Then
	dmdados.tbpatrimonio.IndexFieldNames:= 'Descricao';
If cmbClassif.Text= 'Tipo' Then
	dmdados.tbpatrimonio.IndexFieldNames:= 'Tipo';
If cmbClassif.Text= 'Vendidos' Then
	dmdados.tbpatrimonio.IndexFieldNames:= 'CodCompra';
end;

procedure TFrmRelPatrimonio.BtnimprimirClick(Sender: TObject);
begin
  Btnimprimir.Enabled:=False;
  If cmbClassif.Text<>'Vendidos' Then
    begin
    QRPatrimonio:= TQRPatrimonio.Create(application);
    dmdados.TbPatrimonio.Filtered:=False;
    dmdados.TbPatrimonio.Filter:='(CodCompra > '''+'0'+''')';
    dmdados.TbPatrimonio.Filtered:=True;
    If cmbDestino.Text= 'V�deo' Then
  	  QRPatrimonio.RPPatrimonio.Preview
    else
    	QRPatrimonio.RPPatrimonio.Print;
    dmdados.TbPatrimonio.Filtered:=False;
    QRPatrimonio.Free;
    end
  else
    begin
    QRVendidos:= TQRVendidos.Create(application);
    dmdados.TbPatrimonio.Filtered:=False;
    dmdados.TbPatrimonio.Filter:='(CodCompra > '''+'0'+''')';
    dmdados.TbPatrimonio.Filtered:=True;
    If cmbDestino.Text= 'V�deo' Then
  	  QRVendidos.RPVendidos.Preview
    else
    	QRVendidos.RPVendidos.Print;
    dmdados.TbPatrimonio.Filtered:=False;
    QRVendidos.Free;
  end;
  cmbClassif.SetFocus;
end;

procedure TFrmRelPatrimonio.FormShow(Sender: TObject);
begin
  FrmPrincipal.StatusTeclas(True,'[F2] Imprimir [Esc] Cancelar ou Sair');
end;

procedure TFrmRelPatrimonio.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  FrmPrincipal.StatusTeclas(False,'');
  Action:= Cafree;
end;

procedure TFrmRelPatrimonio.FormKeyPress(Sender: TObject; var Key: Char);
begin
  If Key=#13 Then
    Begin
    Key:=#0;
    Perform(wm_nextdlgctl,0,0);
    End;
end;

procedure TFrmRelPatrimonio.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if dmdados.HabilitaTeclado then
    case (key) of
      // Teclas de a��o na tabela
      VK_F2    :  if btnimprimir.Enabled then Btnimprimir.Click;
      VK_ESCAPE : BtnSair.Click;
    end;
end;

procedure TFrmRelPatrimonio.cmbDestinoChange(Sender: TObject);
Var
  x:integer;
  Flag:Boolean;
begin
 If cmbDestino.Text= '' then
      Begin
      ShowMessage('� obrigat�rio informar o destino do relat�rio');
      cmbDestino.SetFocus;
      End
   Else
      Begin
      Flag:=True;
      For x:=0 to cmbDestino.Items.Count-1 Do
        If cmbDestino.Text=cmbDestino.Items[x] Then
          Flag:=False;
      If Flag Then
        Begin
        ShowMessage('Valor inv�lido');
        cmbDestino.SetFocus;
        End
      else
        begin
        speedbar1.SetFocus;
        btnImprimir.Enabled:=true;
        end;
      end;
end;

procedure TFrmRelPatrimonio.cmbDestinoCloseUp(Sender: TObject);
Var
  x:integer;
  Flag:Boolean;
begin
 If cmbDestino.Text= '' then
      Begin
      ShowMessage('� obrigat�rio informar o destino do relat�rio');
      cmbDestino.SetFocus;
      End
   Else
      Begin
      Flag:=True;
      For x:=0 to cmbDestino.Items.Count-1 Do
        If cmbDestino.Text=cmbDestino.Items[x] Then
          Flag:=False;
      If Flag Then
        Begin
        ShowMessage('Valor inv�lido');
        cmbDestino.SetFocus;
        End
      else
        begin
        speedbar1.SetFocus;
        btnImprimir.Enabled:=true;
        end;
      end;
end;

procedure TFrmRelPatrimonio.FormCreate(Sender: TObject);
begin
  dmdados.tbFornecedor.Open;
  dmdados.TbComprador.Open;
  dmdados.TbPatrimonio.Open;
  dmdados.tbParametro.Open;
end;

end.
