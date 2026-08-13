tableextension 50174 "Purch. Inv. Line Ext" extends "Purch. Inv. Line"
{
    fields
    {
        field(50000; "Purchase Req. No."; code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50001; "Purchase Req. Line No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50002; "RFQ No."; code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50003; "RFQ Line No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50004; "Material Req. No."; code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50005; "Material Req. Line No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50006; "Original Qty PR"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50007; "Entry No. RFQ Line"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50008; "Batch No. [PR]"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50009; "PR Type"; Enum "PR Type")
        {
            DataClassification = ToBeClassified;
        }
        // field(50010; "Fixed Asset PR Qty"; Decimal)
        // {
        //     FieldClass = FlowField;
        //     CalcFormula = SUM("PR Asset FA List".Quantity where("PO No." = field("Order No."), "PO Line No." = field("Order Line No."), "Purchase Req. No." = field("Purchase Req. No."), "Purchase Req. Line No." = field("Purchase Req. Line No."), "FA No." = filter(<> '')));
        // }
        // field(50011; "Fixed Asset PR Amount"; Decimal)
        // {
        //     FieldClass = FlowField;
        //     CalcFormula = SUM("PR Asset FA List"."Line Amount" where("PO No." = field("Order No."), "PO Line No." = field("Order Line No."), "Purchase Req. No." = field("Purchase Req. No."), "Purchase Req. Line No." = field("Purchase Req. Line No."), "FA No." = filter(<> '')));
        // }

        field(50012; "PR Line Type"; Enum "PR Asset Line Type")
        {
            DataClassification = ToBeClassified;
        }
        field(50013; "Part No."; code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50014; "PPH 22"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50015; "PBBKB"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50016; "Auto Insert from Line No"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50017; "BPB No."; code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50018; "MR Usage Category"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "MR Usage Category".Code;
        }
        field(50019; "Unit Group"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Unit Group Dimension";
        }
        field(50020; "Shortcut Dimension 3 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3), Blocked = CONST(FALSE));
            CaptionClass = '1,2,3';
        }
        // field(50022; "WHT Business Posting Group"; Code[20])
        // {
        //     Caption = 'WHT Business Posting Group';
        //     TableRelation = "WHT Buss Posting Group";
        // }
        // field(50023; "WHT Product Posting Group"; Code[20])
        // {
        //     Caption = 'WHT Product Posting Group';
        //     TableRelation = "WHT Product Posting Group";
        // }
        // field(50024; "WHT Absorb Base"; Decimal)
        // {
        //     Caption = 'WHT Absorb Base';
        // }
        // field(50025; "WHT %"; Decimal)
        // {
        //     TableRelation = "WHT Posting Setup"."WHT %";
        // }

        // field(50111; "WHT Code"; Code[20])
        // {
        //     TableRelation = "Tax Setup2"."WHT Code";
        // }

    }
    var
        myInt: Integer;
}
