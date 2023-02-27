pageextension 50000 "FMD - Customer" extends "Customer Card"
{
    layout
    {
        addafter("Name 2")
        {
            field("Name 3"; Rec."Name 3")
            {

            }
        }
    }
}
