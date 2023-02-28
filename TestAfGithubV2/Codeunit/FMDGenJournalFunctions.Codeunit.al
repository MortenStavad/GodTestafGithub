codeunit 50100 "FMD - GenJournalFunctions"
{
    internal procedure ImportCSVFile(var GenJournalLine: Record "Gen. Journal Line")
    var
        TempCSVBuffer: Record "CSV Buffer" temporary;
        FileName: Text;
        InS: InStream;
        i: Integer;
        MyDialog: Dialog;
    begin
        if UploadIntoStream('Choose File', '', '', FileName, Ins) then begin
            TempCSVBuffer.LoadDataFromStream(Ins, ';');
            TempCSVBuffer.SetFilter("Line No.", '2..');
            TempCSVBuffer.SetFilter("Field No.", '2..');
            if TempCSVBuffer.FindSet(true, true) then
                repeat
                    MyDialog.Open('Arbejder med Object #1####### #2##### working...');
                    for i := 1 to 50000 do begin
                        CreateGenJorunalLine(TempCSVBuffer, GenJournalLine, TempCSVBuffer."Line No.");
                        MyDialog.Update(1, i);
                    end;
                until TempCSVBuffer.Next() = 0;


        end;
    end;

    local procedure CreateGenJorunalLine(var CSVBuffer: Record "CSV Buffer"; Var GenJournalLine: Record "Gen. Journal Line"; BufferLineNo: Integer)
    var
        Customer: Record Customer;
        GenJournalLine1: Record "Gen. Journal Line";
        BufferValue: Text;
        ShortcutDimValue: Text;
        BalAccountNo: Text;
    begin
        GenJournalLine1.Init();
        GenJournalLine1.Validate("Journal Template Name", GenJournalLine."Journal Template Name");
        GenJournalLine1.Validate("Journal Batch Name", GenJournalLine."Journal Batch Name");
        GenJournalLine1.Validate("Line No.", GetNextLineNo(GenJournalLine));
        GenJournalLine1.Insert(true);
        If CSVBuffer.Get(BufferLineNo, 2) then begin
            BufferValue := CSVBuffer.Value;
            if CSVBuffer.Get(BufferLineNo, 16) then
                ShortcutDimValue := CSVBuffer.Value;
            BufferValue := CheckAccountNo(BufferValue, ShortcutDimValue);
            if Customer.Get(BufferValue) then
                GenJournalLine1.Validate("Account Type", GenJournalLine1."Account Type"::Customer) else
                GenJournalLine1.Validate("Account Type", GenJournalLine1."Account Type"::"G/L Account");
            GenJournalLine1.Validate("Account No.", BufferValue);

        end;
        if CSVBuffer.Get(BufferLineNo, 3) then begin
            BufferValue := CSVBuffer.Value;
            Clear(Customer);
            BufferValue := CheckAccountNo(BufferValue, ShortcutDimValue);
            if Customer.Get(BufferValue) then
                GenJournalLine1.Validate("Bal. Account Type", GenJournalLine1."Bal. Account Type"::Customer) else
                GenJournalLine1.Validate("Bal. Account Type", GenJournalLine1."Bal. Account Type"::"G/L Account");
            GenJournalLine1.Validate("Bal. Account No.", BufferValue);
        end;

        if CSVBuffer.Get(BufferLineNo, 4) then begin
            BufferValue := CSVBuffer.Value;
            GenJournalLine1.Validate("Posting Date", GetDate(BufferValue));
        end;
        if CSVBuffer.Get(BufferLineNo, 5) then begin
            BufferValue := CSVBuffer.Value;
            GenJournalLine1.Validate("Document Date", GetDate(BufferValue));
        end;
        // if CSVBuffer.Get(BufferLineNo, 6) then begin
        //     BufferValue := CSVBuffer.Value;
        //     InsertDimensionAndDocumentType(BufferValue, GenJournalLine1);
        // end;
        if CSVBuffer.Get(BufferLineNo, 7) then begin
            BufferValue := CSVBuffer.Value;
            GenJournalLine1.Validate("Document No.", BufferValue);
        end;
        if CSVBuffer.Get(BufferLineNo, 9) then begin
            BufferValue := CSVBuffer.Value;
            GenJournalLine1.Validate(Description, BufferValue);
        end;
        if CSVBuffer.Get(BufferLineNo, 11) then begin
            BufferValue := CSVBuffer.Value;
            GenJournalLine1.Validate(Amount, GetDecimal(BufferValue));
        end;

        if CSVBuffer.Get(BufferLineNo, 12) then begin
            BufferValue := CSVBuffer.Value;
            GenJournalLine1.Validate("Expiration Date", GetDate(BufferValue));
        end;
        iF CSVBuffer.get(BufferLineNo, 15) then
            GenJournalLine1.Validate("Applies-to Doc. No.", CSVBuffer.Value);

        GenJournalLine1.Validate("Shortcut Dimension 1 Code", ShortcutDimValue);
        GenJournalLine1.Modify(true);
    end;

    local procedure GetNextLineNo(var GenJournalLine: Record "Gen. Journal Line"): Integer
    var
        GenJournalLine1: Record "Gen. Journal Line";
        LineNo2: Integer;
    begin
        GenJournalLine1.SetRange("Journal Template Name", GenJournalLine."Journal Template Name");
        GenJournalLine1.SetRange("Journal Batch Name", GenJournalLine."Journal Batch Name");
        if GenJournalLine1.FindLast() then
            LineNo2 := GenJournalLine1."Line No." + 10000
        else
            LineNo2 := 10000;
        exit(LineNo2)
    end;

    local procedure GetDate(Buffervalue: Text): Date
    var
        D: Date;
        TextValue: Text;
    begin
        TextValue := COPYSTR(Buffervalue, 7, 2) + COPYSTR(Buffervalue, 5, 2) + COPYSTR(Buffervalue, 1, 4);
        Evaluate(D, TextValue);
        exit(D);
    end;

    local procedure GetDecimal(Buffervalue: Text): Decimal
    var
        DecimalValue: Decimal;
        TextValue: Text;
    begin
        TextValue := ConvertStr(Buffervalue, '.', ',');
        Evaluate(DecimalValue, TextValue);
        exit(DecimalValue);
    end;

    // local procedure InsertDimensionAndDocumentType(CSVBufferValue: Text; Var GenJournalLine: Record "Gen. Journal Line")
    // var

    // begin
    //     if (CSVBufferValue = 'F') or (CSVBufferValue = 'K') then
    //         GenJournalLine.Validate("Document Type", GenJournalLine."Document Type"::Invoice)
    //     else
    //         if CSVBufferValue = 'B' then
    //             GenJournalLine.Validate("Document Type", GenJournalLine."Document Type"::Payment)
    //         else
    //             GenJournalLine.Validate("Document Type", GenJournalLine."Document Type"::"Credit Memo");
    // end;

    local procedure CheckAccountNo(BufferValue: Text; ShortcutDimValue: Text): Text
    var
        AmparexAccountNoTrans: Record "Amparex Account No. Trans";

    begin
        if AmparexAccountNoTrans.Get(BufferValue, ShortcutDimValue) then
            BufferValue := AmparexAccountNoTrans."BC Account No";
        exit(BufferValue);
    end;

    var
}

