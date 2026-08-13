page 50106 "PR Material Subform"
{
    PageType = ListPart;
    SourceTable = "PR Material Line";
    AutoSplitKey = true;
    DelayedInsert = true;
    RefreshOnActivate = TRUE;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Purchase Req. No."; Rec."Purchase Req. No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Material Req. No."; Rec."Material Req. No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = ALL;
                    Editable = true;
                    trigger OnValidate()
                    begin
                        IF Rec.Type = Rec.Type::Item THEN
                            gBolEditable := FALSE
                        ELSE
                            gBolEditable := TRUE;
                        CurrPage.Update;
                    end;
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                }

                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;
                    Editable = gBolEditable;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    Editable = gBolEditable;
                }

                // field("Item No."; Rec."Item No.")
                // {
                //     ApplicationArea = All;
                //     Editable = gBolEditable;

                //     trigger OnLookup(var Text: Text): Boolean
                //     var
                //         lRecItem: Record Item;
                //         lRecHeader: Record "PR Material Header";
                //         lPageItemList: Page "Item List";
                //     begin

                //         if Rec.Type = Rec.Type::Item then begin


                //             if lRecHeader.Get(Rec."Purchase Req. No.") then begin
                //                 lRecItem.Reset();


                //                 if lRecHeader."Item Category Code" <> '' then
                //                     lRecItem.SetRange("Item Category Code", lRecHeader."Item Category Code");
                //             end;


                //             lPageItemList.SetTableView(lRecItem);
                //             lPageItemList.LookupMode(true);

                //             if lPageItemList.RunModal() = Action::LookupOK then begin
                //                 lPageItemList.GetRecord(lRecItem);


                //                 Rec.Validate("Item No.", lRecItem."No.");
                //                 CurrPage.Update(true);
                //             end;


                //             exit(true);
                //         end;


                //         exit(false);
                //     end;
                // }
                field("Variant Code"; Rec."Variant Code")
                {
                    ApplicationArea = all;
                    Editable = gBolEditable;
                }
                field(Description; Rec."Description")
                {
                    ApplicationArea = All;
                    Editable = gBolEditable;
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = all;
                    Editable = gBolEditable;
                    Caption = 'Remarks PR';
                }
                field(Quantity; Rec."Quantity")
                {
                    ApplicationArea = All;
                    DecimalPlaces = 0 : 5;
                    Editable = gBolEditable;
                    ShowMandatory = TRUE;

                    trigger OnValidate()
                    begin
                        CurrPage.UPDATE();
                    end;
                }
                field("Unit of Measure Code"; Rec."Unit of Measure")
                {
                    ApplicationArea = All;
                    Editable = gBolEditable;
                }
                field("Direct Unit Cost"; Rec."Direct Unit Cost")
                {
                    ApplicationArea = All;
                    Editable = gBolEditable;

                    trigger OnValidate()
                    begin
                        CurrPage.UPDATE();
                    end;
                }
                field("Line Amount"; Rec."Line Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                    Editable = gBolEditable;

                    trigger OnValidate()
                    begin
                        CurrPage.UPDATE;
                    end;
                }
                field("Outstanding Quantity"; Rec."Outstanding Quantity")
                {
                    ApplicationArea = All;
                    Editable = FALSE;
                    ToolTip = 'Specifies the value of the Total Qty On PO field.';
                }
                field("Total Qty On RFQ"; Rec."Total Qty On RFQ")
                {
                    ApplicationArea = All;
                    Editable = FALSE;
                    ToolTip = 'Specifies the value of the Total Qty On RFQ field.';
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = all;
                    Caption = '1,2,1';
                    Editable = gBolEditable;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = all;
                    Caption = '1,2,2';
                    Editable = gBolEditable;
                }
                field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
                {
                    ApplicationArea = all;
                    Caption = '1,2,3';
                    Editable = gBolEditable;
                }
                field("Shortcut Dimension 4 Code"; Rec."Shortcut Dimension 4 Code")
                {
                    ApplicationArea = all;
                    Caption = '1,2,4';
                    Editable = gBolEditable;
                }
                field("Shortcut Dimension 5 Code"; Rec."Shortcut Dimension 5 Code")
                {
                    ApplicationArea = all;
                    Caption = '1,2,5';
                    Editable = gBolEditable;
                }
                field("Shortcut Dimension 6 Code"; Rec."Shortcut Dimension 6 Code")
                {
                    ApplicationArea = all;
                    Caption = '1,2,6';
                    Editable = gBolEditable;
                }
                field("Shortcut Dimension 7 Code"; Rec."Shortcut Dimension 7 Code")
                {
                    ApplicationArea = all;
                    Caption = '1,2,7';
                    Editable = gBolEditable;
                }
                field("Shortcut Dimension 8 Code"; Rec."Shortcut Dimension 8 Code")
                {
                    ApplicationArea = all;
                    Caption = '1,2,8';
                    Editable = gBolEditable;
                }
                field("Purchase Budget Name"; Rec."Purchase Budget Name")
                {
                    ApplicationArea = all;
                }
                field("Budgeted Quantity"; Rec."Budgeted Quantity")
                {
                    ApplicationArea = all;
                }
                field("Purchase Budget"; Rec."Purchase Budget")
                {
                    ApplicationArea = all;
                }
                field("Purchase Budget2"; Rec."Purchase Budget2")
                {
                    ApplicationArea = all;
                }

                field("GL Budget Name"; Rec."GL Budget Name")
                {
                    ApplicationArea = all;
                }

                field("G/L Account No."; Rec."G/L Account No.")
                {
                    ApplicationArea = all;
                }
                field("GL Available Budget"; Rec."GL Available Budget")
                {
                    ApplicationArea = all;
                }
                field("GL Budgeted Amount"; Rec."GL Budgeted Amount")
                {
                    ApplicationArea = all;
                }

            }
        }
    }
    actions
    {
        area(Processing)
        {
            // action(Check)
            // {
            //     ApplicationArea = suite;
            //     Caption = 'Open Page MR';
            //     Ellipsis = true;
            //     Image = Document;

            //     trigger OnAction()
            //     var
            //         MR: Record "Material Req. Header";
            //     begin
            //         MR.SetRange("Material Req. No.", REC."Material Req. No.");
            //         PAGE.RUN(50150, MR);
            //     end;
            // }
        }
    }
    trigger OnOpenPage()
    begin
        gBolEditable := TRUE;
    end;

    trigger OnAfterGetRecord()
    begin
        Rec.CalcFields(Status);
        IF Rec.Status = Rec.Status::Open THEN BEGIN
            gBolEditable := TRUE;
        END
        ELSE BEGIN
            gBolEditable := FALSE;
        END;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        lRecPRHeader: Record "PR Material Header";
    begin
        Rec.Type := Rec.Type::Item;
        if lRecPRHeader.Get(Rec."Purchase Req. No.") then begin
            // Ini yang membuat TableRelation di tabel Anda bisa langsung bekerja memfilter Item!
            Rec."Item Category Code" := lRecPRHeader."Item Category Code";
        end;
    end;

    var
        gBolEditable: Boolean;
}
