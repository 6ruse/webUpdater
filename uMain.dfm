object FrmMain: TFrmMain
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1054#1073#1085#1086#1074#1083#1077#1085#1080#1077' '#1087#1088#1086#1075#1088#1072#1084#1084#1085#1086#1075#1086' '#1086#1073#1077#1089#1087#1077#1095#1077#1085#1080#1103
  ClientHeight = 445
  ClientWidth = 645
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object RichLog: TRichEdit
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 639
    Height = 350
    Align = alTop
    Color = cl3DLight
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    Lines.Strings = (
      'RichLog')
    ParentFont = False
    TabOrder = 0
  end
  object btnClose: TcxButton
    Left = 548
    Top = 407
    Width = 75
    Height = 25
    Caption = #1047#1072#1082#1088#1099#1090#1100
    TabOrder = 1
    OnClick = btnCloseClick
  end
  object btnUpdateWeb: TcxButton
    Left = 384
    Top = 407
    Width = 158
    Height = 25
    Caption = #1054#1073#1085#1086#1074#1080#1090#1100' '#1087#1088#1086#1075#1088#1072#1084#1084#1091
    TabOrder = 2
    OnClick = btnUpdateWebClick
  end
end
