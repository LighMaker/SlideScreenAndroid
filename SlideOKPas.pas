unit SlideOKPas;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Layouts, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Edit, FMX.Ani;

type
  TForm3 = class(TForm)
    Layout1: TLayout;
    GridLayout2: TGridLayout;
    GridLayout1: TGridLayout;
    Rectangle2: TRectangle;
    FloatAnimation1: TFloatAnimation;
    GridLayout3: TGridLayout;
    Rectangle1: TRectangle;
    Rectangle3: TRectangle;
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Single);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure FloatAnimation1Finish(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Form3: TForm3;                //détermine si c'est la premiere fois qu'on active la procédure OnMove,
  FirstTime:boolean;            //c'est a dire si c'est la premiere fois qu'on touche l'écran (1er touché du OnMove)
  IndexPage,                    //IndexPage=Index page en cours (commence à 0)
  IndexMaxPage:integer;         //IndexMaxPage=Nbre de page Max
  La,Ha : integer;              //Largeur et hauteur de l'écran
  PosX : Single;                //PosX=position du premier touché,

implementation

{$R *.fmx}

procedure TForm3.FormCreate(Sender: TObject);   // à la création de la page et aussi quand on la ReSize pour prendre en compte la rotation du tél
begin                                           // C'est pourquoi le Form.OnResize=Form.OnCreate
     La:=Screen.Width;          // releve la largeur de l'écran
     Ha:=Screen.Height;         // releve la hauteur de l'écran
     IndexPage:=0;              // Valeur initial de IndexPage
     IndexMaxPage:=2;           // Valeur Max de IndexPage. On a nbre de page = IndexMaxPage+1, car indexPage commence à 0
     Layout1.Width:=La*(IndexMaxPage+1);   // Le Layout 1 doit fait la largeur de l'écran x le nbre de page
     Layout1.Height:=Ha;           // La hauteur de Layout1 est celle de l'écran
     Layout1.Position.X:=0;        // La position X de Layout1 est 0
     Layout1.Position.Y:=0;        // La position Y de Layout1 est 0
     GridLayout1.Width:=La;        // Chaque sous-grille a la largeur de l'écran
     GridLayout1.Height:=Ha;       // Chaque sous-grille a la heuteur de l'écran
     GridLayout1.Position.X:=0;    // La 1ere sous grille est en position X=0
     GridLayout2.Width:=La;
     GridLayout2.Height:=Ha;
     GridLayout2.Position.X:=La;   // la 2eme sous-grille est en position X=La*1, la 3eme en positionX= La*2 etc..en fait La x son index
     GridLayout3.Width:=La;
     GridLayout3.Height:=Ha;
     GridLayout3.Position.X:=La*2;
     FirstTime:=False;
end;

procedure TForm3.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
  PosX:=X;         //repère la position du premier touché
  FirstTime:=True;
end;

procedure TForm3.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Single);
begin
  if FirstTime then
  begin
    if X-PosX-IndexPage*La<40 then            //bloque la première page pour l'empecher de reculer
    Layout1.Position.X :=X-PosX-IndexPage*La; // La position du layout=position du doigt actuelle - celle de départ
  end;                                        //en tenant compte de l'index de la page (Sinon on se retrouverait chaque fois en 1ere page !)
end;

procedure TForm3.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
  if abs(Layout1.Position.X) > La*IndexPage + (La/3) then  //Si on deplace à droite le Layout de + de la moitié de l'écran,on change de page
  begin
    inc(IndexPage);                //Pour ça on augmente l'index
    if IndexPage>IndexMaxPage then IndexPage:=IndexMaxPage; //On vérirfie si on ne dépasse pas l'index Maximum
  end else
  if abs(Layout1.Position.X) < La*IndexPage - (La/3) then  //Sinon si on déplace à gauche le Layout de plus de la moitie de l'écran
  begin
    dec(IndexPage);                      //on diminue l'index
    if IndexPage<0 then IndexPage:=0;    //on vérifie qu'il n'est pas inférieur à 0
  end;
  FirstTime:=False;                               // Comme on a lever le doigt de l'écran on remet FirstTime à false
  FloatAnimation1.StartValue:=Layout1.Position.X; //On démarre l'animation de la valeur de là ou est le doigt
  FloatAnimation1.StopValue:=-IndexPage*(La);     //On termine l'animation à la position X de l'écran correspond à IndexPage
  PosX:=0;                                        // Pareil pour la position du 1er touché
  FloatAnimation1.Enabled:=True;                  // On lance l'animation qui permet de mettre le Layout choisi à sa place
end;

procedure TForm3.FloatAnimation1Finish(Sender: TObject);
begin
  FloatAnimation1.Enabled:=False;
  PosX:=0;    //remise à 0 du premier touché
end;

end.
