{ -----------------------------------------------------------------------------
  ArtPanel.pas            Copyright © 1998-2001 by DithoSoft Software Solutions
  Version 2.6                                           http://www.dithosoft.de
  -----------------------------------------------------------------------------
  Panel that can display transparent bitmaps as edges.
  -----------------------------------------------------------------------------
  Version history:

  1.0    - first non-public release
  1.01   - first public release
  2.0    - revised version additional features
  2.5    - Tested for Delphi 5 compatibility
  2.5a   - Improved Delphi 5 compatibility
  2.6    - Delphi 6 compatibility and new properties
  -----------------------------------------------------------------------------
  Property Description
    property AlignmentHorz: TAlignment
             The horizontal alignment of the text in the panel.

    property AlignmentVert: TAlignmentVert
             The vertical alignment of the text in the panel.

    property ColorHighlight: TColor
             The color of the highlight areas of the bevels.

    property ColorShadow: TColor
             The color of the shadow areas of the bevels.

    property EdgeTopLeft: TBitmap
             The bitmap used for the Top/Left edge.

    property EdgeTopRight: TBitmap
             The bitmap used for the Top/Right edge.

    property EdgeBottomLeft: TBitmap
             The bitmap used for the Bottom/Left edge.

    property EdgeBottomRight: TBitmap
             The bitmap used for the Bottom/Right edge.

    property EdgesTransparent: Boolean
             Determines whether to display the edges transparently or not
             (Bottom/Left pixel indicates the transparent color)
  ---------------------------------------------------------------------------- }
unit ArtPanel;

{$DEFINE DELPHI5OR6}
{$IFNDEF VER130}
  {$IFNDEF VER140}
    {$UNDEF DELPHI5OR6}
  {$ENDIF}
{$ENDIF}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls;

type
  { TAlignmentVert }
  TAlignmentVert = (tavTop, tavCenter, tavBottom);

  { TArtPanel }
  TArtPanel = class(TCustomPanel)
  private
    FAlignmentHorz   : TAlignment;
    FAlignmentVert   : TAlignmentVert;
    FEdgeTopLeft,
    FEdgeTopRight,
    FEdgeBottomLeft,
    FEdgeBottomRight : TBitmap;
    FEdgesTransparent: Boolean;
    FColorHighlight,
    FColorShadow     : TColor;
  protected
    procedure SetAlignmentHorz(Value: TAlignment); virtual;
    procedure SetAlignmentVert(Value: TAlignmentVert); virtual;
    procedure SetEdge(Index: Integer; Value: TBitmap); virtual;
    procedure SetEdgesTransparent(Value: Boolean); virtual;
    procedure SetColorHighlight(Value: TColor); virtual;
    procedure SetColorShadow(Value: TColor); virtual;
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
  published
    property Align;
    property AlignmentHorz: TAlignment read FAlignmentHorz write SetAlignmentHorz;
    property AlignmentVert: TAlignmentVert read FAlignmentVert write SetAlignmentVert;
    {$IFDEF DELPHI5OR6}
    property Anchors;
    property AutoSize;
    {$ENDIF}
    property BevelInner;
    property BevelOuter;
    property BevelWidth;
    {$IFDEF DELPHI5OR6}property BiDiMode;{$ENDIF}
    property BorderWidth;
    property BorderStyle;
    property Caption;
    property Color;
    property ColorHighlight: TColor read FColorHighlight write SetColorHighlight;
    property ColorShadow: TColor read FColorShadow write SetColorShadow;
    {$IFDEF DELPHI5OR6}property Constraints;{$ENDIF}
    property Ctl3D;
    property Cursor;
    {$IFDEF DELPHI5OR6}property DockSite;{$ENDIF}
    property DragCursor;
    {$IFDEF DELPHI5OR6}property DragKind;{$ENDIF}
    property DragMode;
    property EdgeTopLeft: TBitmap index 0 read FEdgeTopLeft write SetEdge;
    property EdgeTopRight: TBitmap index 1 read FEdgeTopRight write SetEdge;
    property EdgeBottomLeft: TBitmap index 2 read FEdgeBottomLeft write SetEdge;
    property EdgeBottomRight: TBitmap index 3 read FEdgeBottomRight write SetEdge;
    property EdgesTransparent: Boolean read FEdgesTransparent write SetEdgesTransparent;
    property Enabled;
    property Font;
    {$IFDEF DELPHI5OR6}property FullRepaint;{$ENDIF}
    property Locked;
    {$IFDEF DELPHI5OR6}property ParentBiDiMode;{$ENDIF}
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    {$IFDEF DELPHI5OR6}property UseDockManager;{$ENDIF}
    property Visible;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
    property OnStartDrag;
  end;

implementation

{ TArtPanel }
constructor TArtPanel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  { Set default values }
  FAlignmentHorz    := taCenter;
  FAlignmentVert    := tavCenter;
  FColorHighlight   := clBtnHighlight;
  FColorShadow      := clBtnShadow;
  FEdgesTransparent := True;

  { Initialize bitmaps }
  FEdgeTopLeft        := TBitmap.Create;
  FEdgeTopRight       := TBitmap.Create;
  FEdgeBottomLeft     := TBitmap.Create;
  FEdgeBottomRight    := TBitmap.Create;
