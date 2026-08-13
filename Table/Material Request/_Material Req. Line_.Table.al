table 50102 "Material Req. Line"
{
    Caption = 'Material Req. Line';
    DataClassification = ToBeClassified;
    Permissions = tabledata "Material Req. Line" = rmid;
    LookupPageId = "Material Req. Subform";
    DrillDownPageId = "Material Req. Subform";

    fields
    {
        field(1; "Material Req. No."; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = ToBeClassified;
        }
        field(3; "Item No."; Code[50])
        {
            Caption = 'No.';
            DataClassification = ToBeClassified;
            TableRelation = if ("Type" = filter('Item')) Item where(Blocked = const(false))
            else
            if ("Type" = filter('Fixed Asset')) "Fixed Asset"
            else
            if ("Type" = filter('G/L Account')) "G/L Account";

            trigger OnValidate()
            var
                lRecItem: Record Item;
                lRecGL: Record "G/L Account";
                lRecFA: Record "Fixed Asset";
            begin
                if "Type" = "Type"::Item then begin
                    lRecItem.RESET;
                    lRecItem.SETRANGE(lRecItem."No.", "Item No.");
                    IF lRecItem.FINDFIRST THEN BEGIN
                        "Description" := lrecItem.Description;
                        //VALIDATE("VAT Prod. Posting Group", lRecItem."VAT Prod. Posting Group");

                        //VALIDATE("Direct Unit Cost", gCUMSIFunct.getPurchPrice("Vendor No.", "Item No.", "Document Date"));
                    END
                    ELSE BEGIN
                        "Description" := '';
                        //VALIDATE("VAT Prod. Posting Group", '');

                        //VALIDATE("Direct Unit Cost", 0);
                    END;
                end
            end;

        }
        field(4; Description; Text[1024])
        {
            Caption = 'Description';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                Rec.CalcFields(Status);
                Rec.TestField(Status, Rec.Status::Open);
            end;
        }
        field(5; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                TestField(Quantity);
                Rec.CalcFields(Status);
                //Rec.TestField(Status, Rec.Status::Open);
                "Line Amount" := Quantity * "Direct Unit Cost";
                "Outstanding Quantity" := Quantity;
                "Outstanding Qty Invt. Shpt" := Quantity;
            end;
        }
        field(6; "Unit of Measure"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Item Unit of Measure".Code where("Item No." = FIeld("Item No."));

            trigger OnValidate()
            begin
                Rec.CalcFields(Status);
                Rec.TestField(Status, Rec.Status::Open);
            end;
        }
        field(7; "Material Req. Type"; Enum "Material Req. Type")
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Remarks"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Total Qty On PR"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = SUM("PR Material Line".Quantity WHERE("Material Req. No." = field("Material Req. No."), "Material Req. Line No." = field("Line No.")));
        }
        field(10; "Direct Unit Cost"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Direct Unit Cost';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                Rec.CalcFields(Status);
                Rec.TestField(Status, Rec.Status::Open);
                "Line Amount" := "Quantity" * "Direct Unit Cost";
            end;
        }
        field(11; "Line Amount"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Line Amount';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(12; Status; Enum "PR Module Status")
        {
            Caption = 'Status';
            FieldClass = FlowField;
            CalcFormula = lookup("Material Req. Header".Status WHERE("Material Req. No." = field("Material Req. No.")));
        }
        field(13; "No. Filter"; Code[50])
        {
            Caption = 'No. Filter';
            DataClassification = ToBeClassified;
            TableRelation = Item."No." where(Blocked = const(false), Inventory = filter('>0'), "Location Filter" = field("Location Filter"));
        }
        field(14; "Location Filter"; Code[50])
        {
            Caption = 'Location Filter';
            TableRelation = Location;
        }
        field(15; "Location Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Location";
        }
        field(16; "Outstanding Quantity"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(17; "Shortcut Dimension 1 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1), Blocked = CONST(FALSE));
            CaptionClass = '1,2,1';
        }
        field(18; "Shortcut Dimension 2 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2), Blocked = CONST(FALSE));
            CaptionClass = '1,2,2';
        }
        // field(19; "Shortcut Dimension 3 Code"; Code[20])
        // {
        //     DataClassification = ToBeClassified;
        //     TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3), Blocked = CONST(FALSE));
        //     CaptionClass = '1,2,3';

        //     trigger OnValidate()
        //     begin
        //         VALIDATE("Unit Group", gCUMSIFunct.getUnitGroupDimension(3, "Shortcut Dimension 3 Code"));
        //     end;
        // }
        field(20; "Shortcut Dimension 4 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4), Blocked = CONST(FALSE));
            CaptionClass = '1,2,4';
        }
        field(21; "Shortcut Dimension 5 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(5), Blocked = CONST(FALSE));
            CaptionClass = '1,2,5';
        }
        field(22; "Shortcut Dimension 6 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(6), Blocked = CONST(FALSE));
            CaptionClass = '1,2,6';
        }
        field(23; "Shortcut Dimension 7 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(7), Blocked = CONST(FALSE));
            CaptionClass = '1,2,7';
        }
        field(24; "Shortcut Dimension 8 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(8), Blocked = CONST(FALSE));
            CaptionClass = '1,2,8';
        }
        field(25; Inventory; Decimal)
        {
            CalcFormula = sum("Item Ledger Entry".Quantity where("Item No." = field("Item No."), "Location Code" = field("Location Code")));
            Caption = 'Inventory';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(26; "Created By"; code[150])
        {
            Caption = 'Created By';
            DataClassification = ToBeClassified;
        }
        field(27; "Created Date"; DateTime)
        {
            Caption = 'Created Date';
            DataClassification = ToBeClassified;
        }
        field(28; "Last Modified By"; code[250])
        {
            Caption = 'Last Modified By';
            DataClassification = ToBeClassified;
        }
        field(29; "Last Modified Date"; DateTime)
        {
            Caption = 'Last Modified Date';
            DataClassification = ToBeClassified;
        }
        field(30; "Part No."; code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(31; "Cancel"; Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                IF (xRec.Cancel = FALSE) AND (Rec.Cancel = TRUE) THEN BEGIN
                    "Cancelled Datetime" := CurrentDateTime;
                    "Cancelled USERID" := USERID;
                END
            end;
        }
        field(32; "Cancelled Datetime"; Datetime)
        {
            DataClassification = ToBeClassified;
        }
        field(33; "Cancelled USERID"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(34; "Reason Cancel"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(35; "Total Qty On Inv. Shpt"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = SUM("Invt. Document Line".Quantity WHERE("Material Req. No." = field("Material Req. No."), "Material Req. Line No." = field("Line No.")));
        }
        field(36; "Total Qty On Posted Inv. Shpt"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = SUM("Invt. Shipment Line".Quantity WHERE("Material Req. No." = field("Material Req. No."), "Material Req. Line No." = field("Line No.")));
        }
        field(37; "PPH 22"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(38; "Total Qty On Item Journal"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = SUM("Item Journal Line".Quantity WHERE("Material Req. No." = field("Material Req. No."), "Material Req. Line No." = field("Line No.")));
        }
        field(39; "Total Qty On ILE"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = SUM("Item Ledger Entry".Quantity WHERE("Material Req. No." = field("Material Req. No."), "Material Req. Line No." = field("Line No."), "Entry Type" = const("Negative Adjmt."), "Item Journal MR" = const(True)));
        }
        field(40; "MR Usage Category"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "MR Usage Category".Code;
        }
        field(41; "Unit Group"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Unit Group Dimension";
        }
        field(42; "Total Qty On Purch Rcpt"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = SUM("Purch. Rcpt. Line".Quantity WHERE("Material Req. No." = field("Material Req. No."), "Material Req. Line No." = field("Line No.")));
        }
        field(43; "Outstanding Qty Invt. Shpt"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(44; "Qty Invt. Shpt Purch. Rcpt"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                Rec.CalcFields("Total Qty On Purch Rcpt");
                IF "Qty Invt. Shpt Purch. Rcpt" < "Total Qty On Purch Rcpt" THEN
                    "Outstanding Qty Invt. Shpt Bol" := TRUE
                ELSE
                    "Outstanding Qty Invt. Shpt Bol" := FALSE;
            end;
        }
        field(45; "Outstanding Qty Invt. Shpt Bol"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(46; "Gen Bus. Posting Group"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Business Posting Group";
        }

        field(47; "Quantity Delivery"; Decimal)
        {
            DataClassification = ToBeClassified;

        }
        field(48; quantitysum; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Total';
            MinValue = 0;
        }
        field(49; "Type"; Enum "PR Asset Line Type")
        {
            Caption = 'Type';
            DataClassification = ToBeClassified;
        }
        field(50; "Total Qty On Transfer Order"; Decimal)
        {
            Caption = 'Total Qty On Transfer Order';
            FieldClass = FlowField;
            CalcFormula = sum("Transfer Line".Quantity WHERE("Document No." = field("Transfer Order No."), "Item No." = field("Item No.")));
        }
        field(51; "Transfer Order No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Transfer Order No.';
        }
        field(53; "Total Ordered Quantity"; Decimal)
        {
            Caption = 'Total Ordered Quantity';
            FieldClass = FlowField;
            CalcFormula = sum("Transfer Line".Quantity WHERE("Document No." = field("Transfer Order No."), "Item No." = field("Item No.")));
        }
        field(54; "Total Shipped Quantity"; Decimal)
        {
            Caption = 'Total Shipped Quantity';
            FieldClass = FlowField;
            CalcFormula = sum("Transfer Shipment Line".Quantity WHERE("Transfer Order No." = field("Transfer Order No."), "Item No." = field("Item No.")));
        }
    }
    keys
    {
        key(PK; "Material Req. No.", "Line No.")
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    var
        lRecMRHeader: Record "Material Req. Header";
    begin
        lRecMRHeader.RESET;
        lRecMRHeader.SETRANGE("Material Req. No.", "Material Req. No.");
        IF lRecMRHeader.FINDFIRST THEN BEGIN
            Rec."Material Req. Type" := lRecMRHeader."Material Req. Type";
            Rec."Location Code" := lRecMRHeader."Location Code";
            Rec."Shortcut Dimension 1 Code" := lRecMRHeader."Shortcut Dimension 1 Code";
            Rec."Shortcut Dimension 2 Code" := lRecMRHeader."Shortcut Dimension 2 Code";
            //Rec.VALIDATE("Shortcut Dimension 3 Code", lRecMRHeader."Shortcut Dimension 3 Code");
            Rec."Shortcut Dimension 4 Code" := lRecMRHeader."Shortcut Dimension 4 Code";
            Rec."Shortcut Dimension 5 Code" := lRecMRHeader."Shortcut Dimension 5 Code";
            Rec."Shortcut Dimension 6 Code" := lRecMRHeader."Shortcut Dimension 6 Code";
            Rec."Shortcut Dimension 7 Code" := lRecMRHeader."Shortcut Dimension 7 Code";
            Rec."Shortcut Dimension 8 Code" := lRecMRHeader."Shortcut Dimension 8 Code";
            Rec."Unit Group" := lRecMRHeader."Unit Group";
            Rec."MR Usage Category" := lRecMRHeader."MR Usage Category";
        END;
        "Created By" := UserId;
        "Created Date" := CurrentDateTime;
        "Last Modified By" := UserID;
        "Last Modified Date" := CurrentDateTime;
    end;


    trigger OnModify()
    begin
        "Last Modified By" := UserID;
        "Last Modified Date" := CurrentDateTime;
    end;


    trigger OnDelete()
    var
        lRecMRHeader: Record "Material Req. Header";
    begin
        lRecMRHeader.RESET();
        lRecMRHeader.SetRange("Material Req. No.", Rec."Material Req. No.");
        IF lRecMRHeader.FIND('-') then lRecMRHeader.TestField(Status, lRecMRHeader.Status::Open);
        Rec.CalcFields("Total Qty On PR", "Total Qty On Inv. Shpt", "Total Qty On Posted Inv. Shpt", "Total Qty On Item Journal", "Total Qty On ILE");
        IF "Total Qty On PR" <> 0 THEN BEGIN
            ERROR('This line already has PR, cannot delete');
        END;
        IF "Total Qty On Inv. Shpt" <> 0 THEN BEGIN
            ERROR('This line already has Inventory Shipment, cannot delete');
        END;
        IF "Total Qty On Posted Inv. Shpt" <> 0 THEN BEGIN
            ERROR('This line already has Inventory Shipment, cannot delete');
        END;
        IF "Total Qty On Item Journal" <> 0 THEN BEGIN
            ERROR('This line already has Item Journal, cannot delete');
        END;
        IF "Total Qty On ILE" <> 0 THEN BEGIN
            ERROR('This line already has ILE, cannot delete');
        END;
    end;

    local procedure GetItem()
    var
        myInt: Integer;
    begin
        Rec.TESTFIELD("Item No.");
        IF Rec."Item No." <> Item."No." THEN Item.GET("Item No.");
    end;

    var
        GLAcc: Record "G/L Account";
        StdTxt: Record "Standard Text";
        Item: Record "Item";
        gRecSH: Record "Material Req. Header";
        gRecSuppH: Record "Material Req. Header";
        DimMgt: Codeunit DimensionManagement;
        gCUMSIFunct: Codeunit "MII Function";
}
