codeunit 50102 "Material Req. Approval"
{
    trigger OnRun()
    begin
    end;

    [IntegrationEvent(false, false)]
    PROCEDURE OnSendforApproval_MR(VAR ParRec: Record "Material Req. Header");
    begin
    end;

    [IntegrationEvent(false, false)]
    PROCEDURE OnCancelforApproval_MR(VAR ParRec: Record "Material Req. Header");
    begin
    end;

    procedure CheckWorkflowEnabled(var ParRec: Record "Material Req. Header"): Boolean
    var
        lRec: Record "Material Req. Header";
    begin
        if not IsEnabled_Custom(ParRec) then Error(NoWorkflowEnb);
        exit(true);
    end;

    procedure IsEnabled_Custom(var ParRec: Record "Material Req. Header"): Boolean
    var
        MIIWorkflow: Codeunit "MII Workflow";
    begin
        exit(WorkflowMgt.CanExecuteWorkflow(ParRec, MIIWorkflow.RunWorkflowOnSendApprovalCode_MR()))
    end;

    var
        NothingtoApproveErr: Label 'There is nothing to approve';
        NoWorkflowEnb: Label 'No approval workflow for this record type is enabled';
        DocSendApprovalMsg: Label 'Approval of a Material Request is requested';
        DocApprovalCanceledMsg: Label 'An approval request for a Material Request is canceled';
        PendingApprovalMsg: Label 'An approval request for a Material Request has been sent';
        DocReleasedlMsg: Label 'Material Request is released';
        WorkflowMgt: Codeunit "Workflow Management";
        WorkflowResponseHandling: Codeunit "Workflow Response Handling";
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
}
