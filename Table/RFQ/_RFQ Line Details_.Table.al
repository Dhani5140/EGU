table 50108 "RFQ Line Details"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
            AutoIncrement = TRUE;
        }
        field(2; "RFQ No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "RFQ Line No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Vendor No."; code[20])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                lRecVendor: Record Vendor;
                lRec: Record "RFQ Line Details";
            begin
                // lRec.RESET;
                // lRec.SETRANGE("RFQ No.", "RFQ No.");
                // lRec.SETFILTER("Entry No.", '<>%1', "Entry No.");
                // lRec.SETRANGE("Vendor No.", "Vendor No.");
                // IF lRec.FINDFIRST THEN
                //     ERROR('Vendor No %1 has already been defined', lRec."Vendor No.");
                lRecVendor.RESET;
                lRecVendor.SETRANGE(lRecVendor."No.", "Vendor No.");
                IF lRecVendor.FINDFIRST THEN BEGIN
                    VALIDATE("VAT Bus. Posting Group", lRecVendor."VAT Bus. Posting Group");

                END
                ELSE BEGIN
                    VALIDATE("VAT Bus. Posting Group", '');

                END;
                updateDocLines(FieldNo("Vendor No."));
            end;
        }
        field(5; "Vendor Name"; Text[150])
        {
            FieldClass = FlowField;
            Editable = FALSE;
            CalcFormula = Lookup("RFQ Vendor List"."Vendor Name" where("RFQ No." = field("RFQ No."), "Entry No. RFQ Vendor" = field("Entry No. RFQ Vendor")));
        }
        field(6; "Type"; Enum "RFQ Line Type")
        {
            DataClassification = ToBeClassified;
        }
        field(7; "No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = if ("Type" = const(Item)) Item
            else
            if ("Type" = const("G/L Account")) "G/L Account"
            else
            if ("Type" = const("Charge (Item)")) "Item Charge";

            trigger OnValidate()
            var
                lRecItem: Record Item;
                lRecGL: Record "G/L Account";
                lRecFA: Record "Fixed Asset";
                lRecIC: Record "Item Charge";
            begin
                Case Type OF
                    Type::Item:
                        BEGIN
                            lRecItem.RESET;
                            lRecItem.SETRANGE(lRecItem."No.", "No.");
                            IF lRecItem.FINDFIRST THEN BEGIN
                                VALIDATE("PPH 22", lRecItem."PPH 22");
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
            end;
        }
        field(8; "Description"; Text[250])
        {
            FieldClass = FlowField;
            Editable = FALSE;
            CalcFormula = Lookup("RFQ Line"."Description" where("RFQ No." = field("RFQ No."), "Type" = field("Type"), "No." = field("No.")));
        }
        field(9; "Quantity"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                Validate("Subtotal Amount", Quantity * "Unit Price");
            end;
        }
        field(10; "Unit of Measure"; Text[50])
        {
            FieldClass = FlowField;
            Editable = FALSE;
            CalcFormula = Lookup("RFQ Line"."Unit of Measure" where("RFQ No." = field("RFQ No."), "Entry No. RFQ Line" = field("Entry No. RFQ Line")));
        }
        field(11; "Unit Price"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                Validate("Subtotal Amount", Quantity * "Unit Price");
                updateDocLines(FieldNo("Unit Price"));
            end;
        }
        field(12; "Subtotal Amount"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                validate("Line Amount", "Subtotal Amount" - "Discount Amount");
            end;
        }
        field(13; "Discount %"; Decimal)
        {
            DataClassification = ToBeClassified;
            MinValue = 0;
            MaxValue = 100;

            trigger OnValidate()
            begin
                Validate("Discount Amount", "Discount %" / 100 * "Subtotal Amount");
                updateDocLines(FieldNo("Discount %"));
            end;
        }
        field(14; "Discount Amount"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                validate("Line Amount", "Subtotal Amount" - "Discount Amount");
                updateDocLines(FieldNo("Discount Amount"));
            end;
        }
        field(15; "VAT Prod. Posting Group"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "VAT Product Posting Group";

            trigger OnValidate()
            begin
                calcPPN();
                updateDocLines(FieldNo("VAT Prod. Posting Group"));
            end;
        }
        field(16; "VAT Bus. Posting Group"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "VAT Business Posting Group";

            trigger OnValidate()
            begin
                calcPPN();
                updateDocLines(FieldNo("VAT Bus. Posting Group"));
            end;
        }
        field(17; "VAT %"; Decimal)
        {
            FieldClass = FlowField;
            Editable = FALSE;
            CalcFormula = Lookup("VAT Posting Setup"."VAT %" where("VAT Prod. Posting Group" = field("VAT Prod. Posting Group"), "VAT Bus. Posting Group" = field("VAT Bus. Posting Group")));
        }
        field(18; "VAT Amount"; Decimal)
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



        field(22; "WHT Amount"; Decimal)
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
        field(23; "Line Amount"; Decimal)
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
        field(24; "Total Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(25; "Purchase Req. No."; code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(26; "Purchase Req. Line No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(27; "Material Req. No."; code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(28; "Material Req. Line No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(29; "Check Win"; Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                lRec: Record "RFQ Line Details";
            begin
                IF xRec."Check Win" = FALSE AND "Check Win" THEN BEGIN
                    lRec.RESET;
                    lRec.SETRANGE("RFQ No.", "RFQ No.");
                    lRec.SETRANGE("RFQ Line No.", "RFQ Line No.");
                    lRec.SETFILTER("Entry No.", '<>%1', "Entry No.");
                    lRec.SETRANGE("Check Win", TRUE);
                    IF lRec.FINDFIRST THEN BEGIN
                        lRec."Check Win" := FALSE;
                        lRec.Modify();
                    END;
                END;
            end;
        }
        field(30; "Status RFQ Details"; Enum "RFQ Line Details Status")
        {
            DataClassification = ToBeClassified;
        }
        field(31; "Entry No. RFQ Line"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(32; "Entry No. RFQ Vendor"; Integer)
        {
            DataClassification = ToBeClassified;
            TableRelation = "RFQ Vendor List"."Entry No. RFQ Vendor" where("RFQ No." = field("RFQ No."));

            trigger OnValidate()
            var
                lRecRFQVendor: Record "RFQ Vendor List";
            begin
                IF xRec."Entry No. RFQ Vendor" <> Rec."Entry No. RFQ Vendor" THEN BEGIN
                    lRecRFQVendor.RESET;
                    lRecRFQVendor.SETRANGE(lRecRFQVendor."RFQ No.", Rec."RFQ No.");
                    lRecRFQVendor.SETRANGE(lRecRFQVendor."Entry No. RFQ Vendor", Rec."Entry No. RFQ Vendor");
                    IF lRecRFQVendor.FINDFIRST THEN BEGIN
                        Validate("Vendor No.", lRecRFQVendor."Vendor No.");
                    END;
                END;
            end;
        }
        field(33; "Remarks"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(34; "PPH 22"; Boolean)
        {
            DataClassification = ToBeClassified;


        }
        field(38; "Payment Terms"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Payment Terms";
            trigger OnValidate()
            var
                lRec: Record "Payment Terms";
            begin
                lRec.RESET;
                lRec.SETRANGE(lRec.Code, Rec."Payment Terms");
                IF lRec.FINDFIRST THEN BEGIN
                    "Payment Terms Name" := lRec.Description;
                END
                ELSE BEGIN
                    "Payment Terms Name" := '';
                END;
            end;
        }

        field(36; "PBBKB Amount"; Decimal)
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
        field(37; "Status RFQ"; Enum "PR Module Status")
        {
            FieldClass = FlowField;
            CalcFormula = lookup("RFQ Header".Status WHERE("RFQ No." = field("RFQ No.")));
        }
        field(39; "Delivery Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(40; shipmentMet; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Shipment Method";

            trigger OnValidate()
            var
                lRec: Record "Shipment Method";
            begin
                lRec.RESET;
                lRec.SETRANGE(lRec.Code, REc.shipmentMet);
                IF lRec.FINDFIRST THEN BEGIN
                    "Shipment Method Name" := lRec.Description;
                END
                ELSE BEGIN
                    "Shipment Method Name" := '';
                END;
            end;
        }
        field(41; "Shipment Method Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(42; "Payment Terms Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(43; "Expected Receipt Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Expected Receipt Date';
        }

    }
    keys
    {
        key(PK; "Entry No.", "RFQ No.", "RFQ Line No.", "Vendor No.")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; "Vendor No.", "Vendor Name", "Unit Price", "Discount %", "Total Amount")
        {
        }
    }
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


    trigger OnDelete()
    var
        lrecRFQHeader: Record "RFQ Header";
    begin
        lrecRFQHeader.RESET();
        lrecRFQHeader.SetRange("RFQ No.", Rec."RFQ No.");
        IF lrecRFQHeader.FIND('-') then lrecRFQHeader.TestField(Status, lrecRFQHeader.Status::Open);
        gCURFQFunct.checkRFQLinehasPO(Rec."RFQ No.", Rec."RFQ Line No.", 'delete');
        gCURFQFunct.resetRFQLineWinner(Rec);
    end;

    procedure updateDocLines(FieldRef: Integer)
    var
        lRecRFQLine: Record "RFQ Line";
    begin
        lRecRFQLine.RESET;
        lRecRFQLine.SETRANGE(lRecRFQLine."RFQ No.", Rec."RFQ No.");
        lRecRFQLine.SETRANGE(lRecRFQLine."Winner RFQ Line Details", Rec."Entry No.");
        IF lRecRFQLine.FIND('-') THEN BEGIN
            REPEAT
                IF lRecRFQLine."Winner RFQ Line Details" <> 0 THEN BEGIN
                    case FieldRef of
                        FieldNo("Vendor No."):
                            lRecRFQLine.VALIDATE("Vendor No.", "Vendor No.");
                        FieldNo("Unit Price"):
                            lRecRFQLine.VALIDATE("Unit Price", "Unit Price");
                        FieldNo("Discount %"):
                            lRecRFQLine.VALIDATE("Discount %", "Discount %");
                        FieldNo("Discount Amount"):
                            lRecRFQLine.VALIDATE("Discount Amount", "Discount Amount");
                        FieldNo("VAT Bus. Posting Group"):
                            lRecRFQLine.VALIDATE("VAT Bus. Posting Group", "VAT Bus. Posting Group");
                        FieldNo("VAT Prod. Posting Group"):
                            lRecRFQLine.VALIDATE("VAT Prod. Posting Group", "VAT Prod. Posting Group");

                    end;
                    lRecRFQLine.MODIFY(TRUE);
                END;
            UNTIL lRecRFQLine.NEXT = 0;
        END;
    end;

    var
        UOMMgt: Codeunit "Unit of Measure Management";
        Item: Record Item;
        gCURFQFunct: Codeunit "RFQ Function";
}
