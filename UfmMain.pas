//8. Закраска произвольной области (задаются цвет границы и цвет закраски)
// Алгоритм с затравкой
unit UfmMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ImgList, ActnList, StdActns, ExtCtrls,
  UStack, ColorGrd, StdCtrls, Spin, Buttons;

type
  TfmMain = class(TForm)
    menuMain: TMainMenu;
      mFile: TMenuItem; 
        nClose: TMenuItem;
      mArea: TMenuItem;  
        nFill: TMenuItem;
      mHelp: TMenuItem; 
    ilMain: TImageList;
    Image: TImage;   
    alMain: TActionList; 
      FileOpen: TFileOpen;
      FileExit: TFileExit;
      FloodFill: TAction;
    gbToolBox: TGroupBox;
    lbStart: TLabel;
    spinX: TSpinEdit;
    spinY: TSpinEdit;
    lbX: TLabel;
    lbY: TLabel;
    lbColor: TLabel;
    dlgColor: TColorDialog;
    pColor: TPanel;
    lbMask: TLabel;
    btnLoadMask: TBitBtn;
    btnFloodFill: TBitBtn;
    Splitter: TGroupBox;
    procedure FloodFillExecute(Sender: TObject);
    procedure pColorClick(Sender: TObject);
    procedure ImageMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FileOpenAccept(Sender: TObject);
    procedure spinChange(Sender: TObject);
  private
    function Point(X, Y: Integer): TPoint;
    procedure Draw(P: TPoint);
    function InArea(P: TPoint): Boolean;
    function OutArea(P: TPoint): Boolean;
    function Filled(P: TPoint): Boolean;
    function NotFilled(P: TPoint): Boolean;
  public
    StartPoint: TPoint;
    Color: TColor;
    Mask: TBitmap;
  end;

var
  fmMain: TfmMain;

implementation

{$R *.dfm}

function TfmMain.Point(X, Y: Integer): TPoint;
begin
  Result.X := X;
  Result.Y := Y;
end;

function TfmMain.InArea(P: TPoint): Boolean;
begin
  Result := Mask.Canvas.Pixels[P.X, P.Y] <> clBlack;
end;
    
function TfmMain.OutArea(P: TPoint): Boolean;
begin
  Result := Mask.Canvas.Pixels[P.X, P.Y] = clBlack;
end;

function TfmMain.Filled(P: TPoint): Boolean;
begin
  Result := Image.Canvas.Pixels[P.X, P.Y] = Color;
end;

function TfmMain.NotFilled(P: TPoint): Boolean;
begin
  Result := Image.Canvas.Pixels[P.X, P.Y] <> Color;
end;

procedure TfmMain.Draw(P: TPoint);
begin
  Image.Canvas.Pixels[P.X, P.Y] := Color;  
  Application.ProcessMessages;
end;

procedure TfmMain.FloodFillExecute(Sender: TObject);
var
  S: TStack;
  P: TPoint;
  Xstart, Xleft, Xright, Xtmp: Integer;
  flag: Boolean;

  procedure Loop;
  begin
    while P.X <= Xright do begin
      flag := False;
      while InArea(P) and NotFilled(P) do begin
        flag := True;
        Inc(P.X);
      end;
      if flag then
        S.Push(Point(P.X-1, P.Y));
      Xtmp := P.X;
      while (OutArea(P) or Filled(P)) and (P.X <= Xright) do
        Inc(P.X);
      if P.X = Xtmp then
        Inc(P.X);
    end;
  end;
begin
  S := TStack.Create;
  S.Push(StartPoint);
  while not S.IsEmpty do begin
    P := S.Pop;
    Draw(P);
    Xstart := P.X;
    Inc(P.X);
    while InArea(P) do begin //fill right
      Draw(P);
      Inc(P.X);
    end;
    Xright := P.X - 1;
    P.X := Xstart - 1;
    while InArea(P) do begin //fill left
      Draw(P);
      Dec(P.X);
    end;
    Xleft := P.X + 1;
    Inc(P.X);
    Inc(P.Y);
    Loop;
    P.X := Xleft;
    Dec(P.Y,2);
    Loop;
  end
end;

procedure TfmMain.pColorClick(Sender: TObject);
begin
  if dlgColor.Execute then
    Color := dlgColor.Color;
  pColor.Color := Color;
end;

procedure TfmMain.ImageMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  spinX.Value := X;
  StartPoint.X := X;
  spinY.Value := Y;
  StartPoint.Y := Y;
end;

procedure TfmMain.FileOpenAccept(Sender: TObject);
begin
  Mask := TBitmap.Create;
  Mask.LoadFromFile(FileOpen.Dialog.FileName);
  Image.Canvas.Draw(0,0,Mask);
end;

procedure TfmMain.spinChange(Sender: TObject);
begin
  StartPoint.X := spinX.Value;
  StartPoint.Y := spinY.Value
end;

end.
