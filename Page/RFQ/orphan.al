page 50199 "Orphan RFQ Cleanup"
{
    PageType = List;
    SourceTable = "RFQ Line";
    Caption = 'Orphan RFQ Lines';
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Orphans)
            {
                field("RFQ No."; Rec."RFQ No.")
                {
                }
                field("Line No."; Rec."Line No.")
                {
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(ActionDelete)
            {
                ApplicationArea = All;
                Caption = 'Delete All Orphans';
                Image = Delete;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    if Confirm('Delete %1 orphans?', false, Rec.Count) then begin
                        Rec.DeleteAll(true);
                        Message('%1 orphans deleted!', Rec.Count);
                        CurrPage.Close();
                    end;
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.Reset();
        Rec.SetFilter("RFQ No.", '');
    end;


}
