program frmWarehouse_p;

uses
  Vcl.Forms,
  frmWarehouse_u in 'frmWarehouse_u.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