end;

destructor TArtPanel.Destroy;
begin
  { Destroy bitmaps }
  FEdgeTopLeft.Free;
  FEdgeTopRight.Free;
  FEdgeBottomLeft.Free;
  FEdgeBottomRight.Free;

  inherited Destroy;
end;

procedure TArtPanel.Paint;
const
  AlignHorz: array[TAlignment] of Word = (DT_LEFT, DT_RIGHT, DT_CENTER);
  AlignVert: array[TAlignmentVert] of Word = (DT_TOP, DT_VCENTER, DT_BOTTOM);
var
  Rect       : TRect;

  function GetColorTopLeft(Bevel: TPanelBevel): TColor;
  begin
    Result := ColorHighlight;
    if Bevel = bvLowered then
      Result := ColorShadow;
  end;

  function GetColorBottomRight(Bevel: TPanelBevel): TColor;
  begin
    Result := ColorShadow;
    if Bevel = bvLowered then
      Result := ColorHighlight;
  end;

  procedure PaintEdge(IsTop,IsLeft: Boolean; ABitmap: TBitmap);
  var
    BmpRect    : TRect;
    DstRect    : TRect;
    TransCol   : TColor;
  begin
    if ABitmap.Empty then exit;

    { Get control´s client rect }
    Rect := Self.GetClientRect;
    InflateRect(Rect,-1,-1);

    { Get Bitmap´s dimensions and transparent color }
    BmpRect := Bounds(0,0,ABitmap.Width,ABitmap.Height);
    TransCol:= ABitmap.Canvas.Pixels[0,Pred(ABitmap.Height)];
    if not EdgesTransparent then TransCol := clNone;

    { Get destination rectangle }
    DstRect.Top   := Rect.Top;
    DstRect.Left  := Rect.Left;
    DstRect.Right := Rect.Left+ABitmap.Width;
    DstRect.Bottom:= Rect.Top+ABitmap.Height;
    if not IsTop then begin
      DstRect.Bottom := Rect.Bottom;
      DstRect.Top    := Rect.Bottom-ABitmap.Height;
    end;
    if not IsLeft then begin
      DstRect.Right  := Rect.Right;
      DstRect.Left   := Rect.Right-ABitmap.Width;
    end;

    { Paint to canvas }
    Canvas.BrushCopy(DstRect,ABitmap,BmpRect,TransCol);
  end;

begin
  { Clear the "client area" }
  Rect := GetClientRect;
  Canvas.Brush.Color  := Color;
  Canvas.FillRect(Rect);

  { Draw outer bevel if necessary }
  if BevelOuter <> bvNone then
    Frame3D(Canvas,Rect,GetColorTopLeft(BevelOuter),GetColorBottomRight(BevelOuter),BevelWidth);

  { Include the border }
  InflateRect(Rect,-BorderWidth,-BorderWidth);

  { Draw inner bevel if necessary }
  if BevelInner <> bvNone then
    Frame3D(Canvas,Rect,GetColorTopLeft(BevelInner),GetColorBottomRight(BevelInner),BevelWidth);

  with Canvas do begin
    { Draw the caption }
    Brush.Style  := bsClear;
    Font         := Self.Font;
    DrawText(Handle,PChar(Caption),-1,Rect,DT_SINGLELINE or DT_EXPANDTABS or
                                           AlignHorz[AlignmentHorz] or AlignVert[AlignmentVert]);

    { Draw the bitmaps }
    PaintEdge(True,True,EdgeTopLeft);
    PaintEdge(True,False,EdgeTopRight);
    PaintEdge(False,True,EdgeBottomLeft);
    PaintEdge(False,False,EdgeBottomRight);
  end;
end;

procedure TArtPanel.SetAlignmentHorz(Value: TAlignment);
begin
  { Set horizontal text alignment }
  if FAlignmentHorz <> Value then begin
    FAlignmentHorz := Value;
    Invalidate;
  end;
end;

procedure TArtPanel.SetAlignmentVert(Value: TAlignmentVert);
begin
  { Set vertical text alignment }
  if FAlignmentVert <> Value then begin
    FAlignmentVert := Value;
    Invalidate;
  end;
end;

procedure TArtPanel.SetEdge(Index: Integer; Value: TBitmap);
begin
  { Depending on 'Index' set Edge bitmap }
  case Index of
    0: FEdgeTopLeft.Assign(Value);
    1: FEdgeTopRight.Assign(Value);
    2: FEdgeBottomLeft.Assign(Value);
    3: FEdgeBottomRight.Assign(Value);
  end;

  { Repeaint the entire panel }
  Invalidate;
end;

procedure TArtPanel.SetEdgesTransparent(Value: Boolean);
begin
  { Set new value and repaint }
  if FEdgesTransparent <> Value then begin
    FEdgesTransparent := Value;
    Invalidate;
  end;
end;

procedure TArtPanel.SetColorHighlight(Value: TColor);
begin
  { Set new color and repaint }
  if FColorHighlight <> Value then begin
    FColorHighlight := Value;
    Invalidate;
  end;
end;

procedure TArtPanel.SetColorShadow(Value: TColor);
begin
  { Set new color and repaint }
  if FColorShadow <> Value then begin
    FColorShadow := Value;
    Invalidate;
  end;
end;

end.
