table 50106 "RFQ Line"
{
    Caption = ' RFQ Line';
    DataClassification = ToBeClassified;
    DrillDownPageID = "RFQ Lines";
    LookupPageID = "RFQ Lines";

    fields
    {
        field(1; "RFQ No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = ToBeClassified;
        }
        field(3; "Type"; Enum "RFQ Line Type")
        {
            Caption = 'Type';
            DataClassification = ToBeClassified;
        }
        field(4; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = ToBeClassified;
            TableRelation = if ("Type" = const("Item")) Item
            else
            if ("Type" = const("G/L Account")) "G/L Account"
            else
            if ("Type" = const("Charge (Item)")) "Item Charge";

            trigger OnValidate()
            var
                lRecItem: Record Item;
                lRecGL: Record "G/L Account";
                lRecIC: Record "Item Charge";
                lRecRFQVendor: Record "RFQ Vendor List";
                lRecRFQLineDetails: Record "RFQ Line Details";
            begin
                Rec.CalcFields(Status);
                Rec.TestField(Status, Status::Open);
                IF xRec."No." <> Rec."No." THEN BEGIN
                    IF ("Purchase Req. No." <> '') AND ("Purchase Req. Line No." <> 0) THEN BEGIN
                        ERROR('This line is from Purchase Request, Cannot change no');
                    END;
                END;
                Case Type OF
                    Type::Item:
                        BEGIN
                            lRecItem.RESET;
                            lRecItem.SETRANGE(lRecItem."No.", "No.");
                            IF lRecItem.FINDFIRST THEN BEGIN
                                // VALIDATE("PPH 22", lRecItem."PPH 22");
                                VALIDATE("VAT Prod. Posting Group", lRecItem."VAT Prod. Posting Group");

                            END
                            ELSE BEGIN
                                VALIDATE("VAT Prod. Posting Group", '');

                                VALIDATE("PPH 22", FALSE);
                            END;
                        END;
                    Type::"G/L Account":
                        BEGIN
                            lRecGL.RESET;
                            lRecGL.SETRANGE(lRecGL."No.", "No.");
                            IF lRecGL.FINDFIRST THEN BEGIN
                                VALIDATE("VAT Prod. Posting Group", lRecGL."VAT Prod. Posting Group");

                            END
                            ELSE BEGIN
                                VALIDATE("VAT Prod. Posting Group", '');

                            END;
                        END;
                    Type::"Charge (Item)":
                        BEGIN
                            lRecIC.RESET;
                            lRecIC.SETRANGE(lRecIC."No.", "No.");
                            IF lRecIC.FINDFIRST THEN BEGIN
                                VALIDATE("VAT Prod. Posting Group", lRecIC."VAT Prod. Posting Group");

                            END
                            ELSE BEGIN
                                VALIDATE("VAT Prod. Posting Group", '');

                            END;
                        END;
                End;
                IF (xRec."No." = '') THEN BEGIN
                    gCURFQFunct.insertRFQLineDetailsfromRFQLine(Rec);
                    lRecRFQVendor.RESET;
                    lRecRFQVendor.SETRANGE("RFQ No.", Rec."RFQ No.");
                    lRecRFQVendor.SETRANGE("Check Win", TRUE);
                    IF lRecRFQVendor.FINDFIRST THEN BEGIN
                        lRecRFQLineDetails.RESET;
                        lRecRFQLineDetails.SETRANGE(lRecRFQLineDetails."RFQ No.", Rec."RFQ No.");
                        lRecRFQLineDetails.SETRANGE(lRecRFQLineDetails."No.", Rec."No.");
                        lRecRFQLineDetails.SETRANGE(lRecRFQLineDetails."Entry No. RFQ Vendor", lRecRFQVendor."Entry No. RFQ Vendor");
                        IF lRecRFQLineDetails.FINDFIRST THEN BEGIN
                            Rec.VALIDATE("Winner RFQ Line Details", lRecRFQLineDetails."Entry No.");
                        END;
                    END;
                END
                ELSE BEGIN
                    ERROR('Cannot change No., please delete and reinsert line instead');
                END;
            end;
        }
        field(5; "Description"; Text[250])
        {
            Caption = 'Description';
            DataClassification = ToBeClassified;
        }
        field(6; "Quantity"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                lRecRFQLine: Record "RFQ Line";
                lDecOutstandingQty: Decimal;
            begin
                CLEAR(lDecOutstandingQty);
                Rec.CalcFields(Status);
                TestField(Status, Status::Open);
                TestField(Quantity);
                IF xRec.Quantity <> Rec.Quantity THEN BEGIN
                    IF ("Purchase Req. No." <> '') AND ("Purchase Req. Line No." <> 0) THEN BEGIN
                        lRecRFQLine.RESET;
                        lRecRFQLine.SETRANGE(lRecRFQLine."RFQ No.", Rec."RFQ No.");
                        lRecRFQLine.SETRANGE(lRecRFQLine."Group Line No.", Rec."Group Line No.");
                        lRecRFQLine.SETFILTER(lRecRFQLine."Entry No. RFQ Line", '<>%1', "Entry No. RFQ Line");
                        IF lRecRFQLine.FIND('-') THEN BEGIN
                            lRecRFQLine.CalcSums(Quantity);
                            IF (lRecRFQLine.Quantity + Rec.Quantity) > Rec."Original Qty PR" THEN ERROR('You cannot input more than %1', (Rec."Original Qty PR" - lRecRFQLine.Quantity));
                        END
                        ELSE BEGIN
                            IF Rec.Quantity > Rec."Original Qty PR" THEN ERROR('You cannot input more than %1', Rec."Original Qty PR");
                        END;
                    END;
                    // updQtyLineDetails();
                    Validate("Subtotal Amount", Quantity * "Unit Price");
                END;
                IF Quantity - totalQtyonProcess() < 0 THEN ERROR('This line already has %1 in PO, cannot input below that', totalQtyonProcess());
                "Outstanding Quantity" := Quantity - totalQtyonProcess();
                VALIDATE("Qty to PO", Quantity);
            end;
        }
        field(7; "Original Qty PR"; Integer)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                lRecRFQLine: Record "RFQ Line";
            begin
                Rec.CalcFields(Status);
                TestField(Status, Status::Open);
                TestField("Original Qty PR");
                IF xRec."Original Qty PR" <> Rec."Original Qty PR" THEN BEGIN
                    lRecRFQLine.RESET;
                    lRecRFQLine.SETRANGE(lRecRFQLine."RFQ No.", Rec."RFQ No.");
                    lRecRFQLine.SETRANGE(lRecRFQLine."Group Line No.", Rec."Group Line No.");
                    lRecRFQLine.SETFILTER(lRecRFQLine."Parent Line No.", '<>%1', 0);
                    IF lRecRFQLine.FINDFIRST THEN BEGIN
                        ERROR('This line already has split cannot change original qty PR');
                    END;
                    IF ("Purchase Req. No." <> '') AND ("Purchase Req. Line No." <> 0) THEN BEGIN
                        gRecPRLine.RESET;
                        gRecPRLine.SETRANGE("Purchase Req. No.", "Purchase Req. No.");
                        gRecPRLine.SETRANGE("Line No.", "Purchase Req. Line No.");
                        IF gRecPRLine.FINDFIRST THEN BEGIN
                            IF gRecPRLine."Outstanding Quantity" + (xRec."Original Qty PR" - Rec."Original Qty PR") < 0 THEN ERROR('You cannot input more than %1', gRecPRLine."Outstanding Quantity" + xRec."Original Qty PR");
                            gCUPRFunct.updOutstandingQtyPR(gRecPRLine, Rec.RecordID, "Original Qty PR");
                        END;
                        Validate(Quantity, "Original Qty PR");
                    END;
                    updOriginalQtyallchild();
                END;
            end;
        }
        field(8; "Outstanding Quantity"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Unit of Measure"; Text[50])
        {
            Caption = 'Unit of Measure';
            DataClassification = ToBeClassified;
            TableRelation = if ("Type" = const("Item")) "Item Unit of Measure".Code where("Item No." = field("No."))
            else
            if ("Type" = const("G/L Account")) "Unit of Measure".Code
            else
            if ("Type" = const("Charge (Item)")) "Unit of Measure".Code;
        }
        field(10; "Vendor No."; code[20])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                lRecVendor: Record Vendor;
                lRec: Record "RFQ Line Details";
            begin
                lRecVendor.RESET;
                lRecVendor.SETRANGE(lRecVendor."No.", "Vendor No.");
                IF lRecVendor.FINDFIRST THEN BEGIN
                    "Vendor Name" := lRecVendor.Name;
                    VALIDATE("VAT Bus. Posting Group", lRecVendor."VAT Bus. Posting Group");

                END
                ELSE BEGIN
                    "Vendor Name" := '';
                    VALIDATE("VAT Bus. Posting Group", '');

                END;
            end;
        }
        field(11; "Unit Price"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                Validate("Subtotal Amount", Quantity * "Unit Price");
            end;
        }
        field(12; "Line Amount"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                calcPPN();


                BEGIN
                    VALIDATE("Total Amount", "Line Amount" + "VAT Amount" + "PBBKB Amount" - "WHT Amount");
                END;
            end;
        }
        field(13; "Total Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(14; "Created By"; code[150])
        {
            Caption = 'Created By';
            DataClassification = ToBeClassified;
        }
        field(15; "Created Date"; DateTime)
        {
            Caption = 'Created Date';
            DataClassification = ToBeClassified;
        }
        field(16; "Last Modified By"; code[250])
        {
            Caption = 'Last Modified By';
            DataClassification = ToBeClassified;
        }
        field(17; "Last Modified Date"; DateTime)
        {
            Caption = 'Last Modified Date';
            DataClassification = ToBeClassified;
        }
        field(18; "Location Code"; code[50])
        {
            Caption = 'Location Code';
            TableRelation = Location.Code;
        }
        field(19; "Purchase Req. No."; code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(20; "Purchase Req. Line No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(21; "Material Req. No."; code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(22; "Material Req. Line No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(23; Status; Enum "PR Module Status")
        {
            Caption = 'Status';
            FieldClass = FlowField;
            CalcFormula = lookup("RFQ Header".Status WHERE("RFQ No." = field("RFQ No.")));
        }
        field(24; "Qty to PO"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                IF "Qty to PO" > "Outstanding Quantity" THEN ERROR('Qty to PO cannot input more than %1', "Outstanding Quantity");
            end;
        }
        field(25; "Total Qty On PO"; Decimal)
        {
            Caption = 'Total Qty On PO';
            FieldClass = FlowField;
            CalcFormula = SUM("Purchase Line".Quantity where("RFQ No." = FIELD("RFQ No."), "RFQ Line No." = FIELD("Line No."), "PR Type" = const(Material), "Auto Insert from Line No" = const(0)));
        }
        field(26; "Shortcut Dimension 1 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1), Blocked = CONST(FALSE));
            CaptionClass = '1,2,1';
        }
        field(27; "Shortcut Dimension 2 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2), Blocked = CONST(FALSE));
            CaptionClass = '1,2,2';
        }
        field(28; "Shortcut Dimension 3 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3), Blocked = CONST(FALSE));
            CaptionClass = '1,2,3';
        }
        field(29; "Shortcut Dimension 4 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4), Blocked = CONST(FALSE));
            CaptionClass = '1,2,4';
        }
        field(30; "Shortcut Dimension 5 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(5), Blocked = CONST(FALSE));
            CaptionClass = '1,2,5';
        }
        field(31; "Shortcut Dimension 6 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(6), Blocked = CONST(FALSE));
            CaptionClass = '1,2,6';
        }
        field(32; "Shortcut Dimension 7 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(7), Blocked = CONST(FALSE));
            CaptionClass = '1,2,7';
        }
        field(33; "Shortcut Dimension 8 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(8), Blocked = CONST(FALSE));
            CaptionClass = '1,2,8';
        }
        field(34; "Remarks"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(35; "Part No."; code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(36; "Group Line No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(37; "Entry No. RFQ Line"; Integer)
        {
            DataClassification = ToBeClassified;
            AutoIncrement = TRUE;
        }
        field(38; "Count RFQ Line Details"; Integer)
        {
            FieldClass = FlowField;
            Editable = FALSE;
            CalcFormula = COUNT("RFQ Line Details" WHERE("RFQ No." = field("RFQ No."), "No." = field("No.")));
        }
        field(39; "Parent Line No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(40; "from PR"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(41; "Total Qty on Posted Order"; Decimal)
        {
            FieldClass = FlowField;
            Editable = FALSE;
            CalcFormula = SUM("Purch. Inv. Line".Quantity where("RFQ No." = FIELD("RFQ No."), "RFQ Line No." = FIELD("Line No."), "PR Type" = const(Material), "Auto Insert from Line No" = const(0)));
        }
        field(42; "Entry No. RFQ Vendor"; Integer)
        {
            FieldClass = FlowField;
            Editable = FALSE;
            CalcFormula = lookup("RFQ Line Details"."Entry No. RFQ Vendor" WHERE("RFQ No." = field("RFQ No."), "No." = field("No."), "Entry No." = field("Winner RFQ Line Details")));
        }
        field(43; "Total Amount on PO"; Decimal)
        {
            FieldClass = FlowField;
            Editable = FALSE;
            CalcFormula = SUM("Purchase Line"."Line Amount" where("RFQ No." = FIELD("RFQ No."), "RFQ Line No." = FIELD("Line No."), "PR Type" = const(Material), "Auto Insert from Line No" = const(0)));
        }
        field(44; "Total Amount on Posted Order"; Decimal)
        {
            FieldClass = FlowField;
            Editable = FALSE;
            CalcFormula = SUM("Purch. Inv. Line"."Line Amount" where("RFQ No." = FIELD("RFQ No."), "RFQ Line No." = FIELD("Line No."), "PR Type" = const(Material), "Auto Insert from Line No" = const(0)));
        }
        field(45; "PPH 22"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(46; "PBBKB"; Boolean)
        {
            DataClassification = ToBeClassified;


        }
        field(47; "PBBKB Amount"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                IF "PPH 22" THEN BEGIN
                    VALIDATE("Total Amount", "Line Amount" + "VAT Amount" + "WHT Amount" + "PBBKB Amount");
                END
                ELSE BEGIN
                    VALIDATE("Total Amount", "Line Amount" + "VAT Amount" + "PBBKB Amount" - "WHT Amount");
                END;
            end;
        }
        field(48; "MR Usage Category"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "MR Usage Category".Code;
        }
        field(49; "Unit Group"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Unit Group Dimension";
        }
        field(50; "Winner RFQ Line Details"; Integer)
        {
            DataClassification = ToBeClassified;
            TableRelation = "RFQ Line Details"."Entry No." where("RFQ No." = field("RFQ No."), "No." = field("No."));

            trigger OnValidate()
            var
                lRecRFQLineDetails: Record "RFQ Line Details";
            begin
                lRecRFQLineDetails.RESET;
                lRecRFQLineDetails.SETRANGE("Entry No.", "Winner RFQ Line Details");
                IF lRecRFQLineDetails.FIND('-') THEN BEGIN
                    VALIDATE("Vendor No.", lRecRFQLineDetails."Vendor No.");
                    VALIDATE("Unit Price", lRecRFQLineDetails."Unit Price");
                    VALIDATE("Discount %", lRecRFQLineDetails."Discount %");
                    VALIDATE("Discount Amount", lRecRFQLineDetails."Discount Amount");
                    VALIDATE("VAT Bus. Posting Group", lRecRFQLineDetails."VAT Bus. Posting Group");
                    VALIDATE("VAT Prod. Posting Group", lRecRFQLineDetails."VAT Prod. Posting Group");


                    VALIDATE("Qty to PO", "Outstanding Quantity");
                END
                ELSE BEGIN
                    VALIDATE("Vendor No.", '');
                    VALIDATE("Unit Price", 0);
                    VALIDATE("Discount %", 0);
                    VALIDATE("Discount Amount", 0);
                    VALIDATE("VAT Bus. Posting Group", '');
                    VALIDATE("VAT Prod. Posting Group", '');


                END;

            end;
        }
        field(51; "Subtotal Amount"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                validate("Line Amount", "Subtotal Amount" - "Discount Amount");
            end;
        }
        field(53; "Discount %"; Decimal)
        {
            DataClassification = ToBeClassified;
            MinValue = 0;
            MaxValue = 100;

            trigger OnValidate()
            begin
                Validate("Discount Amount", "Discount %" / 100 * "Subtotal Amount");
            end;
        }
        field(54; "Discount Amount"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                validate("Line Amount", "Subtotal Amount" - "Discount Amount");
            end;
        }
        field(55; "VAT Prod. Posting Group"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "VAT Product Posting Group";

            trigger OnValidate()
            begin
                calcPPN();
            end;
        }
        field(56; "VAT Bus. Posting Group"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "VAT Business Posting Group";

            trigger OnValidate()
            begin
                calcPPN();
            end;
        }
        field(57; "VAT %"; Decimal)
        {
            FieldClass = FlowField;
            Editable = FALSE;
            CalcFormula = Lookup("VAT Posting Setup"."VAT %" where("VAT Prod. Posting Group" = field("VAT Prod. Posting Group"), "VAT Bus. Posting Group" = field("VAT Bus. Posting Group")));
        }
        field(58; "VAT Amount"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                IF "PPH 22" THEN BEGIN
                    VALIDATE("Total Amount", "Line Amount" + "VAT Amount" + "WHT Amount" + "PBBKB Amount");
                END
                ELSE BEGIN
                    VALIDATE("Total Amount", "Line Amount" + "VAT Amount" + "PBBKB Amount" - "WHT Amount");
                END;
            end;
        }



        field(62; "WHT Amount"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                IF "PPH 22" THEN BEGIN
                    VALIDATE("Total Amount", "Line Amount" + "VAT Amount" + "WHT Amount" + "PBBKB Amount");
                END
                ELSE BEGIN
                    VALIDATE("Total Amount", "Line Amount" + "VAT Amount" + "PBBKB Amount" - "WHT Amount");
                END;
            end;
        }
        field(63; "Vendor Name"; Text[150])
        {
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "RFQ No.", "Line No.")
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    var
        lRecRFQHeader: Record "RFQ Header";
    begin
        lRecRFQHeader.RESET;
        lRecRFQHeader.SETRANGE("RFQ No.", "RFQ No.");
        IF lRecRFQHeader.FINDFIRST THEN BEGIN
            Rec."Location Code" := lRecRFQHeader."Location Code";
            Rec."Shortcut Dimension 1 Code" := lRecRFQHeader."Shortcut Dimension 1 Code";
            Rec."Shortcut Dimension 2 Code" := lRecRFQHeader."Shortcut Dimension 2 Code";
            Rec."Shortcut Dimension 3 Code" := lRecRFQHeader."Shortcut Dimension 3 Code";
            Rec."Shortcut Dimension 4 Code" := lRecRFQHeader."Shortcut Dimension 4 Code";
            Rec."Shortcut Dimension 5 Code" := lRecRFQHeader."Shortcut Dimension 5 Code";
            Rec."Shortcut Dimension 6 Code" := lRecRFQHeader."Shortcut Dimension 6 Code";
            Rec."Shortcut Dimension 7 Code" := lRecRFQHeader."Shortcut Dimension 7 Code";
            Rec."Shortcut Dimension 8 Code" := lRecRFQHeader."Shortcut Dimension 8 Code";
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
    begin
        gCURFQFunct.checkRFQLinehasPO(Rec."RFQ No.", Rec."Line No.", 'delete');
        IF ("Purchase Req. No." <> '') AND ("Purchase Req. Line No." <> 0) THEN BEGIN
            gRecPRLine.RESET;
            gRecPRLine.SETRANGE("Purchase Req. No.", "Purchase Req. No.");
            gRecPRLine.SETRANGE("Line No.", "Purchase Req. Line No.");
            IF gRecPRLine.FINDFIRST THEN BEGIN
                gCUPRFunct.updOutstandingQtyPR(gRecPRLine, Rec.RecordID, 0);
            END;
        END;
        gCURFQFunct.deleteRFQLineDetails(Rec.RecordId);
    end;

    procedure updOriginalQtyallchild()
    var
        lRecRFQLine: Record "RFQ Line";
    begin
        lRecRFQLine.RESET;
        lRecRFQLine.SETRANGE(lRecRFQLine."RFQ No.", "RFQ No.");
        lRecRFQLine.SETRANGE(lRecRFQLine."Group Line No.", "Group Line No.");
        lRecRFQLine.SETFILTER(lRecRFQLine."Entry No. RFQ Line", '<>%1', "Entry No. RFQ Line");
        IF lRecRFQLine.FIND('-') THEN lRecRFQLine.MODIFYALL("Original Qty PR", Rec."Original Qty PR", TRUE);
    end;

    procedure updQtyLineDetails()
    var
        lRecRFQLineDet: Record "RFQ Line Details";
    begin
        lRecRFQLineDet.RESET;
        lRecRFQLineDet.SETRANGE(lRecRFQLineDet."RFQ No.", "RFQ No.");
        lRecRFQLineDet.SETRANGE(lRecRFQLineDet."Entry No. RFQ Line", "Entry No. RFQ Line");
        IF lRecRFQLineDet.FIND('-') THEN BEGIN
            REPEAT
                lRecRFQLineDet.VALIDATE(Quantity, Rec.Quantity);
                lRecRFQLineDet.MODIFY(TRUE);
            UNTIL lRecRFQLineDet.NEXT = 0;
        END;
    end;

    procedure totalQtyonProcess(): Decimal
    var
        lRecRFQLineDet: Record "RFQ Line Details";
    begin
        Rec.CalcFields("Total Qty On PO", "Total Qty on Posted Order");
        exit(Rec."Total Qty On PO" + Rec."Total Qty on Posted Order");
    end;

    procedure calcPPN()
    var
        lRecVATSetup: Record "VAT Posting Setup";
    begin
        lRecVATSetup.RESET;
        lRecVATSetup.SETRANGE(lRecVATSetup."VAT Prod. Posting Group", "VAT Prod. Posting Group");
        lRecVATSetup.SETRANGE(lRecVATSetup."VAT Bus. Posting Group", "VAT Bus. Posting Group");
        IF lRecVATSetup.FINDFIRST THEN
            VALIDATE("VAT Amount", "Line Amount" * (lRecVATSetup."VAT %") / 100)
        ELSE
            VALIDATE("VAT Amount", 0);
    end;


    var
        gRecPRLine: Record "PR Material Line";
        gCUPRFunct: Codeunit "PR Material Function";
        gCURFQFunct: Codeunit "RFQ Function";
        UOMMgt: Codeunit "Unit of Measure Management";
        Item: Record Item;
}
