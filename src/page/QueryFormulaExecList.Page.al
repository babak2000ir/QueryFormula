page 51106 "Query Formula Exec. List TPE"
{
    ApplicationArea = All;
    Caption = 'Query Formula Execution List';
    CardPageId = "Query Formula Exec. Card TPE";
    PageType = List;
    SourceTable = "Query Formula Execution TPE";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}