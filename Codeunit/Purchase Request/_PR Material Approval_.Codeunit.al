codeunit 50116 "PR Material Approval"
{
    trigger OnRun()
    begin
    end;

    [IntegrationEvent(false, false)]
    PROCEDURE OnSendforApproval_PRMaterial(VAR ParRec: Record "PR Material Header");
    begin
    end;

    [IntegrationEvent(false, false)]
    PROCEDURE OnCancelforApproval_PRMaterial(VAR ParRec: Record "PR Material Header");
    begin
    end;

    procedure CheckWorkflowEnabled(var ParRec: Record "PR Material Header"): Boolean
    var
        lRec: Record "PR Material Header";
    begin
        if not IsEnabled_Custom(ParRec) then Error(NoWorkflowEnb);
        exit(true);
    end;

    procedure IsEnabled_Custom(var ParRec: Record "PR Material Header"): Boolean
    var
        MSIWorkflow: Codeunit "MII Workflow";
    begin
        exit(WorkflowMgt.CanExecuteWorkflow(ParRec, MSIWorkflow.RunWorkflowOnSendApprovalCode_PRMaterial()))
    end;

    var
        NothingtoApproveErr: Label 'There is nothing to approve';
        NoWorkflowEnb: Label 'No approval workflow for this record type is enabled';
        DocSendApprovalMsg: Label 'Approval of a Purchase Request Material is requested';
        DocApprovalCanceledMsg: Label 'An approval request for a Purchase Request Material is canceled';
        PendingApprovalMsg: Label 'An approval request for a Purchase Purchase Material has been sent';
        DocReleasedlMsg: Label 'Purchase Request Material is released';
        WorkflowMgt: Codeunit "Workflow Management";
        WorkflowResponseHandling: Codeunit "Workflow Response Handling";
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
}
