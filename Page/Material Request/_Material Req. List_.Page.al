page 50101 "Material Req. List"
{
    ApplicationArea = All;
    Caption = 'Request Order List';
    PageType = List;
    SourceTable = "Material Req. Header";
    UsageCategory = Lists;
    CardPageId = "Material Req. Card";
    //SourceTableView = where(Status = filter(Open | Closed | "Pending Approval" | Released | "Partial Receive / Processed On PR" | Canceled));
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("No."; Rec."Material Req. No.")
                {
                    ApplicationArea = All;
                }
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = All;
                }
                field(RequesterID; Rec.RequesterID)
                {
                    ApplicationArea = All;
                }
                field("Requester Department"; Rec."Requester Department")
                {
                    ApplicationArea = all;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
            }
        }
        area(FactBoxes)
        {
            part("Document Attachment FactBox"; "Doc. Attachment List Factbox")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Table ID" = CONST(database::"Material Req. Header"), "No." = FIELD("Material Req. No.");
            }
            systempart(Notes; Notes)
            {
                ApplicationArea = all;
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Print")
            {
                ApplicationArea = All;
                Image = Print;
                Promoted = True;
                PromotedCategory = Process;
                PromotedIsBig = TRUE;

                trigger OnAction()
                var
                    lRec: Record "Material Req. Header";
                begin
                    Rec.TestField(Rec."Material Req. No.");
                    lRec.RESET;
                    lRec.SETRANGE(lRec."Material Req. No.", Rec."Material Req. No.");

                end;
            }
        }
    }
    trigger OnOpenPage()
    var
    //emp: Record Employee_Req;
    //empreq: Codeunit req_dept;
    begin
        //Rec.SetFilter("Requester Department", empreq.GetWarehouseEmployeeLocationFilter2(UserId));


    end;
}
