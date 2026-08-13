table 50107 "RFQ Vendor List"
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
                IF lRecRFQHeader.FINDFIRST THEN
                    lRecRFQHeader.TestField(lRecRFQHeader.Status, lRecRFQHeader.Status::Open)
                else
                    IF lRecRFQHeader.FINDFIRST THEN lRecRFQHeader.TestField(lRecRFQHeader.Status, lRecRFQHeader.Status::"Send To Vendor");
                // checkCountLine();
                checkVendorExist();
                lrecVendor.RESET;
                if lrecVendor.GET("Vendor No.") then begin
                    "Vendor Name" := lrecVendor.Name;
                    VALIDATE("Payment Terms Code", lrecVendor."Payment Terms Code");
                    VALIDATE("Shipment Method Code", lrecVendor."Shipment Method Code");
                    Validate(email, lrecVendor."E-Mail");
                end
                else begin
                    "Vendor Name" := '';
                    VALIDATE("Payment Terms Code", '');
                    VALIDATE("Shipment Method Code", '');
                    Validate(email, '');
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
            TableRelation = "Customer";

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
        field(15; "Check Win"; Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                lRec: Record "RFQ Line";
                lRecRFQVendor: Record "RFQ Vendor List";
            begin
                IF "Check Win" THEN BEGIN
                    IF xRec."Check Win" = FALSE THEN BEGIN
                        lRecRFQVendor.RESET;
                        lRecRFQVendor.SETRANGE("RFQ No.", "RFQ No.");
                        lRecRFQVendor.SETFILTER("Entry No. RFQ Vendor", '<>%1', "Entry No. RFQ Vendor");
                        lRecRFQVendor.SETRANGE("Check Win", TRUE);
                        IF lRecRFQVendor.FINDFIRST THEN BEGIN
                            lRecRFQVendor."Check Win" := FALSE;
                            lRecRFQVendor.Modify();
                        END;
                    END;
                    gCURFQFunct.updWinAllRFQLine(Rec, TRUE);
                END
                ELSE BEGIN
                    gCURFQFunct.updWinAllRFQLine(Rec, FALSE);
                END;
            end;
        }
        field(16; Status; Enum "PR Module Status")
        {
            Caption = 'Status';
            FieldClass = FlowField;
            CalcFormula = lookup("RFQ Header".Status WHERE("RFQ No." = field("RFQ No.")));
        }
        field(17; email; Text[80])
        {
            Caption = 'Email';
            DataClassification = ToBeClassified;

        }
        field(18; "Expected Receipt Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Expected Receipt Date';
        }
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
        checkCountLine();
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

    trigger OnModify()
    begin

    end;

    procedure checkVendorExist()
    var
        lRec: Record "RFQ Vendor List";
    begin
        lRec.RESET;
        lRec.SETRANGE(lRec."RFQ No.", Rec."RFQ No.");
        lRec.SetRange(lRec."Vendor No.", Rec."Vendor No.");
        lRec.SETFILTER(lRec."Entry No. RFQ Vendor", '<>%1', Rec."Entry No. RFQ Vendor");
        IF lRec.FINDFIRST THEN ERROR('Vendor %1 already chosen, you must choose different vendor', Rec."Vendor No.");
    end;

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

    procedure checkCountLine()
    var
        lRec: Record "RFQ Vendor List";
        set: Record "MII Setup";
    begin
        lRec.RESET;
        lRec.SETRANGE("RFQ No.", Rec."RFQ No.");
        IF lRec.FindFirst() then begin
            set.Reset();
            set.Get();
            if lRec.COUNT >= set."RFQ Vendor" THEN BEGIN
                ERROR('Only max %1 vendor can be added', set."RFQ Vendor");
            END;
        end;
    end;

    procedure SendRecords()
    var
        DocumentSendingProfile: Record "Document Sending Profile";
        ReportSelections: Record "Report Selections";
        t: Record "RFQ Header";
        DocTxt: Text[150];
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeSendRecords(Rec, IsHandled);
        if IsHandled then
            exit;



        GetReportSelectionsUsageFromDocumentType(ReportSelections.Usage, DocTxt);

        IsHandled := false;
        OnSendRecordsOnBeforeSendVendorRecords(ReportSelections.Usage, t, DocTxt, IsHandled);

        if not IsHandled then
            DocumentSendingProfile.SendVendorRecords(
                ReportSelections.Usage.AsInteger(), Rec, DocTxt, "Vendor No.", "RFQ No.",
                FieldNo("Vendor No."), FieldNo("RFQ No."));
    end;


    local procedure GetReportSelectionsUsageFromDocumentType(var ReportSelectionsUsage: Enum "Report Selection Usage"; var DocTxt: Text[150])
    var
        ReportSelections: Record "Report Selections";
        ReportDistributionMgt: Codeunit "Report Distribution Management";
        ReportUsage: Option;
        t2: Record "RFQ Header";
    begin
        DocTxt := ReportDistributionMgt.GetFullDocumentTypeText(t2);


        ReportUsage := ReportSelectionsUsage.AsInteger();
        OnAfterGetReportSelectionsUsageFromDocumentType(t2, ReportUsage, DocTxt);
        ReportSelectionsUsage := "Report Selection Usage".FromInteger(ReportUsage);
    end;


    var
        gCURFQFunct: Codeunit "RFQ Function";

    [IntegrationEvent(false, false)]
    local procedure OnBeforeSendRecords(var PurchaseHeader: Record "RFQ Vendor List"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnSendRecordsOnBeforeSendVendorRecords(ReportUsage: Enum "Report Selection Usage"; var PurchaseHeader: Record "RFQ Header"; DocTxt: Text[150]; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterGetReportSelectionsUsageFromDocumentType(PurchaseHeader: Record "RFQ Header"; var ReportSelectionsUsage: Option; var DocTxt: Text[150]);
    begin
    end;
}
