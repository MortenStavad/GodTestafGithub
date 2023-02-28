permissionset 50000 Test_PermissionSet
{
    Assignable = true;
    Caption = 'Test_PermissionSet', MaxLength = 30;
    Permissions =
        table "Amparex Account No. Trans" = X,
        tabledata "Amparex Account No. Trans" = RMID,
        codeunit "FMD - GenJournalFunctions" = X;
}
