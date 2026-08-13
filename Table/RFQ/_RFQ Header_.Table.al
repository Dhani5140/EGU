table 50105 "RFQ Header"
{
    Caption = 'RFQ Header';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "RFQ No."; Code[20])
        {
            Caption = 'RFQ No.';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                lRecMSISetup: Record "MII Setup";
            begin
                lRecMSISetup.GET();
                IF "RFQ No." <> xRec."RFQ No." THEN BEGIN
                    NoSeries.TestManual(lRecMSISetup."RFQ Nos.");
                    "No. Series" := '';
                END;
            end;
        }
        field(2; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "No. Series";
        }
        field(3; "Document Date"; Date)
        {
            Caption = 'Document Date';
            DataClassification = ToBeClassified;
        }
        field(4; Status; Enum "PR Module Status")
        {
            Caption = 'Status';
            DataClassification = ToBeClassified;


            trigger OnValidate()
            var
                lCURFQFunct: Codeunit "RFQ Function";
            begin
                Case Status OF
                    Status::Released:
                        IF xRec.Status <> xRec.Status::Released THEN BEGIN
                            // JANGAN panggil checkRFQLinehasWinner di sini
                            // Winner belum dipilih saat Release, ini salah secara bisnis
                        END;
                    Status::Open:
                        BEGIN
                            IF xRec.Status <> xRec.Status::Open THEN
                                lCURFQFunct.checkRFQLinehasPO(Rec."RFQ No.", 0, 'reopen');
                        END;
                    Status::"Send To Vendor":
                        BEGIN
                            IF xRec.Status <> xRec.Status::Released THEN
                                ERROR('Status harus Released sebelum Send To Vendor.');
                            lCURFQFunct.checkVendorListNotEmpty(Rec."RFQ No.");
                        END;
                End;
            end;
        }
        field(5; "Created By"; code[250])
        {
            Caption = 'Created By';
            DataClassification = ToBeClassified;
        }
        field(6; "Created Date"; DateTime)
        {
            Caption = 'Created Date';
            DataClassification = ToBeClassified;
        }
        field(7; "Last Modified Date"; DateTime)
        {
            Caption = 'Last Modified Date';
            DataClassification = ToBeClassified;
        }
        field(8; "Last Modified By"; code[250])
        {
            Caption = 'Last Modified By';
            DataClassification = ToBeClassified;
        }
        field(9; "Total Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = SUM("RFQ Line"."Total Amount" where("RFQ No." = field("RFQ No.")));
        }
        field(10; "Material Req. No."; code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Purchase Request No."; Code[20])
        {
            Caption = 'Purchase Request No.';
            DataClassification = ToBeClassified;
        }
        field(12; "Location Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Location";

            trigger OnValidate()
            var
                lRecRFQLine: Record "RFQ Line";
                LabelConfirm: Label 'This will change "Location Code" in all line, do you want to continue?';
            begin
                lRecRFQLine.RESET();
                lRecRFQLine.SetRange("RFQ No.", Rec."RFQ No.");
                IF lRecRFQLine.FIND('-') then // IF Confirm(LabelConfirm) THEN BEGIN
                    updateDocLines(FieldNo("Location Code"));
                // END;
            END;
        }
        field(13; "External Document No."; Code[35])
        {
            DataClassification = ToBeClassified;
        }
        field(14; "Remarks"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(15; "Shortcut Dimension 1 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1), Blocked = CONST(FALSE));
            CaptionClass = '1,2,1';

            trigger OnValidate()
            begin
                UpdateDocLines(FieldNo("Shortcut Dimension 1 Code"));
            end;
        }
        field(16; "Shortcut Dimension 2 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2), Blocked = CONST(FALSE));
            CaptionClass = '1,2,2';

            trigger OnValidate()
            begin
                UpdateDocLines(FieldNo("Shortcut Dimension 2 Code"));
            end;
        }
        field(17; "Shortcut Dimension 3 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3), Blocked = CONST(FALSE));
            CaptionClass = '1,2,3';

            trigger OnValidate()
            begin
                UpdateDocLines(FieldNo("Shortcut Dimension 3 Code"));
            end;
        }
        field(18; "Shortcut Dimension 4 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4), Blocked = CONST(FALSE));
            CaptionClass = '1,2,4';

            trigger OnValidate()
            begin
                UpdateDocLines(FieldNo("Shortcut Dimension 4 Code"));
            end;
        }
        field(19; "Shortcut Dimension 5 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(5), Blocked = CONST(FALSE));
            CaptionClass = '1,2,5';

            trigger OnValidate()
            begin
                UpdateDocLines(FieldNo("Shortcut Dimension 5 Code"));
            end;
        }
        field(20; "Shortcut Dimension 6 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(6), Blocked = CONST(FALSE));
            CaptionClass = '1,2,6';

            trigger OnValidate()
            begin
                UpdateDocLines(FieldNo("Shortcut Dimension 6 Code"));
            end;
        }
        field(21; "Shortcut Dimension 7 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(7), Blocked = CONST(FALSE));
            CaptionClass = '1,2,7';

            trigger OnValidate()
            begin
                UpdateDocLines(FieldNo("Shortcut Dimension 7 Code"));
            end;
        }
        field(22; "Shortcut Dimension 8 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(8), Blocked = CONST(FALSE));
            CaptionClass = '1,2,8';

            trigger OnValidate()
            begin
                UpdateDocLines(FieldNo("Shortcut Dimension 8 Code"));
            end;
        }
        field(23; "Batch No. [PR]"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(24; "MR Usage Category"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "MR Usage Category".Code;

            trigger OnValidate()
            begin
                UpdateDocLines(FieldNo("MR Usage Category"));
            end;
        }
        field(25; "Unit Group"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Unit Group Dimension";

            trigger OnValidate()
            begin
                UpdateDocLines(FieldNo("Unit Group"));
            end;
        }
        field(26; "PR No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "PR Material Header"."Purchase Req. No." where(Status = filter(Released | Processed));
        }

        field(27; "Employee"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Employee."No.";

            trigger OnValidate()
            var
                lrecVendor: Record Employee;
            begin
                lrecVendor.RESET;
                if lrecVendor.GET(Employee) then begin
                    "Employee Name" := lrecVendor."First Name";
                    VALIDATE("Employee Name", lrecVendor."First Name");
                    //Validate(signin, lrecVendor."Sign In");
                    Validate("image signin", lrecVendor.Image);
                end
                else begin
                    "Employee Name" := '';
                    VALIDATE("Employee Name", '');
                    Validate(signin);



                end;
                UpdateDocLines(FieldNo(Employee));
            end;
        }

        field(28; "Employee Name"; text[20])
        {
            DataClassification = ToBeClassified;
        }

        field(29; "signin"; Blob)
        {
            Subtype = Bitmap;
            Caption = 'Sign-In';

        }
        field(30; "image signin"; Media)
        {
            Caption = 'Image';
            DataClassification = ToBeClassified;
        }


    }
    keys
    {
        key(PK; "RFQ No.")
        {
            Clustered = true;
        }
    }
    // trigger OnInsert()
    // var
    //     lRecMSISetup: Record "MII Setup";
    // begin
    //     if "RFQ No." = '' then begin
    //         lRecMSISetup.reset();
    //         IF lRecMSISetup.GET() then begin
    //             lRecMSISetup.TestField("RFQ Nos.");
    //         end;
    //         //NoSeriesMgt.InitSeries(lRecMSISetup."RFQ Nos.", lRecMSISetup."RFQ Nos.", 0D, "RFQ No.", lRecMSISetup."RFQ Nos.");
    //         NoSeries.AreRelated(lRecMSISetup."RFQ Nos.", lRecMSISetup."RFQ Nos.");
    //     END;
    //     "Document Date" := WORKDATE;
    //     "Created By" := UserId;
    //     "Created Date" := CurrentDateTime;
    //     "Last Modified By" := UserId;
    //     "Last Modified Date" := CurrentDateTime;
    //     Status := Status::Open;
    // end;

    trigger OnInsert()
    var
        lRecMSISetup: Record "MII Setup";
    begin
        if "RFQ No." = '' then begin
            lRecMSISetup.Get();
            lRecMSISetup.TestField("RFQ Nos.");
            "RFQ No." := NoSeries.GetNextNo(lRecMSISetup."RFQ Nos.", WorkDate);  // update 27.4
            "No. Series" := lRecMSISetup."RFQ Nos.";
        end;
        "Document Date" := WORKDATE;
        "Created By" := UserId;
        "Created Date" := CurrentDateTime;
        "Last Modified By" := UserId;
        "Last Modified Date" := CurrentDateTime;
        Status := Status::Open;
    end;


    trigger OnDelete()
    // var
    //     lrecRFQLine: Record "RFQ Line";
    // begin
    //     TestField("Status", "Status"::Open);
    //     lrecRFQLine.RESET();
    //     lrecRFQLine.SETRANGE("RFQ No.", Rec."RFQ No.");
    //     IF lrecRFQLine.Find('-') THEN BEGIN
    //         lrecRFQLine.DELETEALL(TRUE)
    //     END;
    // end;
    var
        lrecRFQLine: Record "RFQ Line";
        lrecRFQVendor: Record "RFQ Vendor List";  // <<< TAMBAH
    begin
        TestField("Status", "Status"::Open);  // Keep validation

        // Existing: Lines
        lrecRFQLine.RESET();
        lrecRFQLine.SETRANGE("RFQ No.", Rec."RFQ No.");
        IF lrecRFQLine.FIND('-') THEN lrecRFQLine.DELETEALL(TRUE);

        // TAMBAH: Vendors (auto cascade Line Details)
        lrecRFQVendor.RESET();
        lrecRFQVendor.SETRANGE("RFQ No.", Rec."RFQ No.");
        IF lrecRFQVendor.FIND('-') THEN lrecRFQVendor.DELETEALL(TRUE);
    end;

    trigger OnModify()
    begin
        "Last Modified By" := UserId;
        "Last Modified Date" := CurrentDateTime;
    end;

    // procedure AssistEdit(): Boolean
    // var
    //     lRecMSISetup: Record "MII Setup";
    // begin
    //     lRecMSISetup.GET;
    //     lRecMSISetup.TESTFIELD("RFQ Nos.");
    //     // IF NoSeriesMgt.SelectSeries(lRecMSISetup."RFQ Nos.", xRec."No. Series", Rec."No. Series") THEN BEGIN
    //     //     NoSeriesMgt.SetSeries(Rec."RFQ No.");
    //     IF NoSeries.LookupRelatedNoSeries(lRecMSISetup."RFQ Nos.", xRec."No. Series", Rec."No. Series") THEN BEGIN
    //         NoSeries.GetNextNo(Rec."RFQ No.");
    //         EXIT(TRUE);
    //     END;
    // end;

    procedure AssistEdit(): Boolean
    var
        lRecMSISetup: Record "MII Setup";
    begin
        lRecMSISetup.Get();
        lRecMSISetup.TestField("RFQ Nos.");

        if NoSeries.LookupRelatedNoSeries(lRecMSISetup."RFQ Nos.", xRec."No. Series", "No. Series") then begin
            "RFQ No." := NoSeries.GetNextNo("No. Series", WorkDate, true);  // ← Assign ke RFQ No.!
            exit(true);
        end;
    end;


    procedure updateDocLines(FieldRef: Integer)
    var
        lRecRFQLine: Record "RFQ Line";
    begin
        lRecRFQLine.RESET;
        lRecRFQLine.SETRANGE("RFQ No.", "RFQ No.");
        IF lRecRFQLine.FIND('-') THEN BEGIN
            REPEAT
                case FieldRef of
                    FieldNo("Shortcut Dimension 1 Code"):
                        lRecRFQLine.VALIDATE("Shortcut Dimension 1 Code", "Shortcut Dimension 1 Code");
                    FieldNo("Shortcut Dimension 2 Code"):
                        lRecRFQLine.VALIDATE("Shortcut Dimension 2 Code", "Shortcut Dimension 2 Code");
                    FieldNo("Shortcut Dimension 3 Code"):
                        lRecRFQLine.VALIDATE("Shortcut Dimension 3 Code", "Shortcut Dimension 3 Code");
                    FieldNo("Shortcut Dimension 4 Code"):
                        lRecRFQLine.VALIDATE("Shortcut Dimension 4 Code", "Shortcut Dimension 4 Code");
                    FieldNo("Shortcut Dimension 5 Code"):
                        lRecRFQLine.VALIDATE("Shortcut Dimension 5 Code", "Shortcut Dimension 5 Code");
                    FieldNo("Shortcut Dimension 6 Code"):
                        lRecRFQLine.VALIDATE("Shortcut Dimension 6 Code", "Shortcut Dimension 6 Code");
                    FieldNo("Shortcut Dimension 7 Code"):
                        lRecRFQLine.VALIDATE("Shortcut Dimension 7 Code", "Shortcut Dimension 7 Code");
                    FieldNo("Shortcut Dimension 8 Code"):
                        lRecRFQLine.VALIDATE("Shortcut Dimension 8 Code", "Shortcut Dimension 8 Code");
                    FieldNo("Location Code"):
                        lRecRFQLine.VALIDATE("Location Code", "Location Code");
                    FieldNo("Unit Group"):
                        lRecRFQLine.VALIDATE("Unit Group", "Unit Group");
                    FieldNo("MR Usage Category"):
                        lRecRFQLine.VALIDATE("MR Usage Category", "MR Usage Category");
                end;
                lRecRFQLine.MODIFY(TRUE);
            UNTIL lRecRFQLine.NEXT = 0;
        END;
    end;

    procedure SendRecords()
    var
        DocumentSendingProfile: Record "Document Sending Profile";
        ReportSelections: Record "Report Selections";
        DocTxt: Text[150];
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeSendRecords(Rec, IsHandled);
        if IsHandled then
            exit;



        GetReportSelectionsUsageFromDocumentType(ReportSelections.Usage, DocTxt);

        IsHandled := false;
        OnSendRecordsOnBeforeSendVendorRecords(ReportSelections.Usage, Rec, DocTxt, IsHandled);

    end;

    local procedure GetReportSelectionsUsageFromDocumentType(var ReportSelectionsUsage: Enum "Report Selection Usage"; var DocTxt: Text[150])
    var
        ReportSelections: Record "Report Selections";
        ReportDistributionMgt: Codeunit "Report Distribution Management";
        ReportUsage: Option;
    begin
        DocTxt := ReportDistributionMgt.GetFullDocumentTypeText(Rec);


        ReportUsage := ReportSelectionsUsage.AsInteger();
        OnAfterGetReportSelectionsUsageFromDocumentType(Rec, ReportUsage, DocTxt);
        ReportSelectionsUsage := "Report Selection Usage".FromInteger(ReportUsage);
    end;

    var
        //NoSeriesMgt: Codeunit NoSeriesManagement;
        NoSeries: Codeunit "No. Series";
        PictureUpdated: Boolean;
    // trigger OnDelete()
    // var
    //     lrecRFQLine: Record "RFQ Line";
    //     lrecVendDetail: Record "RFQ Vendor Detail";
    //     lrecVendList: Record "RFQ Vendor List";
    // begin
    //     lrecRFQLine.RESET();
    //     lrecRFQLine.SetRange("RFQNo.", Rec."RFQ No.");
    //     IF lrecRFQLine.FIND('-') THEN lrecRFQLine.DeleteAll();
    //     lrecVendDetail.RESET();
    //     lrecVendDetail.SetRange("RFQNo.", Rec."RFQ No.");
    //     IF lrecVendDetail.FIND('-') THEN lrecVendDetail.DeleteAll();
    //     lrecVendList.RESET();
    //     lrecVendList.SetRange("RFQ No.", Rec."RFQ No.");
    //     IF lrecVendList.FIND('-') THEN lrecVendList.DeleteAll();
    // end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeSendRecords(var PurchaseHeader: Record "RFQ Header"; var IsHandled: Boolean)
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
