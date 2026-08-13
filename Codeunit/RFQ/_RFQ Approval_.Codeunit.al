codeunit 50107 "RFQ Approval"
{
    trigger OnRun()
    begin
    end;

    [IntegrationEvent(false, false)]
    PROCEDURE OnSendforApproval_RFQ(VAR ParRec: Record "RFQ Header");
    begin
    end;



    [IntegrationEvent(false, false)]
    PROCEDURE OnCancelforApproval_RFQ(VAR ParRec: Record "RFQ Header");
    begin
    end;

    [IntegrationEvent(false, false)]
    PROCEDURE OnCancelforApproval_vensel(VAR ParRec: Record VendorselHead);
    begin
    end;

    procedure CheckWorkflowEnabled(var ParRec: Record "RFQ Header"): Boolean
    var
        lRec: Record "PR Material Header";
    begin
        if not IsEnabled_Custom(ParRec) then Error(NoWorkflowEnb);
        exit(true);
    end;


    procedure IsEnabled_Custom(var ParRec: Record "RFQ Header"): Boolean
    var
        MSIWorkflow: Codeunit "MII Workflow";
    begin
        exit(WorkflowMgt.CanExecuteWorkflow(ParRec, MSIWorkflow.RunWorkflowOnSendApprovalCode_RFQ()))
    end;

    procedure IsEnabled_Custom2(var ParRec: Record "Vensel Header"): Boolean
    var
        MSIWorkflow: Codeunit "MII Workflow";
    begin
        exit(WorkflowMgt.CanExecuteWorkflow(ParRec, MSIWorkflow.RunWorkflowOnSendApprovalCode_RFQ()))
    end;








    var
        NothingtoApproveErr: Label 'There is nothing to approve';
        NoWorkflowEnb: Label 'No approval workflow for this record type is enabled';
        DocSendApprovalMsg: Label 'Approval of a RFQ is requested';
        DocApprovalCanceledMsg: Label 'An approval request for a RFQ is canceled';
        PendingApprovalMsg: Label 'An approval request for a RFQ has been sent';
        DocReleasedlMsg: Label 'RFQ is released';
        WorkflowMgt: Codeunit "Workflow Management";
        WorkflowResponseHandling: Codeunit "Workflow Response Handling";
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
}
