page 50198 "RFQ List"
{
    PageType = List;
    SourceTable = "RFQ Header";
    ApplicationArea = All;
    UsageCategory = Lists;
    CardPageId = "RFQ Card";
    Editable = FALSE;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("RFQ No."; Rec."RFQ No.")
                {
                    ApplicationArea = All;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
                field("Total Amount"; Rec."Total Amount")
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
                SubPageLink = "Table ID" = CONST(database::"RFQ Header"), "No." = FIELD("RFQ No.");
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
                    lRec: Record "RFQ Header";
                begin
                    Rec.TestField(Rec."RFQ No.");
                    lRec.RESET;
                    lRec.SETRANGE(lRec."RFQ No.", Rec."RFQ No.");

                end;
            }
        }
    }
    var
    // IntCodeunit: Codeunit IntCodeunitForRFQ;
}
