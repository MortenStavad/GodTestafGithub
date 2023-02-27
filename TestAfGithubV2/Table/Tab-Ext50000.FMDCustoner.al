tableextension 50000 "FMD - Custoner" extends Customer
{
    fields
    {
        field(50000; "Name 3"; Text[100])
        {
            Caption = 'Name 3';
            DataClassification = ToBeClassified;
        }
    }
}
