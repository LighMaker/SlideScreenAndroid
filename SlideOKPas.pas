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
    Button1: TButton;
    ScrollBar1: TScrollBar;
    FloatAnimation1: TFloatAnimation;
    GridLayout3: TGridLayout;
    Rectangle1: TRectangle;
    procedure ScrollBar1Change(Sender: TObject);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Single);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure FloatAnimation1Finish(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Form3: TForm3;                //détermine si c'est la premiere fois qu'on active la procédure OnMove,
  FirstTime:boolean=true;       //c'est a dire si c'est la premiere fois qu'on touche l'écran (1er touché du OnMove)
  PosX,IndexPage,               //PosX=position du premier touché, IndexPage=Index page en cours (commence à 0)
  IndexMaxPage:integer;         //IndexMaxPage=Nbre de page Max
  La,Ha : integer;              //Largeur et hauteur de l'écran

implementation

{$R *.fmx}

procedure TForm3.FloatAnimation1Finish(Sender: TObject);
begin
  FloatAnimation1.Enabled:=False;
  FirstTime:=True;              //Lorsque l'animation est terminée on remet FirstTime à true pour relever la nouvelle posistion du 1er touché
  PosX:=0;                      //remise à 0 du premier touché
end;

procedure TForm3.FormCreate(Sender: TObject);   // à la création de la page et aussi quand on la ReSize pour prendre en compte la rotation du tél
begin                                           // C'est pourquoi le Form.OnResize=Form.OnCreate
   La:=Screen.Width;          // releve la largeur de l'écran
   Ha:=Screen.Height;         // releve la hauteur de l'écran

   IndexPage:=0;              // Valeur initial de IndexPage
   IndexMaxPage:=2;           // Valeur Max de IndexPage. On a nbre de page = IndexMaxPage+1, car indexPage commence à 0

   ScrollBar1.Max:=           //Le curseur de la ScrollBox = (le nbre de page - 1) soit IndexMaxPage + 20 qui est la largeur du curseur
   La*(IndexMaxPage)+20;      // de cette manière quand on est sur la dernière page le curseur sera a son max sur la droite

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
end;

procedure TForm3.FormMouseMove(Sender: TObject; Shift: TShiftState; X,Y: Single);
  var
  XInt:integer;         //Xint pour convertir en entier la position X qui est en single (float)
begin
  If FirstTime then     // Si on vient de poser le doigt alors
  begin
    PosX:=Round(X) ;    // on repeère le X de ce premier touché
    FirstTime:=false
  end;
  Xint:=Round(X);       // on convertit X (single) en valeur entière dans Xint
  ScrollBar1.Value:=round(PosX-X)+IndexPage*La;
  // La valeur du ScrollBar.Value = l'écart entre le 1er touché et la position ectuelle du doigt
  // auquel on rajoute l'index de la page x la largeur de l'écran. Sinon on se retrouverait chaque
  // fois en 1ere page !
  // Le fait de changer la valeur de ScrollBar.Value entraine l'activation de la procédure
  // ScrollBar.Onchange  (cf plus bas)
end;

procedure TForm3.FormMouseUp(Sender: TObject; Button: TMouseButton;Shift: TShiftState; X, Y: Single);
begin
  if ScrollBar1.Value > La*IndexPage + (La/2) then  // Si on deplace à droite le Layout de plus de la moitié de l'écran, alors on change de page
  begin
    inc(IndexPage);                //Pour ça on augmente l'index
    if IndexPage>IndexMaxPage then IndexPage:=IndexMaxPage; //On vérirfie si on ne dépasse pas l'index Maximum
  end else
  if ScrollBar1.Value < La*IndexPage - (La/2) then  //Sinon si on déplace à gauche le Layout de plus de la moitie de l'écran
  begin
    dec(IndexPage);               //on diminue l'index
    if IndexPage<0 then IndexPage:=0;    //on vérifie qu'il n'est pas inférieur à 0
  end;
  FloatAnimation1.StartValue:=ScrollBar1.Value;  //On démarre l'animation de la valeur de là ou est le doigt
  FloatAnimation1.StopValue:=IndexPage*(La);     //On termine l'animation à la position X de l'écran correspond à IndexPage
  FirstTime:=True;                               // Comme on a lever le doigt de l'écran on remet FirstTime à 0
  PosX:=0;                                       // Pareil pour la position du 1er touché
  FloatAnimation1.Enabled:=True;                 // On lance l'animation qui permet de mettre le Layout choisi à sa place
end;

procedure TForm3.ScrollBar1Change(Sender: TObject);
begin
                                         //Positionne la Layout1 selon la valeur de ScrollBar1.value pour faire "glisser" l'écran
  Layout1.Position.X:=-ScrollBar1.Value; // Pour que l'écran glisse dans le sens du doigt, il faut inverser les signes de Layout1.Position.x et de
                                         //ScrollBar1.value
end;

end.
