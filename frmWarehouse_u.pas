unit frmWarehouse_u;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, System.Types,
  Vcl.StdCtrls,
  Vcl.Imaging.pngimage, jpeg;

type
  TForm1 = class(TForm)
    EnemyTimer: TTimer;
    Level: TLabel;
    LevelTimer: TTimer;
    lblScore: TLabel;
    ScoreTimer: TTimer;
    lblHighScore: TLabel;
    Player: TImage;
    Enemy: TImage;
    Path: TLabel;
    GameImage: TImage;
    HUD: TImage;
    btnStart: TImage;
    procedure EnemyTimerTimer(Sender: TObject);
    procedure LevelTimerTimer(Sender: TObject);
    procedure ScoreTimerTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure GameImageMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure btnStartClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.btnStartClick(Sender: TObject);
begin
  btnStart.Enabled := False;

  HUD.Picture.LoadFromFile(Path.Caption + 'HUD with START OFF.png');
  GameImage.Picture.LoadFromFile(Path.Caption + 'Level1.png');
  GameImage.Tag := 1;

  // We reset the game elements
  Enemy.Left := 8;
  Enemy.Top := 8;
  Enemy.visible := true;

  Player.Left := 326;
  Player.Top := 400;
  Player.visible := true;

  Level.Tag := 1;
  Level.Caption := '1';

  lblScore.Tag := 0;
  lblScore.Caption := '0';

  // Start the game timers
  EnemyTimer.Enabled := true;
  LevelTimer.Enabled := true;
  ScoreTimer.Enabled := true;
end;

procedure TForm1.EnemyTimerTimer(Sender: TObject);
var
  Overlay: TRect;
begin
  // Simple AI
  if Enemy.Left < Player.Left then
    Enemy.Left := Enemy.Left + Level.Tag;
  if Enemy.Left > Player.Left then
    Enemy.Left := Enemy.Left - Level.Tag;
  if Enemy.Top > Player.Top then
    Enemy.Top := Enemy.Top - Level.Tag;
  if Enemy.Top < Player.Top then
    Enemy.Top := Enemy.Top + Level.Tag;

  // Collision detection dode
  if IntersectRect(Overlay, Player.BoundsRect, Enemy.BoundsRect) then
  begin
    // The Enemy caught Player
    EnemyTimer.Enabled := False;
    LevelTimer.Enabled := False;
    ScoreTimer.Enabled := False;

    // Update the HUD
    HUD.Picture.LoadFromFile(Path.Caption + 'HUD with START ON.png');

    Enemy.visible := False;
    Player.visible := False;

    // Chek and set the  highscore
    if lblScore.Tag > lblHighScore.Tag then
    begin
      lblHighScore.Tag := lblScore.Tag;
      lblHighScore.Caption := IntToStr(lblHighScore.Tag);
      GameImage.Picture.LoadFromFile(Path.Caption + 'Set New High Score.png');
    end
    else

      GameImage.Picture.LoadFromFile(Path.Caption + 'Game Over.png');
    btnStart.Enabled := true;
  end;

end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Path.Caption := ExtractFilePath(Application.ExeName);
  GameImage.Picture.LoadFromFile(Path.Caption + 'Start Game.png');
  HUD.Picture.LoadFromFile(Path.Caption + 'HUD with START ON.png');
end;

procedure TForm1.LevelTimerTimer(Sender: TObject);
begin
  Level.Tag := Level.Tag + 1;
  Level.Caption := IntToStr(Level.Tag);

  if Level.Tag mod 2 = 1 then
  begin
    GameImage.Tag := GameImage.Tag + 1;
    if GameImage.Tag > 16 then
      GameImage.Tag := 1;
    GameImage.Picture.LoadFromFile(Path.Caption + 'Level' +
      IntToStr(GameImage.Tag) + '.png');
  end;

end;

procedure TForm1.ScoreTimerTimer(Sender: TObject);
begin
  lblScore.Tag := lblScore.Tag + Level.Tag * 8;
  lblScore.Caption := IntToStr(lblScore.Tag);
end;

procedure TForm1.GameImageMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  if EnemyTimer.Enabled = true then
  begin
    Player.Left := X - Player.Width div 2;
    Player.Top := Y - Player.Height div 2;
  end;
end;

end.
