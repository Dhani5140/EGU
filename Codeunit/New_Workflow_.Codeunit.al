codeunit 50103 "MII Workflow"
{
    Permissions = tabledata "Approval Entry" = rimd;

    trigger OnRun()
    begin
    end;

    var
        NothingtoApproveErr: Label 'There is nothing to approve';
        NoWorkflowEnb: Label 'No approval workflow for this record type is enabled';
        WorkflowMgt: Codeunit "Workflow Management";
        WorkflowResponseHandling: Codeunit "Workflow Response Handling";
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
        WorkflowSetup: Codeunit "Workflow Setup";
        //setup template
        PRWorkflowCategoryTxt: TextConst ENU = 'PURCHREQUEST';
        ConsWorkflowCategoryTxt: TextConst ENU = 'CONSIGNMENT';
        PRWorkflowCategoryDescTxt: TextConst ENU = 'Purchase Request';
        ConsWorkflowCategoryDescTxt: TextConst ENU = 'Consignment';
        // PRAssetWorkflowCategoryDescTxt: TextConst ENU = 'Purchase Request Asset';
        // MRWorkflowCategoryDescTxt: TextConst ENU = 'Material Request';
        // RFQWorkflowCategoryDescTxt: TextConst ENU = 'RFQ';
        PRMaterialApprovalWorkflowCodeTxt: TextConst ENU = 'PRMATERIAL';
        PRAssetApprovalWorkflowCodeTxt: TextConst ENU = 'PRASSET';
        MRApprovalWorkflowCodeTxt: TextConst ENU = 'MR';
        RFQApprovalWorkflowCodeTxt: TextConst ENU = 'RFQ';
        MRConsApprovalWorkflowCodeTxt: TextConst ENU = 'MRCONS';
        PRConsApprovalWorkflowCodeTxt: TextConst ENU = 'PRCONS';
        PRMaterialApprovalWorkfowDescTxt: TextConst ENU = 'Purchase Request Material Workflow';
        PRAssetApprovalWorkfowDescTxt: TextConst ENU = 'Purchase Request Asset Workflow';
        MRApprovalWorkfowDescTxt: TextConst ENU = 'Material Request Workflow';
        RFQApprovalWorkfowDescTxt: TextConst ENU = 'RFQ Workflow';
        MRConsApprovalWorkfowDescTxt: TextConst ENU = 'Material Request Consignment Workflow';
        PRConsApprovalWorkfowDescTxt: TextConst ENU = 'Purchase Request Consignment Workflow';
        PRMaterialTypeCondTxt: label '<?xml version = "1.0" encoding="utf-8" standalone="yes"?><ReportParameters><DataItems><DataItem name="PR Material Header">%1</DataItem></DataItems></ReportParameters>', Locked = true;
        PRAssetTypeCondTxt: label '<?xml version = "1.0" encoding="utf-8" standalone="yes"?><ReportParameters><DataItems><DataItem name="PR Asset Header">%1</DataItem></DataItems></ReportParameters>', Locked = true;
        MRTypeCondTxt: label '<?xml version = "1.0" encoding="utf-8" standalone="yes"?><ReportParameters><DataItems><DataItem name="Material Req. Header">%1</DataItem></DataItems></ReportParameters>', Locked = true;
        RFQTypeCondTxt: label '<?xml version = "1.0" encoding="utf-8" standalone="yes"?><ReportParameters><DataItems><DataItem name="RFQ Header">%1</DataItem></DataItems></ReportParameters>', Locked = true;
        MRConsTypeCondTxt: label '<?xml version = "1.0" encoding="utf-8" standalone="yes"?><ReportParameters><DataItems><DataItem name="MR Consignment Header">%1</DataItem></DataItems></ReportParameters>', Locked = true;
        PRConsTypeCondTxt: label '<?xml version = "1.0" encoding="utf-8" standalone="yes"?><ReportParameters><DataItems><DataItem name="PR Consignment Header">%1</DataItem></DataItems></ReportParameters>', Locked = true;
    //setup template
    //Workflow Event Code mandatory
    procedure RunWorkflowOnSendApprovalCode_PRMaterial(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnSendApproval_PRMaterial'))
    end;

    procedure RunWorkflowOnCancelApprovalCode_PRMaterial(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnCancelApproval_PRMaterial'))
    end;

    procedure RunWorkflowOnApproveApprovalCode_PRMaterial(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnApproveApproval_PRMaterial'))
    end;

    procedure RunWorkflowOnRejectApprovalCode_PRMaterial(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnRejectApproval_PRMaterial'))
    end;

    procedure RunWorkflowOnDelegateApprovalCode_PRMaterial(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnDelegateApproval_PRMaterial'))
    end;

    procedure RunWorkflowOnSendApprovalCode_PRAsset(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnSendApproval_PRAsset'))
    end;

    procedure RunWorkflowOnCancelApprovalCode_PRAsset(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnCancelApproval_PRAsset'))
    end;

    procedure RunWorkflowOnApproveApprovalCode_PRAsset(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnApproveApproval_PRAsset'))
    end;

    procedure RunWorkflowOnRejectApprovalCode_PRAsset(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnRejectApproval_PRAsset'))
    end;

    procedure RunWorkflowOnDelegateApprovalCode_PRAsset(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnDelegateApproval_PRAsset'))
    end;

    procedure RunWorkflowOnSendApprovalCode_MR(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnSendApproval_MR'))
    end;

    procedure RunWorkflowOnCancelApprovalCode_MR(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnCancelApproval_MR'))
    end;

    procedure RunWorkflowOnApproveApprovalCode_MR(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnApproveApproval_MR'))
    end;

    procedure RunWorkflowOnRejectApprovalCode_MR(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnRejectApproval_MR'))
    end;

    procedure RunWorkflowOnDelegateApprovalCode_MR(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnDelegateApproval_MR'))
    end;

    procedure RunWorkflowOnSendApprovalCode_RFQ(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnSendApproval_RFQ'))
    end;

    procedure RunWorkflowOnCancelApprovalCode_RFQ(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnCancelApproval_RFQ'))
    end;

    procedure RunWorkflowOnApproveApprovalCode_RFQ(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnApproveApproval_RFQ'))
    end;

    procedure RunWorkflowOnRejectApprovalCode_RFQ(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnRejectApproval_RFQ'))
    end;

    procedure RunWorkflowOnDelegateApprovalCode_RFQ(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnDelegateApproval_RFQ'))
    end;

    procedure RunWorkflowOnSendApprovalCode_MRCons(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnSendApproval_MRCons'))
    end;

    procedure RunWorkflowOnCancelApprovalCode_MRCons(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnCancelApproval_MRCons'))
    end;

    procedure RunWorkflowOnApproveApprovalCode_MRCons(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnApproveApproval_MRCons'))
    end;

    procedure RunWorkflowOnRejectApprovalCode_MRCons(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnRejectApproval_MRCons'))
    end;

    procedure RunWorkflowOnDelegateApprovalCode_MRCons(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnDelegateApproval_MRCons'))
    end;

    procedure RunWorkflowOnSendApprovalCode_PRCons(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnSendApproval_PRCons'))
    end;

    procedure RunWorkflowOnCancelApprovalCode_PRCons(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnCancelApproval_PRCons'))
    end;

    procedure RunWorkflowOnApproveApprovalCode_PRCons(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnApproveApproval_PRCons'))
    end;

    procedure RunWorkflowOnRejectApprovalCode_PRCons(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnRejectApproval_PRCons'))
    end;

    procedure RunWorkflowOnDelegateApprovalCode_PRCons(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnDelegateApproval_PRCons'))
    end;
    //Workflow Event Code mandatory
    //Workflow Handle Event mandatory
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Material Req. Approval", 'OnSendforApproval_MR', '', false, false)]
    procedure RunWorkflowOnSendApproval_MR(var ParRec: Record "Material Req. Header")
    begin
        WorkflowMgt.HandleEvent(RunWorkflowOnSendApprovalCode_MR(), ParRec);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Material Req. Approval", 'OnCancelforApproval_MR', '', false, false)]
    procedure RunWorkflowOnCancelApproval_MR(var ParRec: Record "Material Req. Header")
    begin
        WorkflowMgt.HandleEvent(RunWorkflowOnCancelApprovalCode_MR(), ParRec);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"PR Material Approval", 'OnSendforApproval_PRMaterial', '', false, false)]
    procedure RunWorkflowOnSendApproval_PRMaterial(var ParRec: Record "PR Material Header")
    begin
        WorkflowMgt.HandleEvent(RunWorkflowOnSendApprovalCode_PRMaterial(), ParRec);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"PR Material Approval", 'OnCancelforApproval_PRMaterial', '', false, false)]
    procedure RunWorkflowOnCancelApproval_PRMaterial(var ParRec: Record "PR Material Header")
    begin
        WorkflowMgt.HandleEvent(RunWorkflowOnCancelApprovalCode_PRMaterial(), ParRec);
    end;

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"PR Asset Approval", 'OnSendforApproval_PRAsset', '', false, false)]
    // procedure RunWorkflowOnSendApproval_PRAsset(var ParRec: Record "PR Asset Header")
    // begin
    //     WorkflowMgt.HandleEvent(RunWorkflowOnSendApprovalCode_PRAsset(), ParRec);
    // end;

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"PR Asset Approval", 'OnCancelforApproval_PRAsset', '', false, false)]
    // procedure RunWorkflowOnCancelApproval_PRAsset(var ParRec: Record "PR Asset Header")
    // begin
    //     WorkflowMgt.HandleEvent(RunWorkflowOnCancelApprovalCode_PRAsset(), ParRec);
    // end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"RFQ Approval", 'OnSendforApproval_RFQ', '', false, false)]
    procedure RunWorkflowOnSendApproval_RFQ(var ParRec: Record "RFQ Header")
    begin
        WorkflowMgt.HandleEvent(RunWorkflowOnSendApprovalCode_RFQ(), ParRec);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"RFQ Approval", 'OnCancelforApproval_RFQ', '', false, false)]
    procedure RunWorkflowOnCancelApproval_RFQ(var ParRec: Record "RFQ Header")
    begin
        WorkflowMgt.HandleEvent(RunWorkflowOnCancelApprovalCode_RFQ(), ParRec);
    end;

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"MR Consignment Approval", 'OnSendforApproval_MRCons', '', false, false)]
    // procedure RunWorkflowOnSendApproval_MRCons(var ParRec: Record "MR Consignment Header")
    // begin
    //     WorkflowMgt.HandleEvent(RunWorkflowOnSendApprovalCode_MRCons(), ParRec);
    // end;

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"MR Consignment Approval", 'OnCancelforApproval_MRCons', '', false, false)]
    // procedure RunWorkflowOnCancelApproval_MRCons(var ParRec: Record "MR Consignment Header")
    // begin
    //     WorkflowMgt.HandleEvent(RunWorkflowOnCancelApprovalCode_MRCons(), ParRec);
    // end;

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"PR Consignment Approval", 'OnSendforApproval_PRCons', '', false, false)]
    // procedure RunWorkflowOnSendApproval_PRCons(var ParRec: Record "PR Consignment Header")
    // begin
    //     WorkflowMgt.HandleEvent(RunWorkflowOnSendApprovalCode_PRCons(), ParRec);
    // end;

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"PR Consignment Approval", 'OnCancelforApproval_PRCons', '', false, false)]
    // procedure RunWorkflowOnCancelApproval_PRCons(var ParRec: Record "PR Consignment Header")
    // begin
    //     WorkflowMgt.HandleEvent(RunWorkflowOnCancelApprovalCode_PRCons(), ParRec);
    // end;

    procedure SetStatusToPendingApprovalCode_PRMaterial(): Code[128]
    begin
        exit(UpperCase('SetStatusToPendingApproval_PRMaterial'));
    end;

    procedure SetStatusToPendingApprovalCode_PRAsset(): Code[128]
    begin
        exit(UpperCase('SetStatusToPendingApproval_PRAsset'));
    end;

    procedure SetStatusToPendingApprovalCode_MR(): Code[128]
    begin
        exit(UpperCase('SetStatusToPendingApproval_MR'));
    end;

    procedure SetStatusToPendingApprovalCode_RFQ(): Code[128]
    begin
        exit(UpperCase('SetStatusToPendingApproval_RFQ'));
    end;

    procedure SetStatusToPendingApprovalCode_MRCons(): Code[128]
    begin
        exit(UpperCase('SetStatusToPendingApproval_MRCons'));
    end;

    procedure SetStatusToPendingApprovalCode_PRCons(): Code[128]
    begin
        exit(UpperCase('SetStatusToPendingApproval_PRCons'));
    end;

    procedure SetStatusToPendingApproval_Custom(var Variant: Variant)
    var
        RecRef: RecordRef;
        lRecPRMatHeader: Record "PR Material Header";
        //lRecPRAssHeader: Record "PR Asset Header";
        lRecMRHeader: Record "Material Req. Header";
        lRecRFQHeader: Record "RFQ Header";
    //lRecMRCons: Record "MR Consignment Header";
    //lRecPRCons: Record "PR Consignment Header";
    begin
        RecRef.GetTable(Variant);
        case RecRef.Number() of
            DATABASE::"PR Material Header":
                begin
                    RecRef.SetTable(lRecPRMatHeader);
                    lRecPRMatHeader.Validate("Status", lRecPRMatHeader."Status"::"Pending Approval");
                    lRecPRMatHeader.Modify(TRUE);
                    Variant := lRecPRMatHeader;
                end;
            // DATABASE::"PR Asset Header":
            //     begin
            //         RecRef.SetTable(lRecPRAssHeader);
            //         lRecPRAssHeader.Validate("Status", lRecPRAssHeader."Status"::"Pending Approval");
            //         lRecPRAssHeader.Modify(TRUE);
            //         Variant := lRecPRAssHeader;
            //     end;
            DATABASE::"Material Req. Header":
                begin
                    RecRef.SetTable(lRecMRHeader);
                    lRecMRHeader.Validate("Status", lRecMRHeader."Status"::"Pending Approval");
                    lRecMRHeader.Modify(TRUE);
                    Variant := lRecMRHeader;
                end;
            DATABASE::"RFQ Header":
                begin
                    RecRef.SetTable(lRecRFQHeader);
                    lRecRFQHeader.Validate("Status", lRecRFQHeader.Status::"Pending Approval");
                    lRecRFQHeader.Modify(TRUE);
                    Variant := lRecRFQHeader;
                end;
        // DATABASE::"MR Consignment Header":
        //     begin
        //         RecRef.SetTable(lRecMRCons);
        //         lRecMRCons.Validate("Status", lRecMRCons."Status"::"Pending Approval");
        //         lRecMRCons.Modify(TRUE);
        //         Variant := lRecMRCons;
        //     end;
        // DATABASE::"PR Consignment Header":
        //     begin
        //         RecRef.SetTable(lRecPRCons);
        //         lRecPRCons.Validate("Status", lRecPRCons."Status"::"Pending Approval");
        //         lRecPRCons.Modify(TRUE);
        //         Variant := lRecPRCons;
        //     end;
        end;
    end;

    procedure CancelApprovalCode_PRMaterial(): Code[128]
    begin
        exit(UpperCase('CancelApproval_PRMaterial'));
    end;

    procedure CancelApprovalCode_PRAsset(): Code[128]
    begin
        exit(UpperCase('CancelApproval_PRAsset'));
    end;

    procedure CancelApprovalCode_MR(): Code[128]
    begin
        exit(UpperCase('CancelApproval_MR'));
    end;

    procedure CancelApprovalCode_RFQ(): Code[128]
    begin
        exit(UpperCase('CancelApproval_RFQ'));
    end;

    procedure CancelApprovalCode_MRCons(): Code[128]
    begin
        exit(UpperCase('CancelApproval_MRCons'));
    end;

    procedure CancelApprovalCode_PRCons(): Code[128]
    begin
        exit(UpperCase('CancelApproval_PRCons'));
    end;

    procedure CancelApproval_Custom(var Variant: Variant)
    var
        RecRef: RecordRef;
        TargetRecRef: RecordRef;
        ApprovalEntry: Record "Approval Entry";
        lRecPRMatHeader: Record "PR Material Header";
        //lRecPRAssHeader: Record "PR Asset Header";
        //lRecMRCons: Record "MR Consignment Header";
        //lRecPRCons: Record "PR Consignment Header";
        lRecMRHeader: Record "Material Req. Header";
        lRecRFQHeader: Record "RFQ Header";
    begin
        RecRef.GetTable(Variant);
        case RecRef.Number() of
            DATABASE::"Approval Entry":
                begin
                    ApprovalEntry := Variant;
                    TargetRecRef.Get(ApprovalEntry."Record ID to Approve");
                    Variant := TargetRecRef;
                    CancelApproval_Custom(Variant);
                end;
            DATABASE::"PR Material Header":
                begin
                    RecRef.SetTable(lRecPRMatHeader);
                    ApprovalEntry.RESET;
                    ApprovalEntry.SETCURRENTKEY("Entry No.");
                    ApprovalEntry.SETRANGE(ApprovalEntry."Record ID to Approve", lRecPRMatHeader.RecordID);
                    ApprovalEntry.ASCENDING(TRUE);
                    IF ApprovalEntry.FINDLAST THEN BEGIN
                        updateStatusCancelApprovalEntryCustom(ApprovalEntry);
                    END;
                    Variant := lRecPRMatHeader;
                end;
            // DATABASE::"PR Asset Header":
            //     begin
            //         RecRef.SetTable(lRecPRAssHeader);
            //         ApprovalEntry.RESET;
            //         ApprovalEntry.SETCURRENTKEY("Entry No.");
            //         ApprovalEntry.SETRANGE(ApprovalEntry."Record ID to Approve", lRecPRAssHeader.RecordID);
            //         ApprovalEntry.ASCENDING(TRUE);
            //         IF ApprovalEntry.FINDLAST THEN BEGIN
            //             updateStatusCancelApprovalEntryCustom(ApprovalEntry);
            //         END;
            //         Variant := lRecPRAssHeader;
            //     end;
            DATABASE::"Material Req. Header":
                begin
                    RecRef.SetTable(lRecMRHeader);
                    ApprovalEntry.RESET;
                    ApprovalEntry.SETCURRENTKEY("Entry No.");
                    ApprovalEntry.SETRANGE(ApprovalEntry."Record ID to Approve", lRecMRHeader.RecordID);
                    ApprovalEntry.ASCENDING(TRUE);
                    IF ApprovalEntry.FINDLAST THEN BEGIN
                        updateStatusCancelApprovalEntryCustom(ApprovalEntry);
                    END;
                    Variant := lRecMRHeader;
                end;
            DATABASE::"RFQ Header":
                begin
                    RecRef.SetTable(lRecRFQHeader);
                    ApprovalEntry.RESET;
                    ApprovalEntry.SETCURRENTKEY("Entry No.");
                    ApprovalEntry.SETRANGE(ApprovalEntry."Record ID to Approve", lRecRFQHeader.RecordID);
                    ApprovalEntry.ASCENDING(TRUE);
                    IF ApprovalEntry.FINDLAST THEN BEGIN
                        updateStatusCancelApprovalEntryCustom(ApprovalEntry);
                    END;
                    Variant := lRecRFQHeader;
                end;
        // DATABASE::"MR Consignment Header":
        //     begin
        //         RecRef.SetTable(lRecMRCons);
        //         ApprovalEntry.RESET;
        //         ApprovalEntry.SETCURRENTKEY("Entry No.");
        //         ApprovalEntry.SETRANGE(ApprovalEntry."Record ID to Approve", lRecMRCons.RecordID);
        //         ApprovalEntry.ASCENDING(TRUE);
        //         IF ApprovalEntry.FINDLAST THEN BEGIN
        //             updateStatusCancelApprovalEntryCustom(ApprovalEntry);
        //         END;
        //         Variant := lRecMRCons;
        //     end;
        // DATABASE::"PR Consignment Header":
        //     begin
        //         RecRef.SetTable(lRecPRCons);
        //         ApprovalEntry.RESET;
        //         ApprovalEntry.SETCURRENTKEY("Entry No.");
        //         ApprovalEntry.SETRANGE(ApprovalEntry."Record ID to Approve", lRecPRCons.RecordID);
        //         ApprovalEntry.ASCENDING(TRUE);
        //         IF ApprovalEntry.FINDLAST THEN BEGIN
        //             updateStatusCancelApprovalEntryCustom(ApprovalEntry);
        //         END;
        //         Variant := lRecPRCons;
        //     end;
        end;
    end;

    procedure ReleaseCode_PRMaterial(): Code[128]
    begin
        exit(UpperCase('Release_PRMaterial'));
    end;

    procedure ReleaseCode_PRAsset(): Code[128]
    begin
        exit(UpperCase('Release_PRAsset'));
    end;

    procedure ReleaseCode_MR(): Code[128]
    begin
        exit(UpperCase('Release_MR'));
    end;

    procedure ReleaseCode_RFQ(): Code[128]
    begin
        exit(UpperCase('Release_RFQ'));
    end;

    procedure ReleaseCode_MRCons(): Code[128]
    begin
        exit(UpperCase('Release_MRCons'));
    end;

    procedure ReleaseCode_PRCons(): Code[128]
    begin
        exit(UpperCase('Release_PRCons'));
    end;

    procedure Release_Custom(var Variant: Variant)
    var
        RecRef: RecordRef;
        TargetRecRef: RecordRef;
        ApprovalEntry: Record "Approval Entry";
        lRecPRMatHeader: Record "PR Material Header";
        //lRecPRAssHeader: Record "PR Asset Header";
        //lRecMRCons: Record "MR Consignment Header";
        //lRecPRCons: Record "PR Consignment Header";
        lRecMRHeader: Record "Material Req. Header";
        lRecRFQHeader: Record "RFQ Header";
    begin
        RecRef.GetTable(Variant);
        case RecRef.Number() of
            DATABASE::"Approval Entry":
                begin
                    ApprovalEntry := Variant;
                    TargetRecRef.Get(ApprovalEntry."Record ID to Approve");
                    Variant := TargetRecRef;
                    Release_Custom(Variant);
                end;
            DATABASE::"PR Material Header":
                begin
                    RecRef.SetTable(lRecPRMatHeader);
                    lRecPRMatHeader.Validate("Status", lRecPRMatHeader."Status"::Released);
                    lRecPRMatHeader.Modify(TRUE);
                    Variant := lRecPRMatHeader;
                end;
            // DATABASE::"PR Asset Header":
            //     begin
            //         RecRef.SetTable(lRecPRAssHeader);
            //         lRecPRAssHeader.Validate("Status", lRecPRAssHeader."Status"::Released);
            //         lRecPRAssHeader.Modify(TRUE);
            //         Variant := lRecPRAssHeader;
            //     end;
            DATABASE::"Material Req. Header":
                begin
                    RecRef.SetTable(lRecMRHeader);
                    lRecMRHeader.Validate("Status", lRecMRHeader."Status"::Released);
                    lRecMRHeader.Modify(TRUE);
                    Variant := lRecMRHeader;
                end;
            DATABASE::"RFQ Header":
                begin
                    RecRef.SetTable(lRecRFQHeader);
                    lRecRFQHeader.Validate("Status", lRecRFQHeader."Status"::Released);
                    lRecRFQHeader.Modify(TRUE);
                    Variant := lRecRFQHeader;
                end;
        // DATABASE::"MR Consignment Header":
        //     begin
        //         RecRef.SetTable(lRecMRCons);
        //         lRecMRCons.Validate("Status", lRecMRCons."Status"::Released);
        //         lRecMRCons.Modify(TRUE);
        //         Variant := lRecMRCons;
        //     end;
        // DATABASE::"PR Consignment Header":
        //     begin
        //         RecRef.SetTable(lRecPRCons);
        //         lRecPRCons.Validate("Status", lRecPRCons."Status"::Released);
        //         lRecPRCons.Modify(TRUE);
        //         Variant := lRecPRCons;
        //     end;
        end;
    end;

    procedure ReOpenCode_PRMaterial(): Code[128]
    begin
        exit(UpperCase('Reopen_PRMaterial'));
    end;

    procedure ReOpenCode_PRAsset(): Code[128]
    begin
        exit(UpperCase('Reopen_PRAsset'));
    end;

    procedure ReOpenCode_MR(): Code[128]
    begin
        exit(UpperCase('Reopen_MR'));
    end;

    procedure ReOpenCode_RFQ(): Code[128]
    begin
        exit(UpperCase('Reopen_RFQ'));
    end;

    procedure ReOpenCode_MRCons(): Code[128]
    begin
        exit(UpperCase('Reopen_MRCons'));
    end;

    procedure ReOpenCode_PRCons(): Code[128]
    begin
        exit(UpperCase('Reopen_PRCons'));
    end;

    procedure ReOpen_Custom(var Variant: Variant)
    var
        RecRef: RecordRef;
        TargetRecRef: RecordRef;
        ApprovalEntry: Record "Approval Entry";
        lRecPRMatHeader: Record "PR Material Header";
        //lRecPRAssHeader: Record "PR Asset Header";
        //lRecMRCons: Record "MR Consignment Header";
        //lRecPRCons: Record "PR Consignment Header";
        lRecMRHeader: Record "Material Req. Header";
        lRecRFQHeader: Record "RFQ Header";
    begin
        RecRef.GetTable(Variant);
        case RecRef.Number() of
            DATABASE::"Approval Entry":
                begin
                    ApprovalEntry := Variant;
                    TargetRecRef.Get(ApprovalEntry."Record ID to Approve");
                    Variant := TargetRecRef;
                    ReOpen_Custom(Variant);
                end;
            DATABASE::"PR Material Header":
                begin
                    RecRef.SetTable(lRecPRMatHeader);
                    lRecPRMatHeader.Validate("Status", lRecPRMatHeader."Status"::Open);
                    lRecPRMatHeader.Modify(TRUE);
                    Variant := lRecPRMatHeader;
                end;
            // DATABASE::"PR Asset Header":
            //     begin
            //         RecRef.SetTable(lRecPRAssHeader);
            //         lRecPRAssHeader.Validate("Status", lRecPRAssHeader."Status"::Open);
            //         lRecPRAssHeader.Modify(TRUE);
            //         Variant := lRecPRAssHeader;
            //     end;
            DATABASE::"Material Req. Header":
                begin
                    RecRef.SetTable(lRecMRHeader);
                    lRecMRHeader.Validate("Status", lRecMRHeader."Status"::Open);
                    lRecMRHeader.Modify(TRUE);
                    Variant := lRecMRHeader;
                end;
            DATABASE::"RFQ Header":
                begin
                    RecRef.SetTable(lRecRFQHeader);
                    lRecRFQHeader.Validate("Status", lRecRFQHeader."Status"::Open);
                    lRecRFQHeader.Modify(TRUE);
                    Variant := lRecRFQHeader;
                end;
        // DATABASE::"MR Consignment Header":
        //     begin
        //         RecRef.SetTable(lRecMRCons);
        //         lRecMRCons.Validate("Status", lRecMRCons."Status"::Open);
        //         lRecMRCons.Modify(TRUE);
        //         Variant := lRecMRCons;
        //     end;
        // DATABASE::"PR Consignment Header":
        //     begin
        //         RecRef.SetTable(lRecPRCons);
        //         lRecPRCons.Validate("Status", lRecPRCons."Status"::Open);
        //         lRecPRCons.Modify(TRUE);
        //         Variant := lRecPRCons;
        //     end;
        end;
    end;
    //Response procedure custom not mandatory
    //Response Execute custom not mandatory
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnExecuteWorkflowResponse', '', false, false)]
    procedure ExeRespFor_Custom(var ResponseExecuted: Boolean; Variant: Variant; xVariant: Variant; ResponseWorkflowStepInstance: Record "Workflow Step Instance")
    var
        WorkflowResponse: Record "Workflow Response";
    begin
        IF WorkflowResponse.GET(ResponseWorkflowStepInstance."Function Name") THEN
            case WorkflowResponse."Function Name" of // SetStatusToPendingApprovalCode_Custom():
                                                     //     begin
                                                     //         SetStatusToPendingApproval_Custom(Variant);
                                                     //         ResponseExecuted := true;
                                                     //     end;
                SetStatusToPendingApprovalCode_PRMaterial():
                    begin
                        SetStatusToPendingApproval_Custom(Variant);
                        ResponseExecuted := true;
                    end;
                SetStatusToPendingApprovalCode_PRAsset():
                    begin
                        SetStatusToPendingApproval_Custom(Variant);
                        ResponseExecuted := true;
                    end;
                SetStatusToPendingApprovalCode_MR():
                    begin
                        SetStatusToPendingApproval_Custom(Variant);
                        ResponseExecuted := true;
                    end;
                SetStatusToPendingApprovalCode_RFQ():
                    begin
                        SetStatusToPendingApproval_Custom(Variant);
                        ResponseExecuted := true;
                    end;
                SetStatusToPendingApprovalCode_MRCons():
                    begin
                        SetStatusToPendingApproval_Custom(Variant);
                        ResponseExecuted := true;
                    end;
                SetStatusToPendingApprovalCode_PRCons():
                    begin
                        SetStatusToPendingApproval_Custom(Variant);
                        ResponseExecuted := true;
                    end;
                // CancelApprovalCode_Custom():
                //     begin
                //         CancelApproval_Custom(Variant);
                //         ResponseExecuted := true;
                //     end;
                CancelApprovalCode_PRMaterial():
                    begin
                        CancelApproval_Custom(Variant);
                        ResponseExecuted := true;
                    end;
                CancelApprovalCode_PRAsset():
                    begin
                        CancelApproval_Custom(Variant);
                        ResponseExecuted := true;
                    end;
                CancelApprovalCode_MR():
                    begin
                        CancelApproval_Custom(Variant);
                        ResponseExecuted := true;
                    end;
                CancelApprovalCode_RFQ():
                    begin
                        CancelApproval_Custom(Variant);
                        ResponseExecuted := true;
                    end;
                CancelApprovalCode_MRCons():
                    begin
                        CancelApproval_Custom(Variant);
                        ResponseExecuted := true;
                    end;
                CancelApprovalCode_PRCons():
                    begin
                        CancelApproval_Custom(Variant);
                        ResponseExecuted := true;
                    end;
                // ReleaseCode_Custom():
                //     begin
                //         Release_Custom(Variant);
                //         ResponseExecuted := true;
                //     end;
                ReleaseCode_PRMaterial():
                    begin
                        Release_Custom(Variant);
                        ResponseExecuted := true;
                    end;
                ReleaseCode_PRAsset():
                    begin
                        Release_Custom(Variant);
                        ResponseExecuted := true;
                    end;
                ReleaseCode_MR():
                    begin
                        Release_Custom(Variant);
                        ResponseExecuted := true;
                    end;
                ReleaseCode_RFQ():
                    begin
                        Release_Custom(Variant);
                        ResponseExecuted := true;
                    end;
                ReleaseCode_MRCons():
                    begin
                        Release_Custom(Variant);
                        ResponseExecuted := true;
                    end;
                ReleaseCode_PRCons():
                    begin
                        Release_Custom(Variant);
                        ResponseExecuted := true;
                    end;
                // ReOpenCode_Custom():
                //     begin
                //         ReOpen_Custom(Variant);
                //         ResponseExecuted := true;
                //     end;
                ReOpenCode_PRMaterial():
                    begin
                        ReOpen_Custom(Variant);
                        ResponseExecuted := true;
                    end;
                ReOpenCode_PRAsset():
                    begin
                        ReOpen_Custom(Variant);
                        ResponseExecuted := true;
                    end;
                ReOpenCode_MR():
                    begin
                        ReOpen_Custom(Variant);
                        ResponseExecuted := true;
                    end;
                ReOpenCode_RFQ():
                    begin
                        ReOpen_Custom(Variant);
                        ResponseExecuted := true;
                    end;
                ReOpenCode_MRCons():
                    begin
                        ReOpen_Custom(Variant);
                        ResponseExecuted := true;
                    end;
                ReOpenCode_PRCons():
                    begin
                        ReOpen_Custom(Variant);
                        ResponseExecuted := true;
                    end;
            end;
    end;
    //Response execute custom not mandatory
    //workflow event handling mandatory

    //off sementara 7 april 2025
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventsToLibrary', '', false, false)]
    procedure AddEventToLibrary_Custom()
    var
        SendApprovalTxt_PRMaterial: TextConst ENU = 'Approval Request for Purchase Request Material is requested', ENG = 'Approval Request for Purchase Request Material is requested';
        ApproveTxt_PRMaterial: TextConst ENU = 'Approval Request for Purchase Request Material is approved', ENG = 'Approval Request for Purchase Request Material is approved';
        RejectTxt_PRMaterial: TextConst ENU = 'Approval Request for Purchase Request Material is rejected', ENG = 'Approval Request for Purchase Request Material is rejected';
        DelegateTxt_PRMaterial: TextConst ENU = 'Approval Request for Purchase Request Material is delegated', ENG = 'Approval Request for Purchase Request Material is delegated';
        CancelTxt_PRMaterial: TextConst ENU = 'Approval Request for Purchase Request Material is canceled', ENG = 'Approval Request for Purchase Request Material is canceled';
        SendApprovalTxt_PRAsset: TextConst ENU = 'Approval Request for Purchase Request Asset is requested', ENG = 'Approval Request for Purchase Request Asset is requested';
        ApproveTxt_PRAsset: TextConst ENU = 'Approval Request for Purchase Request Asset is approved', ENG = 'Approval Request for Purchase Request Asset is approved';
        RejectTxt_PRAsset: TextConst ENU = 'Approval Request for Purchase Request Asset is rejected', ENG = 'Approval Request for Purchase Request Asset is rejected';
        DelegateTxt_PRAsset: TextConst ENU = 'Approval Request for Purchase Request Asset is delegated', ENG = 'Approval Request for Purchase Request Asset is delegated';
        CancelTxt_PRAsset: TextConst ENU = 'Approval Request for Purchase Request Asset is canceled', ENG = 'Approval Request for Purchase Request Asset is canceled';
        SendApprovalTxt_MR: TextConst ENU = 'Approval Request for Material Request is requested', ENG = 'Approval Request for Material Request is requested';
        ApproveTxt_MR: TextConst ENU = 'Approval Request for Material Request is approved', ENG = 'Approval Request for Material Request is approved';
        RejectTxt_MR: TextConst ENU = 'Approval Request for Material Request is rejected', ENG = 'Approval Request for Material Request  is rejected';
        DelegateTxt_MR: TextConst ENU = 'Approval Request for Material Request is delegated', ENG = 'Approval Request for Material Request is delegated';
        CancelTxt_MR: TextConst ENU = 'Approval Request for Material Request is canceled', ENG = 'Approval Request for Material Request is canceled';
        SendApprovalTxt_RFQ: TextConst ENU = 'Approval Request for RFQ is requested', ENG = 'Approval Request for RFQ is requested';
        ApproveTxt_RFQ: TextConst ENU = 'Approval Request for RFQ is approved', ENG = 'Approval Request for RFQ is approved';
        RejectTxt_RFQ: TextConst ENU = 'Approval Request for RFQ is rejected', ENG = 'Approval Request for RFQ  is rejected';
        DelegateTxt_RFQ: TextConst ENU = 'Approval Request for RFQ is delegated', ENG = 'Approval Request for RFQ is delegated';
        CancelTxt_RFQ: TextConst ENU = 'Approval Request for RFQ is canceled', ENG = 'Approval Request for RFQ is canceled';
        SendApprovalTxt_MRCons: TextConst ENU = 'Approval Request for Material Request Consignment is requested', ENG = 'Approval Request for Material Request Consignment is requested';
        ApproveTxt_MRCons: TextConst ENU = 'Approval Request for Material Request Consignment is approved', ENG = 'Approval Request for Material Request Consignment is approved';
        RejectTxt_MRCons: TextConst ENU = 'Approval Request for Material Request Consignment is rejected', ENG = 'Approval Request for Material Request Consignment is rejected';
        DelegateTxt_MRCons: TextConst ENU = 'Approval Request for Material Request Consignment is delegated', ENG = 'Approval Request for Material Request Consignment is delegated';
        CancelTxt_MRCons: TextConst ENU = 'Approval Request for Material Request Consignment is canceled', ENG = 'Approval Request for Material Request Consignment is canceled';
        SendApprovalTxt_PRCons: TextConst ENU = 'Approval Request for Purchase Request Consignment is requested', ENG = 'Approval Request for Purchase Request Consignment is requested';
        ApproveTxt_PRCons: TextConst ENU = 'Approval Request for Purchase Request Consignment is approved', ENG = 'Approval Request for Purchase Request Consignment is approved';
        RejectTxt_PRCons: TextConst ENU = 'Approval Request for Purchase Request Consignment is rejected', ENG = 'Approval Request for Purchase Request Consignment is rejected';
        DelegateTxt_PRCons: TextConst ENU = 'Approval Request for Purchase Request Consignment is delegated', ENG = 'Approval Request for Purchase Request Consignment is delegated';
        CancelTxt_PRCons: TextConst ENU = 'Approval Request for Purchase Request Consignment is canceled', ENG = 'Approval Request for Purchase Request Consignment is canceled';
    begin
        //PR Material
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSendApprovalCode_PRMaterial(), Database::"PR Material Header", SendApprovalTxt_PRMaterial, 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCancelApprovalCode_PRMaterial(), Database::"PR Material Header", CancelTxt_PRMaterial, 0, false);
        //PR Asset
        //WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSendApprovalCode_PRAsset(), Database::"PR Asset Header", SendApprovalTxt_PRAsset, 0, false);
        //WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCancelApprovalCode_PRAsset(), Database::"PR Asset Header", CancelTxt_PRAsset, 0, false);
        //MR
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSendApprovalCode_MR(), Database::"Material Req. Header", SendApprovalTxt_MR, 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCancelApprovalCode_MR(), Database::"Material Req. Header", CancelTxt_MR, 0, false);
        //RFQ
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSendApprovalCode_RFQ(), Database::"RFQ Header", SendApprovalTxt_RFQ, 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCancelApprovalCode_RFQ(), Database::"RFQ Header", CancelTxt_RFQ, 0, false);
        //MR Consignment
        //WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSendApprovalCode_MRCons(), Database::"MR Consignment Header", SendApprovalTxt_MRCons, 0, false);
        //WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCancelApprovalCode_MRCons(), Database::"MR Consignment Header", CancelTxt_MRCons, 0, false);
        //PR Consignment
        //WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSendApprovalCode_PRCons(), Database::"PR Consignment Header", SendApprovalTxt_PRCons, 0, false);
        //WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCancelApprovalCode_PRCons(), Database::"PR Consignment Header", CancelTxt_PRCons, 0, false);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventPredecessorsToLibrary', '', false, false)]
    procedure AddEventPredecessorToLibrary_Custom(EventFunctionName: Code[128])
    begin
        CASE EventFunctionName of
            RunWorkflowOnCancelApprovalCode_PRMaterial():
                WorkflowEventHandling.AddEventPredecessor(RunWorkflowOnCancelApprovalCode_PRMaterial, RunWorkflowOnSendApprovalCode_PRMaterial);
            RunWorkflowOnCancelApprovalCode_PRAsset():
                WorkflowEventHandling.AddEventPredecessor(RunWorkflowOnCancelApprovalCode_PRAsset, RunWorkflowOnSendApprovalCode_PRAsset);
            RunWorkflowOnCancelApprovalCode_MR():
                WorkflowEventHandling.AddEventPredecessor(RunWorkflowOnCancelApprovalCode_MR, RunWorkflowOnSendApprovalCode_MR);
            RunWorkflowOnCancelApprovalCode_RFQ():
                WorkflowEventHandling.AddEventPredecessor(RunWorkflowOnCancelApprovalCode_RFQ, RunWorkflowOnSendApprovalCode_RFQ);
            RunWorkflowOnCancelApprovalCode_MRCons():
                WorkflowEventHandling.AddEventPredecessor(RunWorkflowOnCancelApprovalCode_MRCons, RunWorkflowOnSendApprovalCode_MRCons);
            RunWorkflowOnCancelApprovalCode_PRCons():
                WorkflowEventHandling.AddEventPredecessor(RunWorkflowOnCancelApprovalCode_PRCons, RunWorkflowOnSendApprovalCode_PRCons);
            WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode():
                BEGIN
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendApprovalCode_PRMaterial);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendApprovalCode_PRAsset);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendApprovalCode_MR);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendApprovalCode_RFQ);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendApprovalCode_MRCons);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendApprovalCode_PRCons);
                END;
            WorkflowEventHandling.RunWorkflowOnRejectApprovalRequestCode():
                BEGIN
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnRejectApprovalRequestCode, RunWorkflowOnSendApprovalCode_PRMaterial());
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnRejectApprovalRequestCode, RunWorkflowOnSendApprovalCode_PRAsset());
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnRejectApprovalRequestCode, RunWorkflowOnSendApprovalCode_MR());
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnRejectApprovalRequestCode, RunWorkflowOnSendApprovalCode_RFQ());
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnRejectApprovalRequestCode, RunWorkflowOnSendApprovalCode_MRCons());
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnRejectApprovalRequestCode, RunWorkflowOnSendApprovalCode_PRCons());
                END;
            WorkflowEventHandling.RunWorkflowOnDelegateApprovalRequestCode():
                BEGIN
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnDelegateApprovalRequestCode, RunWorkflowOnSendApprovalCode_PRMaterial());
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnDelegateApprovalRequestCode, RunWorkflowOnSendApprovalCode_PRAsset());
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnDelegateApprovalRequestCode, RunWorkflowOnSendApprovalCode_MR());
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnDelegateApprovalRequestCode, RunWorkflowOnSendApprovalCode_RFQ());
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnDelegateApprovalRequestCode, RunWorkflowOnSendApprovalCode_MRCons());
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnDelegateApprovalRequestCode, RunWorkflowOnSendApprovalCode_PRCons());
                END;
        END;
    end;
    //workflow event handling mandatory
    //workflow response handling mandatory

    //off sementara 7 april 2025
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnAddWorkflowResponsesToLibrary', '', false, false)]
    procedure AddRespToLibrary_Custom()
    var
        ChgPendAppTxt_Custom: TextConst ENU = 'Status of Custom Module changed to Pending approval', ENG = 'Status of Custom Module changed to Pending approval';
        ReleaseTxt_Custom: TextConst ENU = 'Release Custom Module', ENG = 'Release Custom Module';
        ReopenTxt_Custom: TextConst ENU = 'Reopen Custom Module', ENG = 'Reopen Custom Module';
        CancelAppTxt_Custom: TextConst ENU = 'Cancel approval entry of Custom Module', ENG = 'Cancel approval entry of Custom Module';
        ChgPendAppTxt_PRMaterial: TextConst ENU = 'Status of Purchase Request Material changed to Pending approval', ENG = 'Status of Purchase Request Material changed to Pending approval';
        ReleaseTxt_PRMaterial: TextConst ENU = 'Release Purchase Request Material', ENG = 'Release Purchase Request Material';
        ReopenTxt_PRMaterial: TextConst ENU = 'Reopen Purchase Request Material', ENG = 'Reopen Purchase Request Material';
        CancelAppTxt_PRMaterial: TextConst ENU = 'Cancel approval entry of Purchase Request Material', ENG = 'Cancel approval entry of Purchase Request Material';
        ChgPendAppTxt_PRAsset: TextConst ENU = 'Status of Purchase Request Asset changed to Pending approval', ENG = 'Status of Purchase Request Asset changed to Pending approval';
        ReleaseTxt_PRAsset: TextConst ENU = 'Release Purchase Request Asset', ENG = 'Release Purchase Request Asset';
        ReopenTxt_PRAsset: TextConst ENU = 'Reopen Purchase Request Asset', ENG = 'Reopen Purchase Request Asset';
        CancelAppTxt_PRAsset: TextConst ENU = 'Cancel approval entry of Purchase Request Asset', ENG = 'Cancel approval entry of Purchase Request Asset';
        ChgPendAppTxt_MR: TextConst ENU = 'Status of Material Request changed to Pending approval', ENG = 'Status of Material Request changed to Pending approval';
        ReleaseTxt_MR: TextConst ENU = 'Release Material Request', ENG = 'Release Material Request';
        ReopenTxt_MR: TextConst ENU = 'Reopen Material Request', ENG = 'Reopen Material Request';
        CancelAppTxt_MR: TextConst ENU = 'Cancel approval entry of Material Request', ENG = 'Cancel approval entry of Material Request';
        ChgPendAppTxt_RFQ: TextConst ENU = 'Status of RFQ changed to Pending approval', ENG = 'Status of RFQ changed to Pending approval';
        ReleaseTxt_RFQ: TextConst ENU = 'Release RFQ', ENG = 'Release RFQ';
        ReopenTxt_RFQ: TextConst ENU = 'Reopen RFQ', ENG = 'Reopen RFQ';
        CancelAppTxt_RFQ: TextConst ENU = 'Cancel approval entry of RFQ', ENG = 'Cancel approval entry of RFQ';
        ChgPendAppTxt_MRCons: TextConst ENU = 'Status of Material Request Consignment changed to Pending approval', ENG = 'Status of Material Request Consignment changed to Pending approval';
        ReleaseTxt_MRCons: TextConst ENU = 'Release Material Request Consignment', ENG = 'Release Material Request Consignment';
        ReopenTxt_MRCons: TextConst ENU = 'Reopen Material Request Consignment', ENG = 'Reopen Material Request Consignment';
        CancelAppTxt_MRCons: TextConst ENU = 'Cancel approval entry of Material Request Consignment', ENG = 'Cancel approval entry of Material Request Consignment';
        ChgPendAppTxt_PRCons: TextConst ENU = 'Status of Purchase Request Consignment changed to Pending approval', ENG = 'Status of Purchase Request Consignment changed to Pending approval';
        ReleaseTxt_PRCons: TextConst ENU = 'Release Purchase Request Consignment', ENG = 'Release Purchase Request Consignment';
        ReopenTxt_PRCons: TextConst ENU = 'Reopen Purchase Request Consignment', ENG = 'Reopen Purchase Request Consignment';
        CancelAppTxt_PRCons: TextConst ENU = 'Cancel approval entry of Purchase Request Consignment', ENG = 'Cancel approval entry of Purchase Request Consignment';
    begin
        //Custom
        // WorkflowResponseHandling.AddResponseToLibrary(SetStatusToPendingApprovalCode_Custom(), 0, ChgPendAppTxt_Custom, 'GROUP 2');
        // WorkflowResponseHandling.AddResponseToLibrary(ReleaseCode_Custom(), 0, ReleaseTxt_Custom, 'GROUP 2');
        // WorkflowResponseHandling.AddResponseToLibrary(ReOpenCode_Custom(), 0, ReopenTxt_Custom, 'GROUP 2');
        // WorkflowResponseHandling.AddResponseToLibrary(CancelApprovalCode_Custom(), 0, CancelAppTxt_Custom, 'GROUP 2');
        //PR Material
        WorkflowResponseHandling.AddResponseToLibrary(SetStatusToPendingApprovalCode_PRMaterial(), 0, ChgPendAppTxt_PRMaterial, 'GROUP 2');
        WorkflowResponseHandling.AddResponseToLibrary(ReleaseCode_PRMaterial(), 0, ReleaseTxt_PRMaterial, 'GROUP 2');
        WorkflowResponseHandling.AddResponseToLibrary(ReOpenCode_PRMaterial(), 0, ReopenTxt_PRMaterial, 'GROUP 2');
        WorkflowResponseHandling.AddResponseToLibrary(CancelApprovalCode_PRMaterial(), 0, CancelAppTxt_PRMaterial, 'GROUP 2');
        //PR Asset
        WorkflowResponseHandling.AddResponseToLibrary(SetStatusToPendingApprovalCode_PRAsset(), 0, ChgPendAppTxt_PRAsset, 'GROUP 2');
        WorkflowResponseHandling.AddResponseToLibrary(ReleaseCode_PRAsset(), 0, ReleaseTxt_PRAsset, 'GROUP 2');
        WorkflowResponseHandling.AddResponseToLibrary(ReOpenCode_PRAsset(), 0, ReopenTxt_PRAsset, 'GROUP 2');
        WorkflowResponseHandling.AddResponseToLibrary(CancelApprovalCode_PRAsset(), 0, CancelAppTxt_PRAsset, 'GROUP 2');
        //MR
        WorkflowResponseHandling.AddResponseToLibrary(SetStatusToPendingApprovalCode_MR(), 0, ChgPendAppTxt_MR, 'GROUP 2');
        WorkflowResponseHandling.AddResponseToLibrary(ReleaseCode_MR(), 0, ReleaseTxt_MR, 'GROUP 2');
        WorkflowResponseHandling.AddResponseToLibrary(ReOpenCode_MR(), 0, ReopenTxt_MR, 'GROUP 2');
        WorkflowResponseHandling.AddResponseToLibrary(CancelApprovalCode_MR(), 0, CancelAppTxt_MR, 'GROUP 2');
        //RFQ
        WorkflowResponseHandling.AddResponseToLibrary(SetStatusToPendingApprovalCode_RFQ(), 0, ChgPendAppTxt_RFQ, 'GROUP 2');
        WorkflowResponseHandling.AddResponseToLibrary(ReleaseCode_RFQ(), 0, ReleaseTxt_RFQ, 'GROUP 2');
        WorkflowResponseHandling.AddResponseToLibrary(ReOpenCode_RFQ(), 0, ReopenTxt_RFQ, 'GROUP 2');
        WorkflowResponseHandling.AddResponseToLibrary(CancelApprovalCode_RFQ(), 0, CancelAppTxt_RFQ, 'GROUP 2');
        //MR Consignment
        WorkflowResponseHandling.AddResponseToLibrary(SetStatusToPendingApprovalCode_MRCons(), 0, ChgPendAppTxt_MRCons, 'GROUP 2');
        WorkflowResponseHandling.AddResponseToLibrary(ReleaseCode_MRCons(), 0, ReleaseTxt_MRCons, 'GROUP 2');
        WorkflowResponseHandling.AddResponseToLibrary(ReOpenCode_MRCons(), 0, ReopenTxt_MRCons, 'GROUP 2');
        WorkflowResponseHandling.AddResponseToLibrary(CancelApprovalCode_MRCons(), 0, CancelAppTxt_MRCons, 'GROUP 2');
        //PR Consignment
        WorkflowResponseHandling.AddResponseToLibrary(SetStatusToPendingApprovalCode_PRCons(), 0, ChgPendAppTxt_PRCons, 'GROUP 2');
        WorkflowResponseHandling.AddResponseToLibrary(ReleaseCode_PRCons(), 0, ReleaseTxt_PRCons, 'GROUP 2');
        WorkflowResponseHandling.AddResponseToLibrary(ReOpenCode_PRCons(), 0, ReopenTxt_PRCons, 'GROUP 2');
        WorkflowResponseHandling.AddResponseToLibrary(CancelApprovalCode_PRCons(), 0, CancelAppTxt_PRCons, 'GROUP 2');
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnAddWorkflowResponsePredecessorsToLibrary', '', false, false)]
    local procedure OnAddWorkflowResponsePredecessorsToLibrary(ResponseFunctionName: Code[128])
    var
        WorkflowResponseHandling: Codeunit "Workflow Response Handling";
    begin
        Case ResponseFunctionName of
            WorkflowResponseHandling.SetStatusToPendingApprovalCode():
                BEGIN
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SetStatusToPendingApprovalCode(), RunWorkflowOnSendApprovalCode_PRMaterial());
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SetStatusToPendingApprovalCode(), RunWorkflowOnSendApprovalCode_PRAsset());
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SetStatusToPendingApprovalCode(), RunWorkflowOnSendApprovalCode_MR());
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SetStatusToPendingApprovalCode(), RunWorkflowOnSendApprovalCode_RFQ());
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SetStatusToPendingApprovalCode(), RunWorkflowOnSendApprovalCode_MRCons());
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SetStatusToPendingApprovalCode(), RunWorkflowOnSendApprovalCode_PRCons());
                END;
            WorkflowResponseHandling.SendApprovalRequestForApprovalCode():
                BEGIN
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SendApprovalRequestForApprovalCode(), RunWorkflowOnSendApprovalCode_PRMaterial());
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SendApprovalRequestForApprovalCode(), RunWorkflowOnSendApprovalCode_PRAsset());
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SendApprovalRequestForApprovalCode(), RunWorkflowOnSendApprovalCode_MR());
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SendApprovalRequestForApprovalCode(), RunWorkflowOnSendApprovalCode_RFQ());
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SendApprovalRequestForApprovalCode(), RunWorkflowOnSendApprovalCode_MRCons());
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SendApprovalRequestForApprovalCode(), RunWorkflowOnSendApprovalCode_PRCons())
                END;
            WorkflowResponseHandling.CreateApprovalRequestsCode():
                BEGIN
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CreateApprovalRequestsCode(), RunWorkflowOnSendApprovalCode_PRMaterial());
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CreateApprovalRequestsCode(), RunWorkflowOnSendApprovalCode_PRAsset());
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CreateApprovalRequestsCode(), RunWorkflowOnSendApprovalCode_MR());
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CreateApprovalRequestsCode(), RunWorkflowOnSendApprovalCode_RFQ());
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CreateApprovalRequestsCode(), RunWorkflowOnSendApprovalCode_MRCons());
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CreateApprovalRequestsCode(), RunWorkflowOnSendApprovalCode_PRCons());
                END;
            WorkflowResponseHandling.ReleaseDocumentCode():
                BEGIN
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.ReleaseDocumentCode(), RunWorkflowOnSendApprovalCode_PRMaterial());
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.ReleaseDocumentCode(), RunWorkflowOnSendApprovalCode_PRAsset());
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.ReleaseDocumentCode(), RunWorkflowOnSendApprovalCode_MR());
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.ReleaseDocumentCode(), RunWorkflowOnSendApprovalCode_RFQ());
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.ReleaseDocumentCode(), RunWorkflowOnSendApprovalCode_MRCons());
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.ReleaseDocumentCode(), RunWorkflowOnSendApprovalCode_PRCons());
                END;
            WorkflowResponseHandling.CancelAllApprovalRequestsCode():
                BEGIN
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CancelAllApprovalRequestsCode(), RunWorkflowOnCancelApprovalCode_PRMaterial());
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CancelAllApprovalRequestsCode(), RunWorkflowOnCancelApprovalCode_PRAsset());
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CancelAllApprovalRequestsCode(), RunWorkflowOnCancelApprovalCode_MR());
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CancelAllApprovalRequestsCode(), RunWorkflowOnCancelApprovalCode_RFQ());
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CancelAllApprovalRequestsCode(), RunWorkflowOnCancelApprovalCode_MRCons());
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CancelAllApprovalRequestsCode(), RunWorkflowOnCancelApprovalCode_PRCons());
                END;
            WorkflowResponseHandling.OpenDocumentCode():
                BEGIN
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.OpenDocumentCode(), RunWorkflowOnCancelApprovalCode_PRMaterial());
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.OpenDocumentCode(), RunWorkflowOnCancelApprovalCode_PRAsset());
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.OpenDocumentCode(), RunWorkflowOnCancelApprovalCode_MR());
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.OpenDocumentCode(), RunWorkflowOnCancelApprovalCode_RFQ());
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.OpenDocumentCode(), RunWorkflowOnCancelApprovalCode_MRCons());
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.OpenDocumentCode(), RunWorkflowOnCancelApprovalCode_PRCons());
                END;
            SetStatusToPendingApprovalCode_PRMaterial():
                WorkflowResponseHandling.AddResponsePredecessor(SetStatusToPendingApprovalCode_PRMaterial(), RunWorkflowOnSendApprovalCode_PRMaterial());
            CancelApprovalCode_PRMaterial():
                WorkflowResponseHandling.AddResponsePredecessor(CancelApprovalCode_PRMaterial(), RunWorkflowOnCancelApprovalCode_PRMaterial());
            ReOpenCode_PRMaterial():
                BEGIN
                    WorkflowResponseHandling.AddResponsePredecessor(ReOpenCode_PRMaterial(), RunWorkflowOnSendApprovalCode_PRMaterial());
                    WorkflowResponseHandling.AddResponsePredecessor(ReOpenCode_PRMaterial(), RunWorkflowOnCancelApprovalCode_PRMaterial());
                END;
            ReleaseCode_PRMaterial():
                BEGIN
                    WorkflowResponseHandling.AddResponsePredecessor(ReleaseCode_PRMaterial(), RunWorkflowOnSendApprovalCode_PRMaterial());
                    WorkflowResponseHandling.AddResponsePredecessor(ReleaseCode_PRMaterial(), RunWorkflowOnCancelApprovalCode_PRMaterial());
                END;
            SetStatusToPendingApprovalCode_PRAsset():
                WorkflowResponseHandling.AddResponsePredecessor(SetStatusToPendingApprovalCode_PRAsset(), RunWorkflowOnSendApprovalCode_PRAsset());
            CancelApprovalCode_PRAsset():
                WorkflowResponseHandling.AddResponsePredecessor(CancelApprovalCode_PRAsset(), RunWorkflowOnCancelApprovalCode_PRAsset());
            ReOpenCode_PRAsset():
                BEGIN
                    WorkflowResponseHandling.AddResponsePredecessor(ReOpenCode_PRAsset(), RunWorkflowOnSendApprovalCode_PRAsset());
                    WorkflowResponseHandling.AddResponsePredecessor(ReOpenCode_PRAsset(), RunWorkflowOnCancelApprovalCode_PRAsset());
                END;
            ReleaseCode_PRAsset():
                BEGIN
                    WorkflowResponseHandling.AddResponsePredecessor(ReleaseCode_PRAsset(), RunWorkflowOnSendApprovalCode_PRAsset());
                    WorkflowResponseHandling.AddResponsePredecessor(ReleaseCode_PRAsset(), RunWorkflowOnCancelApprovalCode_PRAsset());
                END;
            SetStatusToPendingApprovalCode_MR():
                WorkflowResponseHandling.AddResponsePredecessor(SetStatusToPendingApprovalCode_MR(), RunWorkflowOnSendApprovalCode_MR());
            CancelApprovalCode_MR():
                WorkflowResponseHandling.AddResponsePredecessor(CancelApprovalCode_MR(), RunWorkflowOnCancelApprovalCode_MR());
            ReOpenCode_MR():
                BEGIN
                    WorkflowResponseHandling.AddResponsePredecessor(ReOpenCode_MR(), RunWorkflowOnSendApprovalCode_MR());
                    WorkflowResponseHandling.AddResponsePredecessor(ReOpenCode_MR(), RunWorkflowOnCancelApprovalCode_MR());
                END;
            ReleaseCode_MR():
                BEGIN
                    WorkflowResponseHandling.AddResponsePredecessor(ReleaseCode_MR(), RunWorkflowOnSendApprovalCode_MR());
                    WorkflowResponseHandling.AddResponsePredecessor(ReleaseCode_MR(), RunWorkflowOnCancelApprovalCode_MR());
                END;
            SetStatusToPendingApprovalCode_RFQ():
                WorkflowResponseHandling.AddResponsePredecessor(SetStatusToPendingApprovalCode_RFQ(), RunWorkflowOnSendApprovalCode_RFQ());
            CancelApprovalCode_RFQ():
                WorkflowResponseHandling.AddResponsePredecessor(CancelApprovalCode_RFQ(), RunWorkflowOnCancelApprovalCode_RFQ());
            ReOpenCode_RFQ():
                BEGIN
                    WorkflowResponseHandling.AddResponsePredecessor(ReOpenCode_RFQ(), RunWorkflowOnSendApprovalCode_RFQ());
                    WorkflowResponseHandling.AddResponsePredecessor(ReOpenCode_RFQ(), RunWorkflowOnCancelApprovalCode_RFQ());
                END;
            ReleaseCode_RFQ():
                BEGIN
                    WorkflowResponseHandling.AddResponsePredecessor(ReleaseCode_RFQ(), RunWorkflowOnSendApprovalCode_RFQ());
                    WorkflowResponseHandling.AddResponsePredecessor(ReleaseCode_RFQ(), RunWorkflowOnCancelApprovalCode_RFQ());
                END;
            SetStatusToPendingApprovalCode_MRCons():
                WorkflowResponseHandling.AddResponsePredecessor(SetStatusToPendingApprovalCode_MRCons(), RunWorkflowOnSendApprovalCode_MRCons());
            CancelApprovalCode_MRCons():
                WorkflowResponseHandling.AddResponsePredecessor(CancelApprovalCode_MRCons(), RunWorkflowOnCancelApprovalCode_MRCons());
            ReOpenCode_MRCons():
                BEGIN
                    WorkflowResponseHandling.AddResponsePredecessor(ReOpenCode_MRCons(), RunWorkflowOnSendApprovalCode_MRCons());
                    WorkflowResponseHandling.AddResponsePredecessor(ReOpenCode_MRCons(), RunWorkflowOnCancelApprovalCode_MRCons());
                END;
            ReleaseCode_MRCons():
                BEGIN
                    WorkflowResponseHandling.AddResponsePredecessor(ReleaseCode_MRCons(), RunWorkflowOnSendApprovalCode_MRCons());
                    WorkflowResponseHandling.AddResponsePredecessor(ReleaseCode_MRCons(), RunWorkflowOnCancelApprovalCode_MRCons());
                END;
            SetStatusToPendingApprovalCode_PRCons():
                WorkflowResponseHandling.AddResponsePredecessor(SetStatusToPendingApprovalCode_PRCons(), RunWorkflowOnSendApprovalCode_PRCons());
            CancelApprovalCode_PRCons():
                WorkflowResponseHandling.AddResponsePredecessor(CancelApprovalCode_PRCons(), RunWorkflowOnCancelApprovalCode_PRCons());
            ReOpenCode_PRCons():
                BEGIN
                    WorkflowResponseHandling.AddResponsePredecessor(ReOpenCode_PRCons(), RunWorkflowOnSendApprovalCode_PRCons());
                    WorkflowResponseHandling.AddResponsePredecessor(ReOpenCode_PRCons(), RunWorkflowOnCancelApprovalCode_PRCons());
                END;
            ReleaseCode_PRCons():
                BEGIN
                    WorkflowResponseHandling.AddResponsePredecessor(ReleaseCode_PRCons(), RunWorkflowOnSendApprovalCode_PRCons());
                    WorkflowResponseHandling.AddResponsePredecessor(ReleaseCode_PRCons(), RunWorkflowOnCancelApprovalCode_PRCons());
                END;
        End
    end;
    //workflow response handling mandatory
    //approval mgt  mandatory
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnPopulateApprovalEntryArgument', '', false, false)]
    local procedure OnPopulateApprovalEntryArgument(var RecRef: RecordRef; var ApprovalEntryArgument: Record "Approval Entry"; WorkflowStepInstance: Record "Workflow Step Instance")
    var
        lRecPRMatHeader: Record "PR Material Header";
        //lRecPRAssHeader: Record "PR Asset Header";
        //lRecMRCons: Record "MR Consignment Header";
        //lRecPRCons: Record "PR Consignment Header";
        lRecMRHeader: Record "Material Req. Header";
        lRecRFQHeader: Record "RFQ Header";
    begin
        Case RecRef.NUMBER of
            Database::"PR Material Header":
                BEGIN
                    RecRef.SetTable(lRecPRMatHeader);
                    lRecPRMatHeader.CalcFields("Total Amount");
                    ApprovalEntryArgument."Document No." := lRecPRMatHeader."Purchase Req. No.";
                    ApprovalEntryArgument."Table ID" := Database::"PR Material Header";
                    ApprovalEntryArgument.Amount := lRecPRMatHeader."Total Amount";
                    ApprovalEntryArgument."Amount (LCY)" := lRecPRMatHeader."Total Amount";
                    // IF lRecPRHeader."Currency Code" <> 'IDR' THEN
                    //     ApprovalEntryArgument."Amount (LCY)" := lRecPRHeader.""Total Amount" * lRecPRHeader."Currency Factor"
                    // ELSE
                    //     ApprovalEntryArgument."Amount (LCY)" := lRecPRHeader."Grand Total Expected Price";
                END;
            // Database::"PR Asset Header":
            //     BEGIN
            //         RecRef.SetTable(lRecPRAssHeader);
            //         lRecPRAssHeader.CalcFields("Total Amount");
            //         ApprovalEntryArgument."Document No." := lRecPRAssHeader."Purchase Req. No.";
            //         ApprovalEntryArgument."Table ID" := Database::"PR Asset Header";
            //         ApprovalEntryArgument.Amount := lRecPRAssHeader."Total Amount";
            //         ApprovalEntryArgument."Amount (LCY)" := lRecPRAssHeader."Total Amount";
            //         // IF lRecPRHeader."Currency Code" <> 'IDR' THEN
            //         //     ApprovalEntryArgument."Amount (LCY)" := lRecPRHeader.""Total Amount" * lRecPRHeader."Currency Factor"
            //         // ELSE
            //         //     ApprovalEntryArgument."Amount (LCY)" := lRecPRHeader."Grand Total Expected Price";
            //     END;
            Database::"Material Req. Header":
                BEGIN
                    RecRef.SetTable(lRecMRHeader);
                    lRecMRHeader.CalcFields("Total Amount");
                    ApprovalEntryArgument."Document No." := lRecMRHeader."Material Req. No.";
                    ApprovalEntryArgument."Table ID" := Database::"Material Req. Header";
                    ApprovalEntryArgument.Amount := lRecMRHeader."Total Amount";
                    ApprovalEntryArgument."Amount (LCY)" := lRecMRHeader."Total Amount";
                    // IF lRecMRHeader."Currency Code" <> 'IDR' THEN
                    //     ApprovalEntryArgument."Amount (LCY)" := lRecMRHeader."Total Amount Vendor Price" * lRecMRHeader."Currency Factor"
                    // ELSE
                    //     ApprovalEntryArgument."Amount (LCY)" := lRecMRHeader."Total Amount Vendor Price";
                END;
            Database::"RFQ Header":
                BEGIN
                    RecRef.SetTable(lRecRFQHeader);
                    ApprovalEntryArgument."Document No." := lRecRFQHeader."RFQ No.";
                    ApprovalEntryArgument."Table ID" := Database::"RFQ Header";
                    // ApprovalEntryArgument.Amount := lRecRFQHeader."Total Amount";
                    // ApprovalEntryArgument."Amount (LCY)" := lRecRFQHeader."Total Amount";
                    // IF lRecRFQHeader."Currency Code" <> 'IDR' THEN
                    //     ApprovalEntryArgument."Amount (LCY)" := lRecRFQHeader."Total Incl. VAT" * lRecRFQHeader."Currency Factor"
                    // ELSE
                    //     ApprovalEntryArgument."Amount (LCY)" := lRecRFQHeader."Total Incl. VAT";
                END;
        // Database::"MR Consignment Header":
        //     BEGIN
        //         RecRef.SetTable(lRecMRCons);
        //         lRecMRCons.CalcFields("Total Amount");
        //         ApprovalEntryArgument."Document No." := lRecMRCons."Material Req. No.";
        //         ApprovalEntryArgument."Table ID" := Database::"MR Consignment Header";
        //         ApprovalEntryArgument.Amount := lRecMRCons."Total Amount";
        //         ApprovalEntryArgument."Amount (LCY)" := lRecMRCons."Total Amount";
        //         // IF lRecPRHeader."Currency Code" <> 'IDR' THEN
        //         //     ApprovalEntryArgument."Amount (LCY)" := lRecPRHeader.""Total Amount" * lRecPRHeader."Currency Factor"
        //         // ELSE
        //         //     ApprovalEntryArgument."Amount (LCY)" := lRecPRHeader."Grand Total Expected Price";
        //     END;
        // Database::"PR Consignment Header":
        //     BEGIN
        //         RecRef.SetTable(lRecPRCons);
        //         lRecPRCons.CalcFields("Total Amount");
        //         ApprovalEntryArgument."Document No." := lRecPRCons."Purchase Req. No.";
        //         ApprovalEntryArgument."Table ID" := Database::"PR Consignment Header";
        //         ApprovalEntryArgument.Amount := lRecPRCons."Total Amount";
        //         ApprovalEntryArgument."Amount (LCY)" := lRecPRCons."Total Amount";
        //         // IF lRecPRHeader."Currency Code" <> 'IDR' THEN
        //         //     ApprovalEntryArgument."Amount (LCY)" := lRecPRHeader.""Total Amount" * lRecPRHeader."Currency Factor"
        //         // ELSE
        //         //     ApprovalEntryArgument."Amount (LCY)" := lRecPRHeader."Grand Total Expected Price";
        //     END;
        End;
    end;
    //action handling
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnSetStatusToPendingApproval', '', false, false)]
    local procedure OnSetStatusToPendingApproval(RecRef: RecordRef; var Variant: Variant; var IsHandled: Boolean)
    var
        lRecPRMatHeader: Record "PR Material Header";
        //lRecPRAssHeader: Record "PR Asset Header";
        //lRecMRCons: Record "MR Consignment Header";
        //lRecPRCons: Record "PR Consignment Header";
        lRecMRHeader: Record "Material Req. Header";
        lRecRFQHeader: Record "RFQ Header";
    begin
        Case RecRef.NUMBER of
            DATABASE::"PR Material Header":
                BEGIN
                    RecRef.SetTable(lRecPRMatHeader);
                    lRecPRMatHeader.Validate("Status", lRecPRMatHeader."Status"::"Pending Approval");
                    lRecPRMatHeader.Modify(TRUE);
                    Variant := lRecPRMatHeader;
                    IsHandled := TRUE;
                END;
            // DATABASE::"PR Asset Header":
            //     BEGIN
            //         RecRef.SetTable(lRecPRAssHeader);
            //         lRecPRAssHeader.Validate("Status", lRecPRAssHeader."Status"::"Pending Approval");
            //         lRecPRAssHeader.Modify(TRUE);
            //         Variant := lRecPRAssHeader;
            //         IsHandled := TRUE;
            //     END;
            DATABASE::"Material Req. Header":
                BEGIN
                    RecRef.SetTable(lRecMRHeader);
                    lRecMRHeader.Validate("Status", lRecMRHeader."Status"::"Pending Approval");
                    lRecMRHeader.Modify(TRUE);
                    Variant := lRecMRHeader;
                    IsHandled := TRUE;
                END;
            DATABASE::"RFQ Header":
                BEGIN
                    RecRef.SetTable(lRecRFQHeader);
                    lRecRFQHeader.Validate("Status", lRecRFQHeader.Status::"Pending Approval");
                    lRecRFQHeader.Modify(TRUE);
                    Variant := lRecRFQHeader;
                    IsHandled := TRUE;
                END;
        // DATABASE::"MR Consignment Header":
        //     BEGIN
        //         RecRef.SetTable(lRecMRCons);
        //         lRecMRCons.Validate("Status", lRecMRCons."Status"::"Pending Approval");
        //         lRecMRCons.Modify(TRUE);
        //         Variant := lRecMRCons;
        //         IsHandled := TRUE;
        //     END;
        // DATABASE::"PR Consignment Header":
        //     BEGIN
        //         RecRef.SetTable(lRecPRCons);
        //         lRecPRCons.Validate("Status", lRecPRCons."Status"::"Pending Approval");
        //         lRecPRCons.Modify(TRUE);
        //         Variant := lRecPRCons;
        //         IsHandled := TRUE;
        //     END;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnApproveApprovalRequest', '', false, false)]
    local procedure OnApproveApprovalRequest(var ApprovalEntry: Record "Approval Entry")
    var
        lRecPRMatHeader: Record "PR Material Header";
        lRecPRAssHeader: Record "PR Material Header";
        //lRecMRCons: Record "MR Consignment Header";
        //lRecPRCons: Record "PR Consignment Header";
        lRecMRHeader: Record "Material Req. Header";
        lRecRFQHeader: Record "RFQ Header";
        RecRef: RecordRef;
    begin
        RecRef.GET(ApprovalEntry."Record ID to Approve");
        Case RecRef.NUMBER of
            DATABASE::"PR Material Header":
                BEGIN
                    RecRef.SetTable(lRecPRMatHeader);
                    IF not HasOpenOrPendingApprovalEntriesCustom(ApprovalEntry) THEN BEGIN
                        lRecPRMatHeader.Validate("Status", lRecPRMatHeader."Status"::Released);
                        lRecPRMatHeader.Modify();
                    END
                    ELSE BEGIN
                        updateStatusOpenNextApprovalEntryCustom(ApprovalEntry);
                    END;
                END;
            // DATABASE::"PR Asset Header":
            //     BEGIN
            //         RecRef.SetTable(lRecPRAssHeader);
            //         IF not HasOpenOrPendingApprovalEntriesCustom(ApprovalEntry) THEN BEGIN
            //             lRecPRAssHeader.Validate("Status", lRecPRAssHeader."Status"::Released);
            //             lRecPRAssHeader.Modify();
            //         END
            //         ELSE BEGIN
            //             updateStatusOpenNextApprovalEntryCustom(ApprovalEntry);
            //         END;
            //     END;
            DATABASE::"Material Req. Header":
                BEGIN
                    RecRef.SetTable(lRecMRHeader);
                    IF not HasOpenOrPendingApprovalEntriesCustom(ApprovalEntry) THEN BEGIN
                        lRecMRHeader.Validate("Status", lRecMRHeader."Status"::Released);
                        lRecMRHeader.Modify();
                    END
                    ELSE BEGIN
                        updateStatusOpenNextApprovalEntryCustom(ApprovalEntry);
                    END;
                END;
            DATABASE::"RFQ Header":
                BEGIN
                    RecRef.SetTable(lRecRFQHeader);
                    IF not HasOpenOrPendingApprovalEntriesCustom(ApprovalEntry) THEN BEGIN
                        lRecRFQHeader.Validate("Status", lRecRFQHeader."Status"::Released);
                        lRecRFQHeader.Modify();
                    END
                    ELSE BEGIN
                        updateStatusOpenNextApprovalEntryCustom(ApprovalEntry);
                    END;
                END;
        // DATABASE::"MR Consignment Header":
        //     BEGIN
        //         RecRef.SetTable(lRecMRCons);
        //         IF not HasOpenOrPendingApprovalEntriesCustom(ApprovalEntry) THEN BEGIN
        //             lRecMRCons.Validate("Status", lRecMRCons."Status"::Released);
        //             lRecMRCons.Modify();
        //         END
        //         ELSE BEGIN
        //             updateStatusOpenNextApprovalEntryCustom(ApprovalEntry);
        //         END;
        //     END;
        // DATABASE::"PR Consignment Header":
        //     BEGIN
        //         RecRef.SetTable(lRecPRCons);
        //         IF not HasOpenOrPendingApprovalEntriesCustom(ApprovalEntry) THEN BEGIN
        //             lRecPRCons.Validate("Status", lRecPRCons."Status"::Released);
        //             lRecPRCons.Modify();
        //         END
        //         ELSE BEGIN
        //             updateStatusOpenNextApprovalEntryCustom(ApprovalEntry);
        //         END;
        //     END;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnRejectApprovalRequest', '', false, false)]
    local procedure OnRejectApprovalRequest(var ApprovalEntry: Record "Approval Entry")
    var
        lRecApprovalEntry: Record "Approval Entry";
        lRecPRMatHeader: Record "PR Material Header";
        lRecPRAssHeader: Record "PR Material Header";
        //lRecMRCons: Record "MR Consignment Header";
        //lRecPRCons: Record "PR Consignment Header";
        lRecMRHeader: Record "Material Req. Header";
        lRecRFQHeader: Record "RFQ Header";
        WorkflowStepInstance: Record "Workflow Step Instance";
        RecRef: RecordRef;
    begin
        RecRef.GET(ApprovalEntry."Record ID to Approve");
        Case RecRef.NUMBER of
            DATABASE::"PR Material Header":
                BEGIN
                    RecRef.SetTable(lRecPRMatHeader);
                    lRecPRMatHeader.Validate("Status", lRecPRMatHeader."Status"::Open);
                    lRecPRMatHeader.Modify();
                    updateStatusRejectApprovalEntryCustom(ApprovalEntry);
                END;
            // DATABASE::"PR Asset Header":
            //     BEGIN
            //         RecRef.SetTable(lRecPRAssHeader);
            //         lRecPRAssHeader.Validate("Status", lRecPRAssHeader."Status"::Open);
            //         lRecPRAssHeader.Modify();
            //         updateStatusRejectApprovalEntryCustom(ApprovalEntry);
            //     END;
            DATABASE::"Material Req. Header":
                BEGIN
                    RecRef.SetTable(lRecMRHeader);
                    lRecMRHeader.Validate("Status", lRecMRHeader."Status"::Open);
                    lRecMRHeader.Modify();
                    updateStatusRejectApprovalEntryCustom(ApprovalEntry);
                END;
            DATABASE::"RFQ Header":
                BEGIN
                    RecRef.SetTable(lRecRFQHeader);
                    lRecRFQHeader.Validate("Status", lRecRFQHeader."Status"::Open);
                    lRecRFQHeader.Modify();
                    updateStatusRejectApprovalEntryCustom(ApprovalEntry);
                END;
        // DATABASE::"MR Consignment Header":
        //     BEGIN
        //         RecRef.SetTable(lRecMRCons);
        //         lRecMRCons.Validate("Status", lRecMRCons."Status"::Open);
        //         lRecMRCons.Modify();
        //         updateStatusRejectApprovalEntryCustom(ApprovalEntry);
        //     END;
        // DATABASE::"PR Consignment Header":
        //     BEGIN
        //         RecRef.SetTable(lRecPRCons);
        //         lRecPRCons.Validate("Status", lRecPRCons."Status"::Open);
        //         lRecPRCons.Modify();
        //         updateStatusRejectApprovalEntryCustom(ApprovalEntry);
        //     END;
        end;
    end;
    //approval mgt
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnReleaseDocument', '', false, false)]
    local procedure OnReleaseDocument(RecRef: RecordRef; var Handled: Boolean)
    var
        lRecPRMatHeader: Record "PR Material Header";
        lRecPRAssHeader: Record "PR Material Header";
        //lRecMRCons: Record "MR Consignment Header";
        //lRecPRCons: Record "PR Consignment Header";
        lRecMRHeader: Record "Material Req. Header";
        lRecRFQHeader: Record "RFQ Header";
    begin
        Case RecRef.NUMBER of
            DATABASE::"PR Material Header":
                BEGIN
                    RecRef.SetTable(lRecPRMatHeader);
                    lRecPRMatHeader.Validate("Status", lRecPRMatHeader."Status"::Released);
                    lRecPRMatHeader.Modify();
                    Handled := TRUE;
                END;
            // DATABASE::"PR Asset Header":
            //     BEGIN
            //         RecRef.SetTable(lRecPRAssHeader);
            //         lRecPRAssHeader.Validate("Status", lRecPRAssHeader."Status"::Released);
            //         lRecPRAssHeader.Modify();
            //         Handled := TRUE;
            //     END;
            // DATABASE::"Material Req. Header":
            //     BEGIN
            //         RecRef.SetTable(lRecMRHeader);
            //         lRecMRHeader.Validate("Status", lRecMRHeader."Status"::Released);
            //         lRecMRHeader.Modify();
            //         Handled := TRUE;
            //     END;
            DATABASE::"RFQ Header":
                BEGIN
                    RecRef.SetTable(lRecRFQHeader);
                    lRecRFQHeader.Validate("Status", lRecRFQHeader."Status"::Released);
                    lRecRFQHeader.Modify();
                    Handled := TRUE;
                END;
        // DATABASE::"MR Consignment Header":
        //     BEGIN
        //         RecRef.SetTable(lRecMRCons);
        //         lRecMRCons.Validate("Status", lRecMRCons."Status"::Released);
        //         lRecMRCons.Modify();
        //         Handled := TRUE;
        //     END;
        // DATABASE::"PR Consignment Header":
        //     BEGIN
        //         RecRef.SetTable(lRecPRCons);
        //         lRecPRCons.Validate("Status", lRecPRCons."Status"::Released);
        //         lRecPRCons.Modify();
        //         Handled := TRUE;
        //     END;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnOpenDocument', '', false, false)]
    local procedure onOpenDocument(RecRef: RecordRef; var Handled: Boolean)
    var
        lRecPRMatHeader: Record "PR Material Header";
        lRecPRAssHeader: Record "PR Material Header";
        //lRecMRCons: Record "MR Consignment Header";
        //lRecPRCons: Record "PR Consignment Header";
        lRecMRHeader: Record "Material Req. Header";
        lRecRFQHeader: Record "RFQ Header";
    begin
        Case RecRef.NUMBER of
            DATABASE::"PR Material Header":
                BEGIN
                    RecRef.SetTable(lRecPRMatHeader);
                    lRecPRMatHeader.Validate("Status", lRecPRMatHeader."Status"::Open);
                    lRecPRMatHeader.Modify();
                    Handled := TRUE;
                END;
            // DATABASE::"PR Asset Header":
            //     BEGIN
            //         RecRef.SetTable(lRecPRAssHeader);
            //         lRecPRAssHeader.Validate("Status", lRecPRAssHeader."Status"::Open);
            //         lRecPRAssHeader.Modify();
            //         Handled := TRUE;
            //     END;
            DATABASE::"Material Req. Header":
                BEGIN
                    RecRef.SetTable(lRecMRHeader);
                    lRecMRHeader.Validate("Status", lRecMRHeader."Status"::Open);
                    lRecMRHeader.Modify();
                    Handled := TRUE;
                END;
            DATABASE::"RFQ Header":
                BEGIN
                    RecRef.SetTable(lRecRFQHeader);
                    lRecRFQHeader.Validate("Status", lRecRFQHeader."Status"::Open);
                    lRecRFQHeader.Modify();
                    Handled := TRUE;
                END;
        // DATABASE::"MR Consignment Header":
        //     BEGIN
        //         RecRef.SetTable(lRecMRCons);
        //         lRecMRCons.Validate("Status", lRecMRCons."Status"::Open);
        //         lRecMRCons.Modify();
        //         Handled := TRUE;
        //     END;
        // DATABASE::"PR Consignment Header":
        //     BEGIN
        //         RecRef.SetTable(lRecPRCons);
        //         lRecPRCons.Validate("Status", lRecPRCons."Status"::Open);
        //         lRecPRCons.Modify();
        //         Handled := TRUE;
        //     END;
        end;
    end;

    procedure HasOpenOrPendingApprovalEntriesCustom(var ApprovalEntry: Record "Approval Entry"): Boolean
    var
        lRecApprovalEntry: Record "Approval Entry";
    begin
        lRecApprovalEntry.RESET;
        lRecApprovalEntry.SetRange("Table ID", ApprovalEntry."Table ID");
        lRecApprovalEntry.SetRange("Record ID to Approve", ApprovalEntry."Record ID to Approve");
        lRecApprovalEntry.SetFilter(Status, '%1|%2', lRecApprovalEntry.Status::Open, lRecApprovalEntry.Status::Created);
        lRecApprovalEntry.SETRANGE(lRecApprovalEntry."Workflow Step Instance ID", ApprovalEntry."Workflow Step Instance ID");
        if lRecApprovalEntry.IsEmpty() then exit(false);
        lRecApprovalEntry.SetRange("Related to Change", false);
        exit(not lRecApprovalEntry.IsEmpty);
    end;

    procedure updateStatusOpenNextApprovalEntryCustom(var ApprovalEntry: Record "Approval Entry")
    var
        lRecApprovalEntry: Record "Approval Entry";
        lRecApprovalEntryUpd: Record "Approval Entry";
        WorkflowStepInstance: Record "Workflow Step Instance";
        lCUApprovalMgt: Codeunit "Approvals Mgmt.";
    begin
        lRecApprovalEntry.RESET;
        lRecApprovalEntry.SetCurrentKey("Table ID", "Document Type", "Document No.", "Sequence No.");
        lRecApprovalEntry.SetRange("Record ID to Approve", ApprovalEntry."Record ID to Approve");
        lRecApprovalEntry.SetRange("Workflow Step Instance ID", ApprovalEntry."Workflow Step Instance ID");
        lRecApprovalEntry.SetRange(Status, lRecApprovalEntry.Status::Created);
        if lRecApprovalEntry.FINDFIRST then begin
            lRecApprovalEntryUpd.RESET;
            lRecApprovalEntryUpd.CopyFilters(lRecApprovalEntry);
            lRecApprovalEntryUpd.SetRange("Sequence No.", lRecApprovalEntry."Sequence No.");
            if lRecApprovalEntryUpd.FIND('-') then
                repeat
                    lRecApprovalEntryUpd.Validate(Status, lRecApprovalEntryUpd.Status::Open);
                    lRecApprovalEntryUpd.Modify(true);
                    lCUApprovalMgt.CreateApprovalEntryNotification(lRecApprovalEntryUpd, WorkflowStepInstance);
                until lRecApprovalEntryUpd.Next() = 0;
        end;
    end;

    procedure updateStatusCancelApprovalEntryCustom(var ApprovalEntry: Record "Approval Entry")
    var
        lRecApprovalEntry: Record "Approval Entry";
        WorkflowStepInstance: Record "Workflow Step Instance";
        lCUApprovalMgt: Codeunit "Approvals Mgmt.";
        OldStatus: Enum "Approval Status";
    begin
        lRecApprovalEntry.RESET;
        lRecApprovalEntry.SetCurrentKey("Table ID", "Document Type", "Document No.", "Sequence No.");
        lRecApprovalEntry.SetRange("Table ID", ApprovalEntry."Table ID");
        lRecApprovalEntry.SetRange("Record ID to Approve", ApprovalEntry."Record ID to Approve");
        lRecApprovalEntry.SetFilter(Status, '<>%1&<>%2', lRecApprovalEntry.Status::Rejected, lRecApprovalEntry.Status::Canceled);
        lRecApprovalEntry.SetRange("Workflow Step Instance ID", ApprovalEntry."Workflow Step Instance ID");
        if lRecApprovalEntry.FIND('-') then begin
            repeat
                OldStatus := ApprovalEntry.Status;
                lRecApprovalEntry.Validate(Status, lRecApprovalEntry.Status::Canceled);
                lRecApprovalEntry.Modify(true);
                if OldStatus in [ApprovalEntry.Status::Open, ApprovalEntry.Status::Approved] then lCUApprovalMgt.CreateApprovalEntryNotification(lRecApprovalEntry, WorkflowStepInstance);
            until lRecApprovalEntry.Next() = 0;
        end;
    end;

    procedure updateStatusRejectApprovalEntryCustom(var ApprovalEntry: Record "Approval Entry")
    var
        lRecApprovalEntry: Record "Approval Entry";
        WorkflowStepInstance: Record "Workflow Step Instance";
        lCUApprovalMgt: Codeunit "Approvals Mgmt.";
        OldStatus: Enum "Approval Status";
    begin
        lRecApprovalEntry.RESET;
        lRecApprovalEntry.SetCurrentKey("Table ID", "Document Type", "Document No.", "Sequence No.");
        lRecApprovalEntry.SetRange("Table ID", ApprovalEntry."Table ID");
        lRecApprovalEntry.SetRange("Record ID to Approve", ApprovalEntry."Record ID to Approve");
        lRecApprovalEntry.SetFilter(Status, '<>%1&<>%2', lRecApprovalEntry.Status::Rejected, lRecApprovalEntry.Status::Canceled);
        lRecApprovalEntry.SetRange("Workflow Step Instance ID", ApprovalEntry."Workflow Step Instance ID");
        if lRecApprovalEntry.FIND('-') then begin
            repeat
                OldStatus := ApprovalEntry.Status;
                lRecApprovalEntry.Validate(Status, lRecApprovalEntry.Status::Rejected);
                lRecApprovalEntry.Modify(true);
                if OldStatus in [ApprovalEntry.Status::Open] then lCUApprovalMgt.CreateApprovalEntryNotification(lRecApprovalEntry, WorkflowStepInstance);
            until lRecApprovalEntry.Next() = 0;
        end;
    end;
    //action handling mandatory    
    //page management mandatory
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Page Management", 'OnConditionalCardPageIDNotFound', '', false, false)]
    local procedure OnConditionalCardPageIDNotFound(RecordRef: RecordRef; var CardPageID: Integer)
    begin
        case RecordRef.Number of
            DATABASE::"PR Material Header":
                BEGIN
                    CardPageID := Page::"PR Material Card APPV";
                END;
            // DATABASE::"PR Asset Header":
            //     BEGIN
            //         CardPageID := Page::"PR Asset Card";
            //     END;
            DATABASE::"Material Req. Header":
                BEGIN
                    CardPageID := Page::"Material Req. Card APPRV";
                END;
            DATABASE::"RFQ Header":
                BEGIN
                    CardPageID := Page::"RFQ Card";
                END;
        // DATABASE::"MR Consignment Header":
        //     BEGIN
        //         CardPageID := Page::"MR Consignment Card";
        //     END;
        // DATABASE::"PR Consignment Header":
        //     BEGIN
        //         CardPageID := Page::"PR Consignment Card";
        //     END;
        end;
    end;
    //page management mandatory     
    //setup template 
    //insert workflow category
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Setup", 'OnAddWorkflowCategoriesToLibrary', '', false, false)]
    procedure OnAddWorkflowCategoriesToLibrary()
    begin
        WorkflowSetup.InsertWorkflowCategory(PRWorkflowCategoryTxt, PRWorkflowCategoryDescTxt);
    end;
    //insert workflow category
    //add table relation
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Setup", 'OnAfterInsertApprovalsTableRelations', '', false, false)]
    procedure OnAfterInsertApprovalsTableRelations()
    var
        ApprovalEntry: Record "Approval Entry";
    begin
        WorkflowSetup.InsertTableRelation(DATABASE::"PR Material Header", 0, DATABASE::"Approval Entry", ApprovalEntry.FieldNo("Record ID to Approve"));
        //WorkflowSetup.InsertTableRelation(DATABASE::"PR Asset Header", 0, DATABASE::"Approval Entry", ApprovalEntry.FieldNo("Record ID to Approve"));
        WorkflowSetup.InsertTableRelation(DATABASE::"Material Req. Header", 0, DATABASE::"Approval Entry", ApprovalEntry.FieldNo("Record ID to Approve"));
        WorkflowSetup.InsertTableRelation(DATABASE::"RFQ Header", 0, DATABASE::"Approval Entry", ApprovalEntry.FieldNo("Record ID to Approve"));
        //WorkflowSetup.InsertTableRelation(DATABASE::"MR Consignment Header", 0, DATABASE::"Approval Entry", ApprovalEntry.FieldNo("Record ID to Approve"));
        //WorkflowSetup.InsertTableRelation(DATABASE::"PR Consignment Header", 0, DATABASE::"Approval Entry", ApprovalEntry.FieldNo("Record ID to Approve"));
    end;
    //add table relation  
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Setup", 'OnInsertWorkflowTemplates', '', false, false)]
    procedure OnInsertWorkflowTemplates()
    begin
        insertPRMaterialApprovalWorkflowTemplate();
        //insertPRAssetApprovalWorkflowTemplate();
        insertMRApprovalWorkflowTemplate();
        insertRFQApprovalWorkflowTemplate();
        //insertMRConsApprovalWorkflowTemplate();
        //insertPRConsApprovalWorkflowTemplate();
    end;

    local procedure insertPRMaterialApprovalWorkflowTemplate()
    var
        Workflow: Record Workflow;
    begin
        WorkflowSetup.InsertWorkflowTemplate(Workflow, PRMaterialApprovalWorkflowCodeTxt, PRMaterialApprovalWorkfowDescTxt, PRWorkflowCategoryTxt);
        InsertPRMaterialApprovalWorkflowDetails(Workflow);
        WorkflowSetup.MarkWorkflowAsTemplate(Workflow);
    end;

    // local procedure insertPRAssetApprovalWorkflowTemplate()
    // var
    //     Workflow: Record Workflow;
    // begin
    //     WorkflowSetup.InsertWorkflowTemplate(Workflow, PRAssetApprovalWorkflowCodeTxt, PRAssetApprovalWorkfowDescTxt, PRWorkflowCategoryTxt);
    //     InsertPRAssetApprovalWorkflowDetails(Workflow);
    //     WorkflowSetup.MarkWorkflowAsTemplate(Workflow);
    // end;

    local procedure insertMRApprovalWorkflowTemplate()
    var
        Workflow: Record Workflow;
    begin
        WorkflowSetup.InsertWorkflowTemplate(Workflow, MRApprovalWorkflowCodeTxt, MRApprovalWorkfowDescTxt, PRWorkflowCategoryTxt);
        InsertMRApprovalWorkflowDetails(Workflow);
        WorkflowSetup.MarkWorkflowAsTemplate(Workflow);
    end;

    local procedure insertRFQApprovalWorkflowTemplate()
    var
        Workflow: Record Workflow;
    begin
        WorkflowSetup.InsertWorkflowTemplate(Workflow, RFQApprovalWorkflowCodeTxt, RFQApprovalWorkfowDescTxt, PRWorkflowCategoryTxt);
        InsertRFQApprovalWorkflowDetails(Workflow);
        WorkflowSetup.MarkWorkflowAsTemplate(Workflow);
    end;

    // local procedure insertMRConsApprovalWorkflowTemplate()
    // var
    //     Workflow: Record Workflow;
    // begin
    //     WorkflowSetup.InsertWorkflowTemplate(Workflow, MRConsApprovalWorkflowCodeTxt, MRConsApprovalWorkfowDescTxt, ConsWorkflowCategoryTxt);
    //     InsertMRConsApprovalWorkflowDetails(Workflow);
    //     WorkflowSetup.MarkWorkflowAsTemplate(Workflow);
    // end;

    // local procedure insertPRConsApprovalWorkflowTemplate()
    // var
    //     Workflow: Record Workflow;
    // begin
    //     WorkflowSetup.InsertWorkflowTemplate(Workflow, PRConsApprovalWorkflowCodeTxt, PRConsApprovalWorkfowDescTxt, ConsWorkflowCategoryTxt);
    //     InsertPRConsApprovalWorkflowDetails(Workflow);
    //     WorkflowSetup.MarkWorkflowAsTemplate(Workflow);
    // end;

    local procedure InsertPRMaterialApprovalWorkflowDetails(var Workflow: Record Workflow)
    var
        WorkflowStepArgument: Record "Workflow Step Argument";
        BlankDateFormula: DateFormula;
        WorkflowResponseHandling: Codeunit "Workflow Response Handling";
        lRecPRMatHeader: Record "PR Material Header";
    begin
        WorkflowSetup.InitWorkflowStepArgument(WorkflowStepArgument, WorkflowStepArgument."Approver Type"::Approver, WorkflowStepArgument."Approver Limit Type"::"Direct Approver", 0, '', BlankDateFormula, true);
        lRecPRMatHeader.INIT();
        WorkflowSetup.InsertRecApprovalWorkflowSteps(Workflow, BuildPRMaterialTypeCondition(lRecPRMatHeader), RunWorkflowOnSendApprovalCode_PRMaterial(), WorkflowResponseHandling.CreateApprovalRequestsCode(), WorkflowResponseHandling.SendApprovalRequestForApprovalCode(), RunWorkflowOnCancelApprovalCode_PRMaterial(), WorkflowStepArgument, false, false);
    end;

    // local procedure InsertPRAssetApprovalWorkflowDetails(var Workflow: Record Workflow)
    // var
    //     WorkflowStepArgument: Record "Workflow Step Argument";
    //     BlankDateFormula: DateFormula;
    //     WorkflowResponseHandling: Codeunit "Workflow Response Handling";
    //     lRecPRAssHeader: Record "PR Asset Header";
    // begin
    //     WorkflowSetup.InitWorkflowStepArgument(WorkflowStepArgument, WorkflowStepArgument."Approver Type"::Approver, WorkflowStepArgument."Approver Limit Type"::"Direct Approver", 0, '', BlankDateFormula, true);
    //     lRecPRAssHeader.INIT();
    //     WorkflowSetup.InsertRecApprovalWorkflowSteps(Workflow, BuildPRAssetTypeCondition(lRecPRAssHeader), RunWorkflowOnSendApprovalCode_PRAsset(), WorkflowResponseHandling.CreateApprovalRequestsCode(), WorkflowResponseHandling.SendApprovalRequestForApprovalCode(), RunWorkflowOnCancelApprovalCode_PRAsset(), WorkflowStepArgument, false, false);
    // end;

    local procedure InsertMRApprovalWorkflowDetails(var Workflow: Record Workflow)
    var
        WorkflowStepArgument: Record "Workflow Step Argument";
        BlankDateFormula: DateFormula;
        WorkflowResponseHandling: Codeunit "Workflow Response Handling";
        lRecMRHeader: Record "Material Req. Header";
    begin
        WorkflowSetup.InitWorkflowStepArgument(WorkflowStepArgument, WorkflowStepArgument."Approver Type"::Approver, WorkflowStepArgument."Approver Limit Type"::"Direct Approver", 0, '', BlankDateFormula, true);
        lRecMRHeader.INIT();
        WorkflowSetup.InsertRecApprovalWorkflowSteps(Workflow, BuildMRTypeCondition(lRecMRHeader), RunWorkflowOnSendApprovalCode_MR(), WorkflowResponseHandling.CreateApprovalRequestsCode(), WorkflowResponseHandling.SendApprovalRequestForApprovalCode(), RunWorkflowOnCancelApprovalCode_MR(), WorkflowStepArgument, false, false);
    end;

    local procedure InsertRFQApprovalWorkflowDetails(var Workflow: Record Workflow)
    var
        WorkflowStepArgument: Record "Workflow Step Argument";
        BlankDateFormula: DateFormula;
        WorkflowResponseHandling: Codeunit "Workflow Response Handling";
        lRecRFQHeader: Record "RFQ Header";
    begin
        WorkflowSetup.InitWorkflowStepArgument(WorkflowStepArgument, WorkflowStepArgument."Approver Type"::Approver, WorkflowStepArgument."Approver Limit Type"::"Direct Approver", 0, '', BlankDateFormula, true);
        lRecRFQHeader.INIT();
        WorkflowSetup.InsertRecApprovalWorkflowSteps(Workflow, BuildRFQTypeCondition(lRecRFQHeader), RunWorkflowOnSendApprovalCode_RFQ(), WorkflowResponseHandling.CreateApprovalRequestsCode(), WorkflowResponseHandling.SendApprovalRequestForApprovalCode(), RunWorkflowOnCancelApprovalCode_RFQ(), WorkflowStepArgument, false, false);
    end;

    // local procedure InsertMRConsApprovalWorkflowDetails(var Workflow: Record Workflow)
    // var
    //     WorkflowStepArgument: Record "Workflow Step Argument";
    //     BlankDateFormula: DateFormula;
    //     WorkflowResponseHandling: Codeunit "Workflow Response Handling";
    //     lRecMRCons: Record "MR Consignment Header";
    // begin
    //     WorkflowSetup.InitWorkflowStepArgument(WorkflowStepArgument, WorkflowStepArgument."Approver Type"::Approver, WorkflowStepArgument."Approver Limit Type"::"Direct Approver", 0, '', BlankDateFormula, true);
    //     lRecMRCons.INIT();
    //     WorkflowSetup.InsertRecApprovalWorkflowSteps(Workflow, BuildMRConsTypeCondition(lRecMRCons), RunWorkflowOnSendApprovalCode_MRCons(), WorkflowResponseHandling.CreateApprovalRequestsCode(), WorkflowResponseHandling.SendApprovalRequestForApprovalCode(), RunWorkflowOnCancelApprovalCode_MRCons(), WorkflowStepArgument, false, false);
    // end;

    // local procedure InsertPRConsApprovalWorkflowDetails(var Workflow: Record Workflow)
    // var
    //     WorkflowStepArgument: Record "Workflow Step Argument";
    //     BlankDateFormula: DateFormula;
    //     WorkflowResponseHandling: Codeunit "Workflow Response Handling";
    //     lRecPRCons: Record "PR Consignment Header";
    // begin
    //     WorkflowSetup.InitWorkflowStepArgument(WorkflowStepArgument, WorkflowStepArgument."Approver Type"::Approver, WorkflowStepArgument."Approver Limit Type"::"Direct Approver", 0, '', BlankDateFormula, true);
    //     lRecPRCons.INIT();
    //     WorkflowSetup.InsertRecApprovalWorkflowSteps(Workflow, BuildPRConsTypeCondition(lRecPRCons), RunWorkflowOnSendApprovalCode_PRCons(), WorkflowResponseHandling.CreateApprovalRequestsCode(), WorkflowResponseHandling.SendApprovalRequestForApprovalCode(), RunWorkflowOnCancelApprovalCode_PRCons(), WorkflowStepArgument, false, false);
    // end;

    local procedure BuildPRMaterialTypeCondition(var parHeader: Record "PR Material Header"): Text
    begin
        exit(StrSubstNo(PRMaterialTypeCondTxt, WorkflowSetup.Encode(parHeader.GetView(false))));
    end;

    // local procedure BuildPRAssetTypeCondition(var parHeader: Record "PR Asset Header"): Text
    // begin
    //     exit(StrSubstNo(PRAssetTypeCondTxt, WorkflowSetup.Encode(parHeader.GetView(false))));
    // end;

    local procedure BuildMRTypeCondition(var parHeader: Record "Material Req. Header"): Text
    begin
        exit(StrSubstNo(MRTypeCondTxt, WorkflowSetup.Encode(parHeader.GetView(false))));
    end;

    local procedure BuildRFQTypeCondition(var parHeader: Record "RFQ Header"): Text
    begin
        exit(StrSubstNo(RFQTypeCondTxt, WorkflowSetup.Encode(parHeader.GetView(false))));
    end;

    // local procedure BuildMRConsTypeCondition(var parHeader: Record "MR Consignment Header"): Text
    // begin
    //     exit(StrSubstNo(MRConsTypeCondTxt, WorkflowSetup.Encode(parHeader.GetView(false))));
    // end;

    // local procedure BuildPRConsTypeCondition(var parHeader: Record "PR Consignment Header"): Text
    // begin
    //     exit(StrSubstNo(RFQTypeCondTxt, WorkflowSetup.Encode(parHeader.GetView(false))));
    // end;

    //setup template
    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnShowApprovalRemarkssOnAfterSetApprovalRemarksLineFilters', '', false, false)]
    // local procedure OnShowApprovalRemarkssOnAfterSetApprovalRemarksLineFilters(var ApprovalRemarksLine: Record "Approval Remarks Line"; ApprovalEntry: Record "Approval Entry"; RecRef: RecordRef)  
    // begin 
    // end;
    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnBeforeSendApprovalRequestFromApprovalEntry', '', false, false)]
    // local procedure OnBeforeSendApprovalRequestFromApprovalEntry(ApprovalEntry: Record "Approval Entry"; WorkflowStepInstance: Record "Workflow Step Instance"; var IsHandled: Boolean)
    // begin
    //     // message(FORMAT(ApprovalEntry));
    //     // message(FORMAT(WorkflowStepInstance));
    // end;
    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnSendApprovalRequestFromRecordOnAfterSetApprovalEntryFilters', '', false, false)]
    // local procedure OnSendApprovalRequestFromRecordOnAfterSetApprovalEntryFilters(var ApprovalEntry: Record "Approval Entry"; RecRef: RecordRef; var IsHandled: Boolean)
    // begin
    //     message(FORMAT(ApprovalEntry));
    // end;

}
