page 51107 "Query Formula Lookup TPE"
{
    ApplicationArea = All;
    Caption = 'Parameters';
    PageType = List;
    SourceTable = "Query Formula TPE";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Code"; Rec."Code")
                {
                    ToolTip = 'Specifies the value of the Code field.', Comment = '%';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                }
                field("Query Type"; Rec."Query Type")
                {
                    ToolTip = 'Specifies the value of the Query Type field.', Comment = '%';
                }
                field("Table Name"; Rec."Table Name")
                {
                    ToolTip = 'Specifies the value of the Table Name field.', Comment = '%';
                }
            }
        }
    }
}