report 50105 "RFQ Printout"
{
    DefaultRenderingLayout = "RFQ Printout";
    UsageCategory = Documents;
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem("RFQ Header"; "RFQ Header")
        {
            RequestFilterFields = "RFQ No.";

            column(CompanyName; gRecCompany.Name)
            {
            }
            column(CompanyPicture; gRecCompany.Picture)
            {
            }
            column(Document_No; "RFQ No.")
            {
            }
            column(Document_Date; "Document Date")
            {
            }
            column(PRNo; gPRNo)
            {
            }
            column(Peruntukan; Remarks)
            {
            }
            column(Location_Code; "Location Code")
            {
            }
            column(VendorName1; gTxtVendorName[1])
            {
            }
            column(VendorName2; gTxtVendorName[2])
            {
            }
            column(VendorName3; gTxtVendorName[3])
            {
            }
            column(VendorAddress1; gTxtVendorAddress[1])
            {
            }
            column(VendorAddress2; gTxtVendorAddress[2])
            {
            }
            column(VendorAddress3; gTxtVendorAddress[3])
            {
            }
            column(ShippingDate1; gShippingDate[1])
            {
            }
            column(ShippingDate2; gShippingDate[2])
            {
            }
            column(ShippingDate3; gShippingDate[3])
            {
            }
            column(PaymentTerms1; gTxtPaymenTerms[1])
            {
            }
            column(PaymentTerms2; gTxtPaymenTerms[2])
            {
            }
            column(PaymentTerms3; gTxtPaymenTerms[3])
            {
            }
            column(ShiptoName1; gTxtShiptoName[1])
            {
            }
            column(ShiptoName2; gTxtShiptoName[2])
            {
            }
            column(ShiptoName3; gTxtShiptoName[3])
            {
            }
            column(ShipmentMethod1; gTxtShipmentMethod[1])
            {
            }
            column(ShipmentMethod2; gTxtShipmentMethod[2])
            {
            }
            column(ShipmentMethod3; gTxtShipmentMethod[3])
            {
            }
            column(VendorPhoneNo1; gTxtVendorPhone[1])
            {
            }
            column(VendorPhoneNo2; gTxtVendorPhone[2])
            {
            }
            column(VendorPhoneNo3; gTxtVendorPhone[3])
            {
            }
            column(SyaratPembayaran1; gSyaratPembayaran[1])
            {
            }
            column(SyaratPembayaran2; gSyaratPembayaran[2])
            {
            }
            column(SyaratPembayaran3; gSyaratPembayaran[3])
            {
            }
            column(gDuplicate; gDuplicate)
            {
            }
            dataitem("RFQ Line"; "RFQ Line")
            {
                DataItemLink = "RFQ No." = field("RFQ No.");


                column(gRowNo; gRowNo)
                {
                }
                column(No_; "No.")
                {
                }
                column(Type; Type)
                {
                }
                column(Description; Description)
                {
                }
                column(Quantity; gQty)
                {
                }
                column(UnitofMeasure; "Unit of Measure")
                {
                }
                column(LastVendorName; gLastVendorName)
                {
                }
                column(LastPostingDate; gLastPostingDate)
                {
                }
                column(LastUnitCost; gLastUnitCost)
                {
                }
                column(LastPINo; gLastPINo)
                {
                }
                column(UnitPrice1; gDecUnitPrice[1])
                {
                }
                column(UnitPrice2; gDecUnitPrice[2])
                {
                }
                column(UnitPrice3; gDecUnitPrice[3])
                {
                }
                column(Unit_Price_Service1; gDecUnitPriceService[1])
                {
                }
                column(Unit_Price_Service2; gDecUnitPriceService[2])
                {
                }
                column(Unit_Price_Service3; gDecUnitPriceService[3])
                {
                }
                column(Discount1; gDecDisc[1])
                {
                }
                column(Discount2; gDecDisc[2])
                {
                }
                column(Discount3; gDecDisc[3])
                {
                }
                column(Line_Amount1; gDecLineAmount[1])
                {
                }
                column(Line_Amount2; gDecLineAmount[2])
                {
                }
                column(Line_Amount3; gDecLineAmount[3])
                {
                }
                column(SubTotal1; gDecSubTotal[1])
                {
                }
                column(SubTotal2; gDecSubTotal[2])
                {
                }
                column(SubTotal3; gDecSubTotal[3])
                {
                }
                column(VAT1; gDecVAT[1])
                {
                }
                column(VAT2; gDecVAT[2])
                {
                }
                column(VAT3; gDecVAT[3])
                {
                }
                column(WHT1; gDecWHT[1])
                {
                }
                column(WHT2; gDecWHT[2])
                {
                }
                column(WHT3; gDecWHT[3])
                {
                }
                column(PPH2_1; gDecPPH22[1])
                {
                }
                column(PPH2_2; gDecPPH22[2])
                {
                }
                column(PPH2_3; gDecPPH22[3])
                {
                }
                column(PBBKB_1; gDecPBBKB[1])
                {
                }
                column(PBBKB_2; gDecPBBKB[2])
                {
                }
                column(PBBKB_3; gDecPBBKB[3])
                {
                }
                column(Total_Amount1; gDecTotalAmount[1])
                {
                }
                column(Total_Amount2; gDecTotalAmount[2])
                {
                }
                column(Total_Amount3; gDecTotalAmount[3])
                {
                }
                column(Keterangan1; gRemarks[1])
                {
                }
                column(Keterangan2; gRemarks[2])
                {
                }
                column(Keterangan3; gRemarks[3])
                {
                }
                column(gWinBol1; gWinBol[1])
                {
                }
                column(gWinBol2; gWinBol[2])
                {
                }
                column(gWinBol3; gWinBol[3])
                {
                }
                column(isShippingCharge; gisShippingCharge)
                {
                }
                trigger OnPreDataItem()
                begin
                    "RFQ Line".SETCURRENTKEY("No.");
                    "RFQ Line".ASCENDING(TRUE);
                end;

                trigger OnAfterGetRecord()
                var
                    lRecRFQDet: Record "RFQ Line Details";
                    lRecRFQVendor: Record "RFQ Vendor List";
                    lRecRFQLine: Record "RFQ Line";
                    lRecPInvHeader: Record "Purch. Inv. Header";
                    lRecPInvLine: Record "Purch. Inv. Line";
                    lRecVendor: Record Vendor;
                    lRecGLAccount: Record "G/L Account";
                    currArray: Integer;
                    isShip: Boolean;
                    TotalLineAmount: Decimal;
                    LineAmount: Decimal;
                    DiscAmount: Decimal;
                    currNoShip: Code[20];
                begin
                    CLEAR(gLastPostingDate);
                    CLEAR(gLastUnitCost);
                    CLEAR(gLastVendorName);
                    CLEAR(gLastPINo);
                    gisShippingCharge := FALSE;
                    gDuplicate := TRUE;
                    IF "RFQ Line"."Purchase Req. No." = '' THEN BEGIN
                        CASE "RFQ Line".Type OF
                            "RFQ Line".Type::Item:
                                BEGIN
                                    IF gCUMSIFunct.checkItemisShippingCharge("RFQ Line"."No.") THEN BEGIN
                                        gisShippingCharge := TRUE;
                                    END
                                    ELSE BEGIN
                                        gisShippingCharge := FALSE;
                                    END;
                                END;
                            "RFQ Line".Type::"G/L Account":
                                BEGIN
                                    IF gCUMSIFunct.checkGLisShippingCharge("RFQ Line"."No.") THEN BEGIN
                                        gisShippingCharge := TRUE;
                                    END
                                    ELSE BEGIN
                                        gisShippingCharge := FALSE;
                                    END;
                                END;
                            "RFQ Line".Type::"Charge (Item)":
                                BEGIN
                                    IF gCUMSIFunct.checkItemChargeisShippingCharge("RFQ Line"."No.") THEN BEGIN
                                        gisShippingCharge := TRUE;
                                    END
                                    ELSE BEGIN
                                        gisShippingCharge := FALSE;
                                    END;
                                END;
                        END;
                    END
                    ELSE BEGIN
                        CASE "RFQ Line".Type OF
                            "RFQ Line".Type::Item:
                                BEGIN
                                    IF gCUMSIFunct.checkItemisShippingCharge("RFQ Line"."No.") THEN BEGIN
                                        gisShippingCharge := TRUE;
                                    END
                                    ELSE BEGIN
                                        gisShippingCharge := FALSE;
                                    END;
                                END;
                            "RFQ Line".Type::"G/L Account":
                                BEGIN
                                    IF gCUMSIFunct.checkGLisShippingCharge("RFQ Line"."No.") THEN BEGIN
                                        gisShippingCharge := TRUE;
                                    END
                                    ELSE BEGIN
                                        gisShippingCharge := FALSE;
                                    END;
                                END;
                        END;
                    END;
                    currArray := 1;
                    IF gCurrNo <> "RFQ Line"."No." THEN BEGIN
                        CLEAR(gQty);
                        gDuplicate := FALSE;
                        lRecRFQLine.RESET;
                        lRecRFQLine.SETRANGE(lRecRFQLine."RFQ No.", "RFQ Header"."RFQ No.");
                        lRecRFQLine.SETRANGE(lRecRFQLine."No.", "RFQ Line"."No.");
                        IF lRecRFQLine.FIND('-') THEN BEGIN
                            lRecRFQLine.CalcSums(Quantity);
                            gQty := lRecRFQLine.Quantity;
                        END;
                        IF gisShippingCharge = FALSE THEN gRowNo += 1;
                        getWinnerBol();
                    END;
                    lRecRFQVendor.RESET;
                    lRecRFQVendor.SETRANGE(lRecRFQVendor."RFQ No.", "RFQ Line"."RFQ No.");
                    lRecRFQVendor.SETCURRENTKEY("Entry No. RFQ Vendor");
                    lRecRFQVendor.ASCENDING(TRUE);
                    IF lRecRFQVendor.FIND('-') THEN BEGIN
                        REPEAT
                            IF currHeader = 1 THEN BEGIN
                                CLEAR(TotalLineAmount);
                                CLEAR(currNoShip);
                                lRecVendor.RESET;
                                lRecVendor.GET(lRecRFQVendor."Vendor No.");
                                gTxtVendorName[currArray] := lRecRFQVendor."Vendor Name";
                                gTxtVendorAddress[currArray] := lRecVendor.Address;
                                gTxtVendorPhone[currArray] := lRecVendor."Phone No.";
                                gShippingDate[currArray] := lRecRFQVendor."Shipping Date";
                                gTxtShiptoName[currArray] := lRecRFQVendor."Ship-to Name";
                                gTxtPaymenTerms[currArray] := lRecRFQVendor."Payment Terms Name";
                                gTxtShipmentMethod[currArray] := lRecRFQVendor."Shipment Method Name";
                                //gSyaratPembayaran[currArray]:=lRecRFQVendor."Syarat Pembayaran";
                                //gDecDisc[currArray]+=lRecRFQVendor."Discount Vendor Amount";
                                lRecRFQLine.RESET;
                                lRecRFQLine.SetCurrentKey("No.");
                                lRecRFQLine.SETRANGE(lRecRFQLine."RFQ No.", "RFQ Header"."RFQ No.");
                                lRecRFQLine.ASCENDING(TRUE);
                                IF lRecRFQLine.FIND('-') THEN BEGIN
                                    REPEAT
                                        isShip := FALSE;
                                        IF lRecRFQLine."Purchase Req. No." = '' THEN BEGIN
                                            CASE lRecRFQLine.Type OF
                                                lRecRFQLine.Type::Item:
                                                    BEGIN
                                                        IF gCUMSIFunct.checkItemisShippingCharge(lRecRFQLine."No.") THEN BEGIN
                                                            isShip := TRUE;
                                                        END
                                                        ELSE BEGIN
                                                            isShip := FALSE;
                                                        END;
                                                    END;
                                                lRecRFQLine.Type::"G/L Account":
                                                    BEGIN
                                                        IF gCUMSIFunct.checkGLisShippingCharge(lRecRFQLine."No.") THEN BEGIN
                                                            isShip := TRUE;
                                                        END
                                                        ELSE BEGIN
                                                            isShip := FALSE;
                                                        END;
                                                    END;
                                                lRecRFQLine.Type::"Charge (Item)":
                                                    BEGIN
                                                        IF gCUMSIFunct.checkItemChargeisShippingCharge(lRecRFQLine."No.") THEN BEGIN
                                                            isShip := TRUE;
                                                        END
                                                        ELSE BEGIN
                                                            isShip := FALSE;
                                                        END;
                                                    END;
                                            END;
                                        END
                                        ELSE BEGIN
                                            CASE lRecRFQLine.Type OF
                                                lRecRFQLine.Type::Item:
                                                    BEGIN
                                                        IF gCUMSIFunct.checkItemisShippingCharge(lRecRFQLine."No.") THEN BEGIN
                                                            isShip := TRUE;
                                                        END
                                                        ELSE BEGIN
                                                            isShip := FALSE;
                                                        END;
                                                    END;
                                                lRecRFQLine.Type::"G/L Account":
                                                    BEGIN
                                                        IF gCUMSIFunct.checkGLisShippingCharge(lRecRFQLine."No.") THEN BEGIN
                                                            isShip := TRUE;
                                                        END
                                                        ELSE BEGIN
                                                            isShip := FALSE;
                                                        END;
                                                    END;
                                            END;
                                        END;
                                        lRecRFQDet.RESET;
                                        lRecRFQDet.SETRANGE(lRecRFQDet."RFQ No.", lRecRFQLine."RFQ No.");
                                        lRecRFQDet.SETRANGE(lRecRFQDet."No.", lRecRFQLine."No.");
                                        lRecRFQDet.SETRANGE(lRecRFQDet."Entry No. RFQ Vendor", lRecRFQVendor."Entry No. RFQ Vendor");
                                        IF lRecRFQDet.FIND('-') THEN BEGIN
                                            CLEAR(LineAmount);
                                            CLEAR(DiscAmount);
                                            lRecRFQDet.CalcFields("VAT %");
                                            IF isShip = FALSE THEN BEGIN
                                                DiscAmount := (lRecRFQLine.Quantity * lRecRFQDet."Unit Price") * (lRecRFQDet."Discount %" / 100);
                                                LineAmount := (lRecRFQLine.Quantity * lRecRFQDet."Unit Price") - DiscAmount;
                                                TotalLineAmount += LineAmount;
                                                gDecDisc[currArray] += DiscAmount;
                                                gDecVAT[currArray] += lRecRFQLine.Quantity * lRecRFQDet."VAT Amount";
                                                IF lRecRFQDet."PPH 22" THEN BEGIN
                                                    //gDecPPH22[currArray]+=gCUMSIFunct.getPPH22(LineAmount, lRecVendor."WHT Business Posting Group");
                                                END
                                                ELSE BEGIN
                                                    gDecWHT[currArray] += (LineAmount) / 100;
                                                END;

                                            END
                                            ELSE BEGIN
                                                IF currNoShip <> lRecRFQLine."No." THEN BEGIN
                                                    gDecUnitPriceService[currArray] += lRecRFQLine.Quantity * lRecRFQDet."Total Amount";
                                                END;
                                            END;
                                            gDecTotalAmount[currArray] := (TotalLineAmount + gDecUnitPriceService[currArray] + gDecVAT[currArray] + gDecPPH22[currArray] + gDecPBBKB[currArray] - gDecWHT[CurrArray]);
                                        END;
                                        currNoShip := lRecRFQLine."No.";
                                    UNTIL lRecRFQLine.NEXT = 0;
                                END;
                            END;
                            lRecPInvLine.RESET;
                            lRecPInvLine.SETRANGE(lRecPInvLine.Type, "RFQ Line".Type);
                            lRecPInvLine.SETRANGE(lRecPInvLine."No.", "RFQ Line"."No.");
                            IF lRecPInvLine.FINDLAST THEN BEGIN
                                gLastUnitCost := lRecPInvLine."Direct Unit Cost";
                                gLastPINo := lRecPInvLine."Document No.";
                                lRecPInvHeader.RESET;
                                lRecPInvHeader.SETRANGE("No.", lRecPInvLine."Document No.");
                                IF lRecPInvHeader.FINDFIRST THEN BEGIN
                                    gLastPostingDate := lRecPInvHeader."Posting Date";
                                    gLastVendorName := lRecPInvHeader."Buy-from Vendor Name";
                                END;
                            END;
                            CLEAR(LineAmount);
                            CLEAR(DiscAmount);
                            lRecRFQDet.RESET;
                            lRecRFQDet.SETRANGE(lRecRFQDet."RFQ No.", "RFQ Line"."RFQ No.");
                            lRecRFQDet.SETRANGE(lRecRFQDet."No.", "RFQ Line"."No.");
                            lRecRFQDet.SETRANGE(lRecRFQDet."Entry No. RFQ Vendor", lRecRFQVendor."Entry No. RFQ Vendor");
                            IF lRecRFQDet.FIND('-') THEN BEGIN
                                IF gisShippingCharge = FALSE THEN BEGIN
                                    DiscAmount := ("RFQ Line".Quantity * lRecRFQDet."Unit Price") * (lRecRFQDet."Discount %" / 100);
                                    LineAmount := ("RFQ Line".Quantity * lRecRFQDet."Unit Price") - DiscAmount;
                                    gDecUnitPrice[currArray] := lRecRFQDet."Unit Price";
                                    gDecLineAmount[currArray] := gQty * lRecRFQDet."Unit Price";
                                    gDecSubTotal[currArray] += "RFQ Line".Quantity * lRecRFQDet."Unit Price";
                                    gRemarks[currArray] := lRecRFQDet.Remarks;
                                END;
                            END
                            ELSE BEGIN
                                gDecUnitPrice[currArray] := 0;
                                gDecLineAmount[currArray] := 0;
                                gDecSubTotal[currArray] += 0;
                                gRemarks[currArray] := '';
                            END;
                            currArray += 1;
                        UNTIL lRecRFQVendor.NEXT = 0;
                    END;
                    currHeader += 1;
                    gCurrNo := "RFQ Line"."No.";
                end;


            }


            trigger OnAfterGetRecord()
            begin
                gPRNo := getPRNo();
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
        layout("RFQ Printout")
        {
            Type = RDLC;
            LayoutFile = 'Report/Layout/vensel - Landscape.rdl';
        }
    }
    procedure getPRNo(): Text
    var
        lRecRFQLine: Record "RFQ Line";
        currPRNo: Code[20];
        lPRNo: Text;
        i: integer;
        firstrecord: Boolean;
    begin
        i := 0;
        firstrecord := TRUE;
        lRecRFQLine.RESET;
        lRecRFQLine.SETRANGE(lRecRFQLine."RFQ No.", "RFQ Header"."RFQ No.");
        lRecRFQLine.SETCURRENTKEY(lRecRFQLine."Purchase Req. No.");
        lRecRFQLine.ASCENDING(TRUE);
        IF lRecRFQLine.FIND('-') THEN BEGIN
            REPEAT
                IF currPRNo <> lRecRFQLine."Purchase Req. No." THEN BEGIN
                    IF firstrecord THEN BEGIN
                        lPRNo := lRecRFQLine."Purchase Req. No.";
                        firstrecord := FALSE;
                    END
                    ELSE BEGIN
                        lPRNo := lPRNo + ',' + lRecRFQLine."Purchase Req. No.";
                    END;
                    i += 1;
                END;
                currPRNo := lRecRFQLine."Purchase Req. No.";
            UNTIL (lRecRFQLine.NEXT = 0) OR (i = 7);
        END;
        EXIT(lPRNo);
    end;

    procedure getWinnerBol()
    var
        lRecRFQVendor: Record "RFQ Vendor List";
        lRecRFQLine: Record "RFQ Line";
        array: integer;
    begin
        array := 1;
        lRecRFQVendor.RESET;
        lRecRFQVendor.SETRANGE(lRecRFQVendor."RFQ No.", "RFQ Line"."RFQ No.");
        lRecRFQVendor.SETCURRENTKEY("Entry No. RFQ Vendor");
        lRecRFQVendor.ASCENDING(TRUE);
        IF lRecRFQVendor.FIND('-') THEN BEGIN
            REPEAT
                lRecRFQLine.RESET;
                lRecRFQLine.SETRANGE(lRecRFQLine."RFQ No.", "RFQ Header"."RFQ No.");
                lRecRFQLine.SETRANGE(lRecRFQLine."No.", "RFQ Line"."No.");
                lRecRFQLine.SETRANGE(lRecRFQLine."Vendor No.", lRecRFQVendor."Vendor No.");
                IF lRecRFQLine.FINDFIRST THEN BEGIN
                    gWinBol[array] := TRUE;
                END
                ELSE BEGIN
                    gWinBol[array] := FALSE;
                END;
                array += 1;
            UNTIL lRecRFQVendor.NEXT = 0;
        END;
    end;

    trigger OnInitReport()
    begin
        gRecCompany.GET();
        gRecCompany.CalcFields(Picture);
        currHeader := 1;
        gRecMSISetup.GET();
        gRowNo := 0;
    end;

    trigger OnPostReport()
    begin
    end;

    var
        gRecCompany: Record "Company Information";
        gRecRFQDet: Record "RFQ Line Details";
        gRecMSISetup: Record "MII Setup";
        gCUMSIFunct: Codeunit "MII Function";
        gTxtVendorName, gTxtVendorAddress, gTxtVendorPhone, gTxtPaymenTerms, gRemarks : Array[3] of Text;
        gTxtShiptoName, gTxtShipmentMethod, gSyaratPembayaran : Array[3] of Text;
        gDecUnitPrice, gDecLineAmount, gDecSubTotal, gDecDisc, gDecTotalPrice : Array[3] of Decimal;
        gDecVAT, gDecWHT, gDecTotalAmount, gDecUnitPriceService, gDecPBBKB, gDecPPH22 : Array[3] of Decimal;
        gShippingDate: Array[3] of Date;
        gWinBol: Array[3] of Boolean;
        gPRNo: Text[250];
        gLastPINo, gCurrNo : Code[20];
        gLastVendorName: Text[100];
        gisShippingCharge: Boolean;
        gLastPostingDate: Date;
        currHeader, gRowNo : Integer;
        gLastUnitCost, gQty : Decimal;
        gDuplicate: Boolean;
}
