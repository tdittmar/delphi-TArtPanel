unit ArtPanelReg;

interface

procedure Register;

implementation

uses ArtPanel, Classes,
     {$IFDEF VER140}DesignIntf, DesignEditors, VCLEditors{$ELSE}DsgnIntf{$ENDIF};

procedure Register;
begin
  RegisterComponents('Freeware', [TArtPanel]);

  {$IFDEF VER130}
  RegisterPropertiesInCategory(TVisualCategory,TArtPanel,
                               ['AlignmentHorz','AlignmentVert','ColorHighlight',
                                'ColorShadow','EdgeTopLeft','EdgeTopRight',
                                'EdgeBottomLeft','EdgeBottomRight',
                                'EdgesTransparent']);
  {$ENDIF}
end;

end.
 