pageextension 50100 "FMD - General Jornal" extends "General Journal"
{
    actions
    {
        addafter(Category_Category9)
        {

            actionref(ImportAmp; ImportAmparex)
            {

            }

        }
        addlast("F&unctions")
        {
            action("ImportAmparex")
            {
                Caption = 'Test Of Importing Gerenal Journal Line';
                ToolTip = 'Specifies the Import Amparex Action';
                Image = Import;
                ApplicationArea = All;
                trigger OnAction()
                var
                    GenJournalFunctions: Codeunit "FMD - GenJournalFunctions";
                begin
                    GenJournalFunctions.ImportCSVFile(Rec);
                end;
            }
        }
    }

}
