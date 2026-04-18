page 51112 "Log List TPE"
{
    ApplicationArea = All;
    Caption = 'Log List';
    Editable = false;
    PageType = List;
    SourceTable = "Query Execution Log TPE";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Message"; Rec.Message)
                {
                    ToolTip = 'Specifies the value of the Message field.', Comment = '%';
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedAt field.', Comment = '%';
                }
                field(SystemCreatedBy; CreateByUserId)
                {
                    Caption = 'Created By';
                    ToolTip = 'Specifies the value of the SystemCreatedBy field.', Comment = '%';
                }
            }
        }
    }

    var
        CreateByUserId: Text[80];

    trigger OnAfterGetRecord()
    var
        User: Record User;
    begin
        CreateByUserId := '';
        if User.get(Rec.SystemCreatedBy) then
            CreateByUserId := User."Full Name";
    end;
}