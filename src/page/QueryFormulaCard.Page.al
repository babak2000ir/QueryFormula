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

                    trigger OnValidate()
                    begin
                        SetUIVariables();
                    end;
                }
                group(FieldGroup)
                {
                    Caption = 'Field';
                    Visible = FieldFieldsVisibility;
                    field("Field ID"; Rec."Field ID")
                    {
                        ApplicationArea = All;
                    }
                    field("Field Name"; Rec."Field Name")
                    {
                        ApplicationArea = All;
                    }
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
                ToolTip = 'Run the query formula with the defined parameters and filters.';
                trigger OnAction()
                var
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

                    QueryFormulaManagement.ShowLogs();
                end;
            }
        }
    }

    var
        FieldFieldsVisibility: Boolean;

    trigger OnOpenPage()
    begin
        SetUIVariables();
    end;

    procedure SetUIVariables()
    begin
        FieldFieldsVisibility := Rec."Query Type" <> Rec."Query Type"::Count;
    end;

}
