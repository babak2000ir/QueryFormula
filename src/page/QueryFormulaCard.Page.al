page 51101 "Query Formula Card TPE"
{
    ApplicationArea = All;
    Caption = 'Query Formula Card';
    PageType = Card;
    SourceTable = "Query Formula TPE";

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Code"; Rec.Code)
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
            }
            part(Parameters; "Query Formula Param Sub TPE")
            {
                ApplicationArea = All;
                Caption = 'Parameters';
                SubPageLink = "Query Formula Code" = field(Code);
            }
            group("Table")
            {
                Caption = 'Table';
                field("Table ID"; Rec."Table ID")
                {
                    ApplicationArea = All;
                }
                field("Table Name"; Rec."Table Name")
                {
                    ApplicationArea = All;
                }
            }
            part(Filters; "Query Formula Filter Sub TPE")
            {
                ApplicationArea = All;
                Caption = 'Filters';
                SubPageLink = "Query Formula Code" = field(Code);
            }
            group(Result)
            {
                Caption = 'Result';
                field("Query Type"; Rec."Query Type")
                {
                    ApplicationArea = All;
                }
                field("Field ID"; Rec."Field ID")
                {
                    ApplicationArea = All;
                    Visible = Rec."Query Type" <> Rec."Query Type"::Count;
                }
                field("Field Name"; Rec."Field Name")
                {
                    ApplicationArea = All;
                    Visible = Rec."Query Type" <> Rec."Query Type"::Count;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(RunFormula)
            {
                ApplicationArea = All;
                Caption = 'Run Formula';
                Image = NextRecord;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    Logs: Record "Query Execution Log TPE";
                    QueryFormulaParameter: Record "Query Formula Parameter TPE";
                    QueryFormulaManagement: Codeunit "Query Formula Management TPE";
                    Parameters: Dictionary of [Code[20], Text];
                begin
                    QueryFormulaParameter.Reset();
                    QueryFormulaParameter.SetRange("Query Formula Code", Rec.Code);
                    if QueryFormulaParameter.FindSet() then
                        repeat
                            Parameters.Add(QueryFormulaParameter."Parameter Code", QueryFormulaParameter."Test Value");
                        until QueryFormulaParameter.Next() = 0;

                    QueryFormulaManagement.SetParameters(Parameters);
                    Message(QueryFormulaManagement.RunQuery(Rec.Code));

                    QueryFormulaManagement.GetLogger(Logs);

                    if not Logs.IsEmpty() then
                        Page.Run(Page::"Log List TPE", Logs);
                end;
            }
        }
    }
}
