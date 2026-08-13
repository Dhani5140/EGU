page 50160 "Vendsel List"
{
    PageType = List;
    SourceTable = "Vensel Header";
    Caption = 'Vendor Selection List';
    ApplicationArea = All;
    UsageCategory = Lists;
    CardPageId = "Vendor Select Header";
    Editable = FALSE;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Vensel No."; Rec."Vensel No.")
                {
                    ApplicationArea = all;
                }
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
                // field("Total Amount"; Rec."Total Amount")
                // {
                //     ApplicationArea = All;
                // }
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
            action("Print Vendor Evaluation")
            {
                ApplicationArea = All;
                Caption = 'Vendor Delivery Evaluation';
                Image = PrintReport;
                Promoted = True;
                PromotedCategory = Report;
                PromotedIsBig = TRUE;
                ToolTip = 'Cetak laporan evaluasi pengiriman vendor untuk dokumen yang disorot.';

                trigger OnAction()
                var
                    lRecVensel: Record "Vensel Header";
                begin

                    Rec.TestField("Vensel No.");


                    lRecVensel.Reset();
                    lRecVensel.SetRange("Vensel No.", Rec."Vensel No.");


                    Report.Run(Report::"Simple Vendor Evaluation", true, false, lRecVensel);
                end;
            }
        }
    }
    var
    // IntCodeunit: Codeunit IntCodeunitForRFQ;
}
