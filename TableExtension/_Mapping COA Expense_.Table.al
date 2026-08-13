table 50114 "Mapping COA Expense"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Shortcut Dimension 1 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1), Blocked = CONST(FALSE));
            CaptionClass = '1,2,1';
        }
        field(2; "Unit Group Dimension"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Unit Group Dimension";
        }
        field(3; "MR Usage Category"; code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "MR Usage Category";
        }
        field(4; "Gen Bus. Posting Group"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Business Posting Group";

            trigger OnValidate()
            begin
                IF "Copy to Gen. Posting Setup" THEN "Copy to Gen. Posting Setup" := FALSE;
            end;
        }
        field(5; "Gen Prod. Posting Group"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Product Posting Group";

            trigger OnValidate()
            begin
                IF "Copy to Gen. Posting Setup" THEN "Copy to Gen. Posting Setup" := FALSE;
            end;
        }
        field(6; "Inventory Adjmt. Account"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";

            trigger OnValidate()
            begin
                IF "Copy to Gen. Posting Setup" THEN "Copy to Gen. Posting Setup" := FALSE;
            end;
        }
        field(7; "Copy to Gen. Posting Setup"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Shortcut Dimension 6 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(5), Blocked = CONST(FALSE));
            CaptionClass = '1,2,5';
        }
        field(9; "Shortcut Dimension 7 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3), Blocked = CONST(FALSE));
            CaptionClass = '1,2,3';
        }
        field(10; "Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Shortcut Dimension 2 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2), Blocked = CONST(FALSE));
            CaptionClass = '1,2,2';
        }
    }
    keys
    {
        key(PK; Code, "Shortcut Dimension 1 Code", "Unit Group Dimension", "MR Usage Category", "Gen Bus. Posting Group", "Gen Prod. Posting Group", "Inventory Adjmt. Account")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; "Code", "Shortcut Dimension 1 Code", "Gen Prod. Posting Group", "Shortcut Dimension 2 Code", "Shortcut Dimension 6 Code", "Shortcut Dimension 7 Code")
        {
        }
    }
}
