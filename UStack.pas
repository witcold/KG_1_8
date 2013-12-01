unit UStack;

interface

uses
  Windows;

type
  TData = TPoint;

  PNode = ^TNode;
  TNode = record
    Data: TData;
    Next: PNode;
  end;
  TStack = class
  private
    Head: PNode;
  public
    constructor Create;
    destructor Destroy; override;
    function IsEmpty: Boolean;
    procedure Push (const Value: TData);
    function Pop: TData;
    procedure Clear;
  end;

implementation

constructor TStack.Create;
begin
  Head := nil
end;

destructor TStack.Destroy;
begin
  Clear
end;

function TStack.IsEmpty: Boolean;
begin
  Result := (Head = nil)
end;

function TStack.Pop: TData;
var
  tmp: PNode;
begin
  if (Head <> nil) then begin
    tmp := Head;
    with Head^ do begin
      Result := Data;
      Head := Next
    end;
    Dispose(tmp)
  end
end;

procedure TStack.Push(const Value: TData);
var
  tmp: PNode;
begin
  New(tmp);
  with tmp^ do begin
    Data := Value;
    Next := Head
  end;
  Head := tmp
end;

procedure TStack.Clear;
begin
  while (Head <> nil) do
    Pop
end;

end.
