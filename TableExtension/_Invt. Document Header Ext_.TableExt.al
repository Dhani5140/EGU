tableextension 50113 "Invt. Document Header Ext" extends "Invt. Document Header"
{
    fields
    {
        modify("Shortcut Dimension 1 Code")
        {
            trigger OnAfterValidate()
            begin
                VALIDATE("Gen. Bus. Posting Group", gCUMSIFunct.getGenBusfromMapping("Shortcut Dimension 1 Code", "Unit Group", "MR Usage Category"));
            end;
        }
        field(50000; "Material Req. No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = FALSE;
        }
        modify("Gen. Bus. Posting Group")
        {
            trigger OnBeforeValidate()
            begin
                IF (xRec."Gen. Bus. Posting Group" <> '') AND (Rec."Gen. Bus. Posting Group" <> '') THEN IF "Material Req. No." <> '' THEN ERROR('This document is from Material Request, Cannot change gen bus');
            end;
        }
        field(50001; "MR Usage Category"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "MR Usage Category".Code;

            trigger OnValidate()
            begin
                VALIDATE("Gen. Bus. Posting Group", gCUMSIFunct.getGenBusfromMapping("Shortcut Dimension 1 Code", "Unit Group", "MR Usage Category"));
            end;
        }
        field(50002; "Unit Group"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Unit Group Dimension";

            trigger OnValidate()
            begin
                VALIDATE("Gen. Bus. Posting Group", gCUMSIFunct.getGenBusfromMapping("Shortcut Dimension 1 Code", "Unit Group", "MR Usage Category"));
            end;
        }
        // field(50003; "Shortcut Dimension 3 Code"; Code[20])
        // {
        //     DataClassification = ToBeClassified;
        //     TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3), Blocked = CONST(FALSE));
        //     CaptionClass = '1,2,3';

        //     trigger OnValidate()
        //     begin
        //         VALIDATE("Unit Group", gCUMSIFunct.getUnitGroupDimension(3, "Shortcut Dimension 3 Code"));
        //     end;
        // }
        field(50005; "Shortcut Dimension 5 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(5), Blocked = CONST(FALSE));
            CaptionClass = '1,2,5';
        }
        field(50006; "Remarks"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(50007; "Gen. Prod. Posting Group"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
    }
    var
        gCUMSIFunct: Codeunit "MII Function";
}
