page 50107 "Select MR Line"
{
    ApplicationArea = All;
    Caption = 'Select MR Line';
    PageType = Worksheet;
    SourceTable = "Material Req. Line";
    UsageCategory = None;
    InsertAllowed = FALSE;
    ModifyAllowed = TRUE;
    DeleteAllowed = FALSE;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Material Req. No."; Rec."Material Req. No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Style = Strong;
                    ToolTip = 'Material Request asal baris ini. Boleh pilih baris dari MR yang berbeda-beda.';
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    Editable = false;
                    DecimalPlaces = 0 : 5;
                }
                field("Qty to PR"; Rec."Qty to PR")
                {
                    ApplicationArea = All;
                    Editable = true;
                    DecimalPlaces = 0 : 5;
                    ShowMandatory = true;
                    Style = Strong;
                    ToolTip = 'Berapa yang mau dibuatkan PR sekarang. Default = seluruh sisa. Kecilkan angkanya kalau mau partial.';

                    trigger OnValidate()
                    begin
                        CurrPage.UPDATE();
                    end;
                }
                field("Outstanding Quantity"; Rec."Outstanding Quantity")
                {
                    ApplicationArea = All;
                    Editable = false;
                    DecimalPlaces = 0 : 5;
                    Style = Favorable;
                    ToolTip = 'Sisa yang masih bisa dibuatkan Purchase Request. Ini yang akan masuk ke PR.';
                }
                field("Unit of Measure"; Rec."Unit of Measure")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
    }
    trigger OnOpenPage()

    var
        lRecMRLine: Record "Material Req. Line";
    begin

        lRecMRLine.COPYFILTERS(Rec);
        lRecMRLine.SETRANGE("Qty to PR", 0);
        IF lRecMRLine.FINDSET(TRUE) THEN
            REPEAT
                lRecMRLine."Qty to PR" := lRecMRLine."Outstanding Quantity";
                lRecMRLine.MODIFY(FALSE);
            UNTIL lRecMRLine.NEXT = 0;
    end;

    var
        gCodePRNo: Code[50];
}
