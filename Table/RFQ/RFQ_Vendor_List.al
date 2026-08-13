namespace RFQ.vendor_List;
using Microsoft.Purchases.Vendor;
using Microsoft.Foundation.Shipping;
using Microsoft.Sales.Customer;
using Microsoft.Foundation.PaymentTerms;
table 50118 RFQ_Vendor_
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No. RFQ Vendor"; Integer)
        {
            DataClassification = ToBeClassified;
            AutoIncrement = TRUE;
        }
        field(2; "RFQ No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Vendor No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Vendor."No." where(Blocked = const(" "));

            trigger OnValidate()
            var
                lrecVendor: Record Vendor;
                lRecRFQLine: Record "RFQ Line";
                lRecRFQHeader: Record "RFQ Header";
            begin
                lRecRFQHeader.RESET;
                lRecRFQHeader.SETRANGE(lRecRFQHeader."RFQ No.", Rec."RFQ No.");
                IF lRecRFQHeader.FINDFIRST THEN lRecRFQHeader.TestField(lRecRFQHeader.Status, lRecRFQHeader.Status::Open);
                // checkCountLine();
                //checkVendorExist();
                lrecVendor.RESET;
                if lrecVendor.GET("Vendor No.") then begin
                    "Vendor Name" := lrecVendor.Name;
                    VALIDATE("Payment Terms Code", lrecVendor."Payment Terms Code");
                    VALIDATE("Shipment Method Code", lrecVendor."Shipment Method Code");
                end
                else begin
                    "Vendor Name" := '';
                    VALIDATE("Payment Terms Code", '');
                    VALIDATE("Shipment Method Code", '');
                end;
                updRFQLineDetailsfromVendor();
            end;
        }
        field(4; "Vendor Name"; Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Remarks"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Total Quote Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("RFQ Line"."Total Amount" where("RFQ No." = Field("RFQ No."), "Vendor No." = field("Vendor No.")));
        }
        field(7; "Status RFQ"; Enum "PR Module Status")
        {
            FieldClass = FlowField;
            CalcFormula = lookup("RFQ Header".Status WHERE("RFQ No." = field("RFQ No.")));
        }
        field(8; "Payment Terms Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Payment Terms";

            trigger OnValidate()
            var
                lRec: Record "Payment Terms";
            begin
                lRec.RESET;
                lRec.SETRANGE(lRec.Code, Rec."Payment Terms Code");
                IF lRec.FINDFIRST THEN BEGIN
                    "Payment Terms Name" := lRec.Description;
                END
                ELSE BEGIN
                    "Payment Terms Name" := '';
                END;
            end;
        }
        field(9; "Payment Terms Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Ship-to Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Customer;

            trigger OnValidate()
            var
                lRec: Record "Customer";
            begin
                lRec.RESET;
                lRec.SETRANGE(lRec."No.", Rec."Ship-to Code");
                IF lRec.FINDFIRST THEN BEGIN
                    "Ship-to Name" := lRec.Name;
                END
                ELSE BEGIN
                    "Ship-to Name" := '';
                END;
            end;
        }
        field(11; "Ship-to Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(12; "Shipping Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(13; "Shipment Method Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Shipment Method";

            trigger OnValidate()
            var
                lRec: Record "Shipment Method";
            begin
                lRec.RESET;
                lRec.SETRANGE(lRec.Code, REc."Shipment Method Code");
                IF lRec.FINDFIRST THEN BEGIN
                    "Shipment Method Name" := lRec.Description;
                END
                ELSE BEGIN
                    "Shipment Method Name" := '';
                END;
            end;
        }
        field(14; "Shipment Method Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        // field(15; "Check Win"; Boolean)
        // {
        //     DataClassification = ToBeClassified;

        //     trigger OnValidate()
        //     var
        //         lRec: Record "RFQ Line";
        //         lRecRFQVendor: Record "RFQ Vendor List";
        //     begin
        //         IF "Check Win" THEN BEGIN
        //             IF xRec."Check Win" = FALSE THEN BEGIN
        //                 lRecRFQVendor.RESET;
        //                 lRecRFQVendor.SETRANGE("RFQ No.", "RFQ No.");
        //                 lRecRFQVendor.SETFILTER("Entry No. RFQ Vendor", '<>%1', "Entry No. RFQ Vendor");
        //                 lRecRFQVendor.SETRANGE("Check Win", TRUE);
        //                 IF lRecRFQVendor.FINDFIRST THEN BEGIN
        //                     lRecRFQVendor."Check Win" := FALSE;
        //                     lRecRFQVendor.Modify();
        //                 END;
        //             END;
        //             gCURFQFunct.updWinAllRFQLine(Rec, TRUE);
        //         END
        //         ELSE BEGIN
        //             gCURFQFunct.updWinAllRFQLine(Rec, FALSE);
        //         END;
        //     end;
        // }
    }
    keys
    {
        key(PK; "RFQ No.", "Entry No. RFQ Vendor")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; "Vendor No.", "Vendor Name")
        {
        }
    }
    trigger OnInsert()
    begin
        //checkCountLine();
    end;

    trigger OnDelete()
    var
        lrecRFQHeader: Record "RFQ Header";
    begin
        lrecRFQHeader.RESET();
        lrecRFQHeader.SetRange("RFQ No.", Rec."RFQ No.");
        IF lrecRFQHeader.FIND('-') then lrecRFQHeader.TestField(Status, lrecRFQHeader.Status::Open);
        gCURFQFunct.deleteRFQLineDetails(Rec.RecordId);
    end;

    // procedure checkVendorExist()
    // var
    //     lRec: Record "RFQ Vendor List";
    // begin
    //     lRec.RESET;
    //     lRec.SETRANGE(lRec."RFQ No.", Rec."RFQ No.");
    //     lRec.SetRange(lRec."Vendor No.", Rec."Vendor No.");
    //     lRec.SETFILTER(lRec."Entry No. RFQ Vendor", '<>%1', Rec."Entry No. RFQ Vendor");
    //     IF lRec.FINDFIRST THEN ERROR('Vendor %1 already chosen, you must choose different vendor', Rec."Vendor No.");
    // end;

    procedure updRFQLineDetailsfromVendor()
    var
        lRecRFQLineDet: Record "RFQ Line Details";
    begin
        lRecRFQLineDet.RESET;
        lRecRFQLineDet.SETRANGE(lRecRFQLineDet."RFQ No.", "RFQ No.");
        lRecRFQLineDet.SETRANGE(lRecRFQLineDet."Entry No. RFQ Vendor", "Entry No. RFQ Vendor");
        IF lRecRFQLineDet.FIND('-') THEN BEGIN
            REPEAT // IF lRecRFQLineDet."Check Win" THEN
                //     ERROR('Vendor "%1" is winning in description "%2" line "%3", please cancel win first', xRec."Vendor Name", lRecRFQLineDet."Description", lRecRFQLineDet."RFQ Line No.");
                lRecRFQLineDet.VALIDATE(lRecRFQLineDet."Vendor No.", Rec."Vendor No.");
                lRecRFQLineDet.MODIFY(TRUE);
            UNTIL lRecRFQLineDet.NEXT = 0;
        END;
    end;

    // procedure checkCountLine()
    // var
    //     lRec: Record "RFQ Vendor List";
    // begin
    //     lRec.RESET;
    //     lRec.SETRANGE("RFQ No.", Rec."RFQ No.");
    //     IF lRec.COUNT >= 3 THEN BEGIN
    //         ERROR('Only max %1 vendor can be added', 3);
    //     END;
    // end;

    var
        gCURFQFunct: Codeunit "RFQ Function";
}
