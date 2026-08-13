report 50102 "PR Material Printout"
{
    Caption = 'PR Material';
    DefaultRenderingLayout = "PR Material";
    UsageCategory = Documents;
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem(PRHeader; "PR Material Header")
        {
            RequestFilterFields = "Purchase Req. No.";

            column(CompanyName; gRecCompany.Name)
            {
            }
            column(CompanyPicture; gRecCompany.Picture)
            {
            }
            column(PRNo; "Purchase Req. No.")
            {
            }
            column(PRDate; "Request Date")
            {
            }
            column(MRNo; gMRNo)
            {
            }
            column(MRDate; gMRDate)
            {
            }
            column(Shortcut_Dimension_1_Code; "Shortcut Dimension 1 Code")
            {
            }
            column(Requester_Name; "Requester Name")
            {
            }
            column(RemarksHeader; Remarks)
            {
            }
            column(Urgent_Status; FORMAT("Urgent Status"))
            {
            }
            column(Approval1Name; Approval1Name)
            {
            }
            column(Approval1Email; Approval1Email)
            {
            }
            column(LDTM1; LDTM1)
            {
            }
            column(CreatedBy; Funct.GetFullNameUserIDGUID(PRHeader.SystemCreatedBy))
            {
            }
            column(Approval2Name; Approval2Name)
            {

            }
            column(Approval2Email; Approval2Email)
            {

            }
            column(LDTM2; LDTM2)
            {

            }
            dataitem(PRLine; "PR Material Line")
            {
                DataItemLink = "Purchase Req. No." = field("Purchase Req. No.");

                column(No_; "Item No.")
                {
                }
                column(Description; Description)
                {
                }
                column(Quantity; Quantity)
                {
                }
                column(Unit_of_Measure; "Unit of Measure")
                {
                }
                column(PartNo; "Part No.")
                {
                }
                column(Direct_Unit_Cost; "Direct Unit Cost")
                {
                }
                column(Line_Amount; "Line Amount")
                {
                }
                column(RemarksLine; Remarks)
                {
                }
                column(gStock; gStock)
                {
                }
                column(gKurang; gKurang)
                {
                }
                column(gDiorder; gDiorder)
                {
                }
                column(gRowNo; gRowNo)
                {
                }
                trigger OnAfterGetRecord()
                begin
                    CLEAR(gStock);
                    CLEAR(gKurang);
                    CLEAR(gDiorder);
                    gRowNo += 1;
                    PRLine.CalcFields(Inventory);
                    gStock := PRLine.Inventory;
                    // IF gStock <= 0 THEN BEGIN
                    gKurang := PRLine.Inventory - PRLine.Quantity;
                    gDiorder := PRLine.Quantity;
                    // gDiorder := ABS(gKurang);
                    // END ELSE BEGIN
                    //     gKurang := 0;
                    //     gDiorder := PRLine.Quantity;
                    // END;
                end;
            }
            trigger OnAfterGetRecord()
            var
                lRecMRHeader: Record "Material Req. Header";
                lRecPRLine: Record "PR Material Line";
                currMRNo: Code[20];
                i: integer;
                firstrecord: Boolean;
                lengthPRNo: Integer;
                pos8PRNo: Integer;
                DTCancel: DateTime;
                ApprovCancel: Record "Approval Entry";
            begin
                i := 0;
                firstrecord := TRUE;
                lRecPRLine.RESET;
                lRecPRLine.SETRANGE(lRecPRLine."Purchase Req. No.", PRHeader."Purchase Req. No.");
                lRecPRLine.SETCURRENTKEY(lRecPRLine."Material Req. No.");
                lRecPRLine.ASCENDING(TRUE);
                IF lRecPRLine.FIND('-') THEN BEGIN
                    REPEAT
                        CLEAR(lengthPRNo);
                        CLEAR(pos8PRNo);
                        IF currMRNo <> lRecPRLine."Material Req. No." THEN BEGIN
                            IF firstrecord THEN BEGIN
                                gMRNo := lRecPRLine."Material Req. No.";
                                lRecMRHeader.RESET;
                                lRecMRHeader.SETRANGE(lRecMRHeader."Material Req. No.", lRecPRLine."Material Req. No.");
                                IF lRecMRHeader.FINDFIRST THEN BEGIN
                                    gMRDate := FORMAT(lRecMRHeader."Document Date", 0, '<Day,2> <Month Text> <Year4>');
                                END;
                                firstrecord := FALSE;
                            END
                            ELSE BEGIN
                                lengthPRNo := STRLEN(lRecPRLine."Material Req. No.");
                                pos8PRNo := lengthPRNo - 7;
                                IF pos8PRNo < 0 THEN pos8PRNo := 0;
                                gMRNo := gMRNo + ',' + COPYSTR(lRecPRLine."Material Req. No.", pos8PRNo, lengthPRNo);
                                lRecMRHeader.RESET;
                                lRecMRHeader.SETRANGE(lRecMRHeader."Material Req. No.", lRecPRLine."Material Req. No.");
                                IF lRecMRHeader.FINDFIRST THEN BEGIN
                                    gMRDate := gMRDate + ',' + FORMAT(lRecMRHeader."Document Date", 0, '<Day,2> <Month Text> <Year4>');
                                END;
                            END;
                            i += 1;
                        END;
                        currMRNo := lRecPRLine."Material Req. No.";
                    UNTIL (lRecPRLine.NEXT = 0) OR (i = 3);
                    IF gMRNo = '' THEN gMRNo := 'STOCK GUDANG';
                END;



                Approval1Name := '';
                Approval1Role := '';
                Approval1Email := '';
                Clear(LDTM1);
                Approval2Name := '';
                Approval2Role := '';
                Approval2Email := '';
                Clear(LDTM2);
                Approval3Name := '';
                Approval3Role := '';
                Approval3Email := '';
                Clear(LDTM3);

                Approval1Name := approval(PRHeader."Purchase Req. No.", 1, DTCancel);
                Approval1Role := approvalR(PRHeader."Purchase Req. No.", 1, DTCancel);
                Approval1Email := approvalE(PRHeader."Purchase Req. No.", 1, DTCancel);
                LDTM1 := approvalTime(PRHeader."Purchase Req. No.", 1, DTCancel);
                Approval2Name := approval(PRHeader."Purchase Req. No.", 2, DTCancel);
                Approval2Role := approvalR(PRHeader."Purchase Req. No.", 2, DTCancel);
                Approval2Email := approvalE(PRHeader."Purchase Req. No.", 2, DTCancel);
                LDTM2 := approvalTime(PRHeader."Purchase Req. No.", 2, DTCancel);
                Approval3Name := approval(PRHeader."Purchase Req. No.", 3, DTCancel);
                Approval3Role := approvalR(PRHeader."Purchase Req. No.", 3, DTCancel);
                Approval3Email := approvalE(PRHeader."Purchase Req. No.", 3, DTCancel);
                LDTM3 := approvalTime(PRHeader."Purchase Req. No.", 3, DTCancel);
            end;


        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(processing)
            {
            }
        }
    }
    rendering
    {
        layout("PR Material")
        {
            Type = RDLC;
            LayoutFile = 'Report/Layout/PR Material - Landscape.rdl';
        }
    }

    local procedure approval(doc_no: Code[20]; seq_no: integer; DTC: DateTime): Text
    var
        postedApprov: Record "Approval Entry";
        userNameLoc: code[100];
    begin
        postedApprov.SetRange("Document No.", doc_no);
        postedApprov.SetRange("Sequence No.", seq_no);
        postedApprov.SetFilter(Status, '%1', postedApprov.Status::Approved);
        postedApprov.SetFilter("Date-Time Sent for Approval", '>%1', DTC);
        if postedApprov.FindFirst() then begin
            //userNameLoc := approvalName(postedApprov."Approver ID");
            userNameLoc := postedApprov."Approver ID";
        end;
        exit(userNameLoc);
    end;

    local procedure approvalR(doc_no: Code[20]; seq_no: integer; DTC: DateTime): Text
    var
        postedApprov: Record "Approval Entry";
        userNameLoc: code[100];
    begin
        postedApprov.SetRange("Document No.", doc_no);
        postedApprov.SetRange("Sequence No.", seq_no);
        postedApprov.SetFilter(Status, '%1', postedApprov.Status::Approved);
        postedApprov.SetFilter("Date-Time Sent for Approval", '>%1', DTC);
        if postedApprov.FindFirst() then begin
            //userNameLoc := approvalName(postedApprov."Approver ID");
            userNameLoc := postedApprov."Approver ID";
        end;
        exit(userNameLoc);
    end;

    local procedure approvalE(doc_no: Code[20]; seq_no: integer; DTC: DateTime): Text
    var
        postedApprov: Record "Approval Entry";
        EmailName: Text[250];
    begin
        postedApprov.SetRange("Document No.", doc_no);
        postedApprov.SetRange("Sequence No.", seq_no);
        postedApprov.SetFilter(Status, '%1', postedApprov.Status::Approved);
        postedApprov.SetFilter("Date-Time Sent for Approval", '>%1', DTC);
        if postedApprov.FindFirst() then begin
            EmailName := approvalEmail(postedApprov."Approver ID");
        end;
        exit(EmailName);
    end;

    local procedure approvalName(userID: Code[50]): Text
    var
        user: Record User;
        userName: code[100];
    begin
        userName := '';
        user.SetRange("User Name", userID);
        if user.FindFirst() then begin
            userName := user."Full Name";
        end;
        exit(userName);
    end;

    local procedure approvalEmail(userID: Code[50]): Text
    var
        user: Record User;
        Email: text[250];
    begin
        Email := '';
        user.SetRange("User Name", userID);
        if user.FindFirst() then begin
            Email := user."Authentication Email";
        end;
        exit(Email);
    end;

    local procedure approvalRole(userID: Code[50]): Text
    var
        user: Record "User Task Group Member";
        Role: Code[20];
    begin
        Role := '';
        user.SetRange("User Name", userID);
        if user.FindFirst() then begin
            Role := user."User Task Group Code";
        end;
        exit(Role);
    end;

    local procedure approvalTime(doc_no: Code[20]; seq_no: integer; DTC: DateTime): DateTime
    var
        postedApprov: Record "Approval Entry";
        LDTMLoc: DateTime;
    begin
        postedApprov.SetRange("Document No.", doc_no);
        postedApprov.SetRange("Sequence No.", seq_no);
        postedApprov.SetFilter(Status, '%1', postedApprov.Status::Approved);
        postedApprov.SetFilter("Date-Time Sent for Approval", '>%1', DTC);
        if postedApprov.FindSet() then begin
            LDTMLoc := postedApprov."Last Date-Time Modified";
        end;
        exit(LDTMLoc);
    end;

    trigger OnInitReport()
    begin
        gRecCompany.GET();
        gRecCompany.CalcFields(Picture);
        gRowNo := 0;
    end;

    trigger OnPostReport()
    begin
    end;

    var
        gRecCompany: Record "Company Information";
        gMRNo, gMRDate : Text[250];
        gStock, gKurang, gDiorder : Decimal;
        gRowNo: integer;

        Funct: Codeunit "MII Function";

        Approval1Name: text[100];
        Approval1Role: Code[20];
        Approval1Email: text[250];
        LDTM1: DateTime;
        Approval2Name: text[100];
        Approval2Role: Code[20];
        Approval2Email: text[250];
        LDTM2: DateTime;
        Approval3Name: text[100];
        Approval3Role: Code[20];
        Approval3Email: text[250];
        LDTM3: DateTime;
}
