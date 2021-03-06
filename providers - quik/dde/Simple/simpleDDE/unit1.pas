//----------------------------------------------------------------------------//
// ������ ������ ������������ ������ ������ DdeExlUnt                         //
// ���� ��������� - ����� ����� ������� �� Quik �� DDE                         //
//                                                                            //
// ---------------------------------------------------------------------------//


unit unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Grids, DdeExlUnt, Math, XPMan;

type
  TForm1 = class(TForm)
    StringGrid1: TStringGrid;
    Memo1: TMemo;
    Splitter1: TSplitter;
    Panel1: TPanel;
    Button1: TButton;
    XPManifest1: TXPManifest;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    procedure OnDdePoke(Topic: string; var Action: TPokeAction);
    procedure OnDdeData(Topic: string; Cells: TRect; Data: TVariantTable);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
  // ������� ��������� �������, ���������� ��� ������� � DdeExlUnt
  DdeExcel := TDdeExcel.Create(self);
  // ��������� ����������� ������� ��� �������
  DdeExcel.OnPoke := OnDdePoke;
  DdeExcel.OnData := OnDdeData
end;

procedure TForm1.OnDdePoke(Topic: string; var Action: TPokeAction);
// ���������� ������� OnPoke, ��������� ����� Quik ��������� �������� ������
// Topic �������� ��� ������������ ������� � ������� "[�����1]����1"
// Action - ��� ���� ������� �� ����������� ������, ��������:
//   Action := paAccept // ��, �� ����� �������� ������
//   Action := paReject // ���, �� �� ����� ������ (������ ������� ��� ���� ���������)
//   Action := paMiss   // ������ ������ �� �����, �� ������� ����� ������������ (�� Quik �����
//                      // �������, ��� ������ �� �������; ����� ���-�� ��������)
begin
  Action := paAccept
end;

procedure TForm1.OnDdeData(Topic: string; Cells: TRect; Data: TVariantTable);
// ���������� ������, ������� OnData ��������� ����� OnPoke ���� �� ������ Action := paAccept
// Topic - ��� ������������ �������
// Cells - �������� ������������ ����� (��������� ����� ���������� � 1
// Data - �������� ������ ������������ ������. �.�. ������ � 0 � ������� Data - ���
//    ������ � Cells.Top � ����� �������
var
  i, j: integer;
begin
  // ��������� ��� ����� ������� � ����� ������ ���������
  Memo1.Lines.Add(TimeToStr(now)+ ': ������ ��� ���� '''+Topic+''', � ������ R'+inttostr(Cells.Top)+
      'C'+inttostr(Cells.Left)+':R'+inttostr(Cells.Bottom)+'C'+inttostr(Cells.Right));
  // ������ ������ �����
  StringGrid1.RowCount := max(StringGrid1.RowCount, Cells.Bottom+1);
  StringGrid1.ColCount := max(StringGrid1.ColCount, Cells.Right+1);
  // ��������� ����� ��������� �� ������� 0
  For i :=  Cells.Top to Cells.Bottom do
    For j := Cells.Left to Cells.Right do
      If (Data.Cells[i-Cells.Top, j-Cells.Left] <> '0') and (Data.Cells[i-Cells.Top, j-Cells.Left] <> '0,00') then
        StringGrid1.Cells[j, i] := Data.Cells[i-Cells.Top, j-Cells.Left];
end;


procedure TForm1.Button1Click(Sender: TObject);
var
  i, j: integer;
begin
  // ������� ����� � ����
  For i := 0 to StringGrid1.RowCount-1 do
    For j := 0 to StringGrid1.ColCount-1 do
      StringGrid1.Cells[j, i] := '';
  StringGrid1.RowCount := 2;
  StringGrid1.ColCount := 2;
  Memo1.Clear;
end;

end.
