unit formMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Samples.Spin;

type
  TForm2 = class(TForm)
    btnCalculer: TButton;
    seEdit: TSpinEdit;
    lbTotal: TLabel;
    procedure btnCalculerClick(Sender: TObject);
  private
    iNbTotal, iCompte: Int64;
    iWidth           : integer;
    procedure CheckPoint(aPoint: TPoint);
  public
    { D�clarations publiques }
  end;

var
  Form2: TForm2;

implementation

uses
   System.Diagnostics;

{$R *.dfm}

procedure TForm2.CheckPoint(aPoint: TPoint);
var
   i: integer;
begin
   while (aPoint.X <> iWidth) and (aPoint.Y <> iWidth) do
   begin
      if (aPoint.X < iWidth) and (aPoint.Y < iWidth) then
      begin
         // si deux chemins sont dispo. on en cr�� un qui descend
         // et on boucle r�cursivement jusqu'a atteindre le point 20;20
         CheckPoint(TPoint.Create(aPoint.X, aPoint.Y + 1));

         // et le point actuel va vers la droite
         aPoint.X := aPoint.X + 1;
      end else
      if aPoint.X < iWidth then
      begin
         aPoint.X := aPoint.X + 1;
      end else
      if aPoint.Y < iWidth then
      begin
         aPoint.Y := aPoint.Y + 1;
      end;
   end;

   // nombre total de chemins incr�ment� de 1
   Inc(iNbTotal);

   // mise � jour d'un compteur par paquet de 10Mio
   // plus rapide de faire ainsi que iFin mod 10Mio
   Inc(iCompte);
   if iCompte = 10000000 then
   begin
      iCompte         := 0;
      lbTotal.Caption := iNbTotal.ToString;

      // notification de mise � jour
      Application.ProcessMessages;
   end;
end;

procedure TForm2.btnCalculerClick(Sender: TObject);
var
   Chrono: TStopwatch;
begin
   iWidth   := seEdit.Value;

   // attention � bien utilis� le type Int64 plut�t que integer
   // car on arrive rapidement aux bornes
   iNbTotal := 0;
   iCompte  := 0;

   // cr�ation d'un chrono et affichage en seconde de la dur�e du traitement
   Chrono   := TStopwatch.StartNew;

   // cr�ation du point d'origine
   CheckPoint(TPoint.Create(0, 0));

   Chrono.Stop;

   lbTotal.Caption := '>' + iNbTotal.ToString + ' en ' + (Chrono.ElapsedMilliseconds div 1000).ToString + ' secondes';
end;

end.
