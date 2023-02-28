table 50100 "Amparex Account No. Trans"
{
    Caption = 'Amparex Account No. Trans';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Account No"; Code[20])
        {
            Caption = 'Account No';
            DataClassification = ToBeClassified;
        }
        field(2; ShortCutDimension; Code[20])
        {
            Caption = 'ShortCutDimension';
            DataClassification = ToBeClassified;
        }
        field(3; "BC Account No"; Code[20])
        {
            Caption = 'BC Account No';
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account"."No.";
        }
    }
    keys
    {
        key(PK; "Account No", ShortCutDimension)
        {
            Clustered = true;
        }
    }
}
