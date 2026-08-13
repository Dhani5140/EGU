tableextension 50109 "Item Journal Line Ext" extends "Item Journal Line"
{
    fields
    {
        modify("Gen. Bus. Posting Group")
        {
            trigger OnBeforeValidate()
            begin
                IF (xRec."Gen. Bus. Posting Group" <> '') AND (Rec."Gen. Bus. Posting Group" <> '') THEN IF "Material Req. No." <> '' THEN ERROR('This document is from Material Request, Cannot change gen bus');
            end;
        }
        modify("Shortcut Dimension 1 Code")
        {
            trigger OnAfterValidate()
            begin
                VALIDATE("Gen. Bus. Posting Group", gCUMSIFunct.getGenBusfromMapping("Shortcut Dimension 1 Code", "Unit Group", "MR Usage Category"));
            end;
        }
        modify("Entry Type")
        {
            trigger OnAfterValidate()
            begin
                IF Rec."Entry Type" <> Rec."Entry Type"::"Negative Adjmt." THEN BEGIN
                    IF ("Material Req. No." <> '') AND ("Material Req. Line No." <> 0) THEN BEGIN
                        ERROR('This line is from material request %1, cannot change entry type', "Material Req. No.");
                    END;
                END;
            END;
        }
        modify(Quantity)
        {
            trigger OnAfterValidate()
            begin
                IF xRec.Quantity <> Rec.Quantity THEN BEGIN
                    IF ("Material Req. No." <> '') AND ("Material Req. Line No." <> 0) THEN BEGIN
                        gRecMRLine.RESET;
                        gRecMRLine.SETRANGE("Material Req. No.", "Material Req. No.");
                        gRecMRLine.SETRANGE("Line No.", "Material Req. Line No.");
                        IF gRecMRLine.FINDFIRST THEN BEGIN
                            IF gRecMRLine."Outstanding Quantity" + (xRec.Quantity - Rec.Quantity) < 0 THEN ERROR('You cannot input more than %1', gRecMRLine."Outstanding Quantity" + xRec.Quantity);
                            gCUMRFunct.updOutstandingQtyMR(gRecMRLine, Rec.RecordID, Quantity);
                        END;
                    END;
                END;
            end;
        }
        field(50000; "Material Req. No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50001; "Material Req. Line No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50002; "Purchase Req. No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50003; "Purchase Req. Line No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50004; "Original Qty MR"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50005; "Original Qty PR"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50006; "No. Shipping"; code[35])
        {
            DataClassification = ToBeClassified;
        }
        field(50007; "No. Berita Acara"; code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50008; "No. Surat Jalan"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(50009; "Tanggal Surat Jalan"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50010; "No. Polisi"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(50011; "MR Usage Category"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "MR Usage Category".Code;

            trigger OnValidate()
            begin
                VALIDATE("Gen. Bus. Posting Group", gCUMSIFunct.getGenBusfromMapping("Shortcut Dimension 1 Code", "Unit Group", "MR Usage Category"));
            end;
        }
        field(50012; "Reference No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50013; "Item Journal MR"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50014; "Unit Group"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Unit Group Dimension";

            trigger OnValidate()
            begin
                VALIDATE("Gen. Bus. Posting Group", gCUMSIFunct.getGenBusfromMapping("Shortcut Dimension 1 Code", "Unit Group", "MR Usage Category"));
            end;
        }
    }
    trigger OnDelete()
    begin
        IF (Rec."Material Req. No." <> '') AND (Rec."Material Req. Line No." <> 0) THEN BEGIN
            gRecMRLine.RESET;
            gRecMRLine.SETRANGE("Material Req. No.", "Material Req. No.");
            gRecMRLine.SETRANGE("Line No.", "Material Req. Line No.");
            IF gRecMRLine.FINDFIRST THEN BEGIN
                gCUMRFunct.updOutstandingQtyMR(gRecMRLine, Rec.RecordID, 0);
            END;
        END;
    end;

    var
        gRecMRLine: Record "Material Req. Line";
        gCUMRFunct: Codeunit "Material Req. Function";
        gCUMSIFunct: Codeunit "MII Function";
}
