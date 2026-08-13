codeunit 50111 "MII Function"
{
    trigger OnRun()
    begin
    end;

    procedure getNoSeriesGenProd_Location(parGenProd: Code[20]; parLocation: Code[20]; parTypeInt: Integer): Code[20]
    var
        lRecNoSeries: Record "No. Series";
    begin
        lRecNoSeries.RESET;
        lRecNoSeries.SETRANGE("Gen. Prod. Posting Group", parGenProd);
        lRecNoSeries.SETRANGE("Location Code", parLocation);
        CASE parTypeInt OF
            1:
                lRecNoSeries.SETRANGE("Type Posted No. Series", lRecNoSeries."Type Posted No. Series"::"Invt. Shipment");
            2:
                lRecNoSeries.SETRANGE("Type Posted No. Series", lRecNoSeries."Type Posted No. Series"::"Purchase Order");
        END;
        IF lRecNoSeries.FINDFIRST THEN BEGIN
            exit(lRecNoSeries.Code);
        END;
        exit('');
    end;

    procedure checkItemisShippingCharge(parNo: Code[20]): Boolean
    var
        lRecItem: Record "Item";
    begin
        lRecItem.RESET;
        lRecItem.SETRANGE("No.", parNo);
        IF lRecItem.FINDFIRST THEN BEGIN
            //EXIT(lRecItem."is Expense");
        END;
        EXIT(FALSE);
    end;

    procedure checkGLisShippingCharge(parNo: Code[20]): Boolean
    var
        lRecGLAccount: Record "G/L Account";
    begin
        lRecGLAccount.RESET;
        lRecGLAccount.SETRANGE("No.", parNo);
        IF lRecGLAccount.FINDFIRST THEN BEGIN
            EXIT(lRecGLAccount."Shipping Charge RFQ");
        END;
        EXIT(FALSE);
    end;

    procedure checkItemChargeisShippingCharge(parNo: Code[20]): Boolean
    var
        lRecItemCharge: Record "Item Charge";
    begin
        lRecItemCharge.RESET;
        lRecItemCharge.SETRANGE("No.", parNo);
        IF lRecItemCharge.FINDFIRST THEN BEGIN
            EXIT(lRecItemCharge."Shipping Charge RFQ");
        END;
        EXIT(FALSE);
    end;


    procedure GetFullNameUserIDGUID(userID: Guid): Text
    var
        lRecUser: Record User;
    begin
        if lRecUser.Get(userID) then begin
            exit(lRecUser."Full Name");
        end
        else begin
            exit('');
        end;
    end;

    // procedure getUnitGroupDimension(DimNo: Integer; DimCode: Code[20]): Code[50]
    // var
    //     lRecDimVal: Record "Dimension Value";
    // begin
    //     lRecDimVal.RESET;
    //     lRecDimVal.SETRANGE(Blocked, FALSE);
    //     lRecDimVal.SETRANGE("Global Dimension No.", DimNo);
    //     lRecDimVal.SETRANGE(Code, DimCode);
    //     IF lRecDimVal.FINDFIRST THEN BEGIN
    //         exit(lRecDimVal."Unit Group Dimension");
    //     END;
    //     exit('');
    // end;

    procedure getGenBusfromMapping(parDim1: Code[20]; parUnitGroup: Code[50]; parCategory: Code[50]): Code[20]
    var
        lRecMapping: Record "Mapping COA Expense";
    begin
        lRecMapping.RESET;
        lRecMapping.SETRANGE("Shortcut Dimension 1 Code", parDim1);
        lRecMapping.SETRANGE("Unit Group Dimension", parUnitGroup);
        lRecMapping.SETRANGE("MR Usage Category", parCategory);
        IF lRecMapping.FINDFIRST THEN BEGIN
            exit(lRecMapping."Gen Bus. Posting Group");
        END
        ELSE BEGIN
            IF (parDim1 <> '') AND (parUnitGroup <> '') AND (parCategory <> '') THEN BEGIN
                ERROR('Gen Bus. Posting Group is not found in Mapping COA Expense');
            END
            ELSE BEGIN
                IF (parDim1 <> '') AND (parCategory <> '') THEN IF parUnitGroup = '' THEN ERROR('Gen Bus. Posting Group is not found in Mapping COA Expense');
            END;
        END;
        exit('');
    end;

    procedure getInvCOAfromMapping(parDim1: Code[20]; parUnitGroup: Code[50]; parCategory: Code[50]; parGenBus: Code[20]; parGenProd: Code[20]): Code[20]
    var
        lRecMapping: Record "Mapping COA Expense";
    begin
        lRecMapping.RESET;
        lRecMapping.SETRANGE("Shortcut Dimension 1 Code", parDim1);
        lRecMapping.SETRANGE("Unit Group Dimension", parUnitGroup);
        lRecMapping.SETRANGE("MR Usage Category", parCategory);
        lRecMapping.SETRANGE("Gen Bus. Posting Group", parGenBus);
        lRecMapping.SETRANGE("Gen Prod. Posting Group", parGenProd);
        IF lRecMapping.FINDFIRST THEN BEGIN
            exit(lRecMapping."Inventory Adjmt. Account");
        END
        ELSE BEGIN
            ERROR('Inventory Adjmt. Account is not found in Mapping COA Expense');
        END;
        exit('');
    end;

    procedure getPurchPrice(var parVendorNo: Code[20]; var parItemNo: Code[20]; var parDate: Date): Decimal
    var
        lRecPriceLine: Record "Price List Line";
    begin
        lRecPriceLine.RESET;
        lRecPriceLine.SETRANGE(lRecPriceLine."Asset Type", lRecPriceLine."Asset Type"::Item);
        lRecPriceLine.SETRANGE(lRecPriceLine."Product No.", parItemNo);
        lRecPriceLine.SETFILTER(lRecPriceLine."Starting Date", '<=%1', parDate);
        lRecPriceLine.SETFILTER(lRecPriceLine."Ending Date", '>=%1', parDate);
        lRecPriceLine.SETRANGE(lRecPriceLine."Assign-to No.", parVendorNo);
        IF lRecPriceLine.FINDFIRST THEN exit(lRecPriceLine."Direct Unit Cost");
        lRecPriceLine.RESET;
        lRecPriceLine.SETRANGE(lRecPriceLine."Asset Type", lRecPriceLine."Asset Type"::Item);
        lRecPriceLine.SETRANGE(lRecPriceLine."Product No.", parItemNo);
        lRecPriceLine.SETFILTER(lRecPriceLine."Starting Date", '<=%1', parDate);
        lRecPriceLine.SETFILTER(lRecPriceLine."Ending Date", '>=%1', parDate);
        lRecPriceLine.SETRANGE(lRecPriceLine."Source Type", lRecPriceLine."Source Type"::"All Vendors");
        IF lRecPriceLine.FINDFIRST THEN exit(lRecPriceLine."Direct Unit Cost");
        exit(0);
    end;
}
