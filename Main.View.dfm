object MainView: TMainView
  Left = 0
  Top = 0
  Cursor = crHandPoint
  Caption = 'IFutur Demo'
  ClientHeight = 435
  ClientWidth = 690
  Color = 8405571
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -19
  Font.Name = 'Bahnschrift SemiLight SemiConde'
  Font.Style = []
  Font.Quality = fqClearTypeNatural
  OnCreate = FormCreate
  TextHeight = 23
  object Img_Future: TImage
    Left = 0
    Top = 10
    Width = 690
    Height = 295
    Align = alClient
    Center = True
    ExplicitLeft = 256
    ExplicitTop = 8
    ExplicitWidth = 289
    ExplicitHeight = 225
  end
  object Pnl_Status: TPanel
    Left = 0
    Top = 394
    Width = 690
    Height = 41
    Align = alBottom
    Alignment = taLeftJustify
    BevelOuter = bvNone
    Caption = ' IFuture Progress Status'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindow
    Font.Height = -19
    Font.Name = 'Bahnschrift SemiLight SemiConde'
    Font.Style = []
    Font.Quality = fqClearTypeNatural
    ParentFont = False
    TabOrder = 0
    ExplicitTop = 386
    ExplicitWidth = 688
    object Btn_Run: TButton
      Left = 481
      Top = 0
      Width = 209
      Height = 41
      Cursor = crHandPoint
      Align = alRight
      Caption = 'Run Future thing'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -20
      Font.Name = 'Bahnschrift SemiLight SemiConde'
      Font.Style = []
      Font.Quality = fqClearTypeNatural
      ParentFont = False
      TabOrder = 0
      OnClick = Btn_RunClick
      ExplicitLeft = 479
    end
  end
  object Progress_Future: TProgressBar
    Left = 0
    Top = 0
    Width = 690
    Height = 10
    Align = alTop
    TabOrder = 1
    ExplicitWidth = 688
  end
  object Memo_Log: TMemo
    Left = 0
    Top = 305
    Width = 690
    Height = 89
    Align = alBottom
    Color = 5192749
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clLime
    Font.Height = -19
    Font.Name = 'Bahnschrift SemiLight SemiConde'
    Font.Style = []
    Font.Quality = fqClearTypeNatural
    ParentFont = False
    TabOrder = 2
    ExplicitTop = 299
  end
end
