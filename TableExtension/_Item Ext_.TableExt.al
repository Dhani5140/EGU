tableextension 50117 "Item Ext" extends Item
{
    fields
    {
        field(50000; "PPH 22"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50100; part_number; Text[300])
        {

        }

        field(50101; QTY123; Decimal)
        {
            Caption = 'Quantity';
            AccessByPermission = TableData "Item Ledger Entry" = R;
            CalcFormula = Sum("Item Ledger Entry".Quantity WHERE("Item No." = FIELD("No."),
                                                                    "Location Code" = field("Location Filter")));
            FieldClass = FlowField;
        }

        // field(50102; QTY1234; Decimal)
        // {
        //     Caption = 'Quantity On PB';
        //     AccessByPermission = TableData PBHeader = R;
        //     CalcFormula = Sum(PBLine.Quantity WHERE("No." = FIELD("No."),
        //                      "Location Code" = field("Location Filter")));


        //     FieldClass = FlowField;
        // }


        // field(50103; QTY123456; Decimal)
        // {
        //     Caption = 'Quantity Available';

        //     // trigger OnValidate()
        //     // begin
        //     //     QTY123456 := (rec.QTY123) - (rec.QTY123456);
        //     // end;
        // }
        // field(50104; "WHT Posting Group"; code[20])
        // {
        //     TableRelation = "WHT Buss Posting Group";
        // }

        // field(50105; "WHT Business Posting Group"; Code[20])
        // {
        //     TableRelation = "WHT Buss Posting Group";
        // }
        // field(50106; "WHT Product Posting Group"; Code[20])
        // {
        //     TableRelation = "WHT Product Posting Group";
        // }

    }
    keys
    {
        // Add changes to keys here
    }
    fieldgroups
    {
        // Add changes to field groups here
    }
    var
        myInt: Integer;
}
