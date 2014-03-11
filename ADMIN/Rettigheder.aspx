<%@ Page Title="" Language="C#" MasterPageFile="~/ADMIN/AdminMasterPage.master" AutoEventWireup="true" CodeFile="Rettigheder.aspx.cs" Inherits="ADMIN_Rettigheder" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div class="col-sm-6">
        <h3>Roller</h3>
        <asp:GridView
            ID="GridViewRoller"
            runat="server"
            AutoGenerateColumns="False"
            DataKeyNames="Id"
            DataSourceID="SqlDataSourceRoller"
            EmptyDataText="Ingen data fundet."
            AllowSorting="True"
            CssClass="table table-striped"
            BorderStyle="None"
            GridLines="None"
            AllowPaging="True">
            <Columns>
                <asp:BoundField DataField="Id" HeaderText="Id" ReadOnly="True" InsertVisible="False" SortExpression="Id" Visible="false"></asp:BoundField>
                <asp:BoundField DataField="Navn" HeaderText="Navn" SortExpression="Navn"></asp:BoundField>
                <asp:TemplateField ShowHeader="False">
                    <ItemTemplate>
                        <div class="btn-group right-fix">
                            <asp:LinkButton ID="LinkButtonEdit" runat="server" CausesValidation="False" CommandName="Select" Text="Se Rettigheder" CssClass="btn btn-xs btn-primary right"></asp:LinkButton>
                        </div>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
    </div>

    <div class="col-sm-6">
        <asp:FormView 
            ID="FormViewRolle" 
            DataKeyNames="Id" 
            DataSourceID="SqlDataSourceRolle" 
            RenderOuterTable="False" 
            DefaultMode="ReadOnly"
            runat="server">
            <ItemTemplate>
                <h3><%#Eval("Navn") %></h3>
                <h5>Rettigheder:</h5>
                <table class="table table-hover">
                    <asp:Repeater ID="RepeaterRettigheder" DataSourceID="SqlDataSourceRolleRettigheder" runat="server">
                        <ItemTemplate>
                            <tr>
                                <td><%# Eval("Navn") %></td>
                                <td>
                                    <asp:LinkButton 
                                        Visible='<%#!HasRight(Eval("FkFunktionerId")) %>' 
                                        ID="LinkButtonTilfoej" 
                                        CssClass="btn btn-xs btn-success" 
                                        runat="server"
                                        CommandArgument='<%#Eval("Id") %>'
                                        OnClick="LinkButtonTilfoej_Click">Tilføj</asp:LinkButton>
                                    <asp:LinkButton 
                                        Visible='<%#HasRight(Eval("FkFunktionerId")) %>' 
                                        ID="LinkButtonFjern" 
                                        CssClass="btn btn-xs btn-danger" 
                                        runat="server"
                                        CommandArgument='<%#Eval("Id") %>'
                                        OnClick="LinkButtonFjern_Click">Fjern</asp:LinkButton>
                                </td>
                            </tr>
                        </ItemTemplate>
                    </asp:Repeater>
                </table>
            </ItemTemplate>
        </asp:FormView>
    </div>

    <!--
        -------------
        DataSources
        -------------
        -->
    <!--DataSource til GridViewRoller-->
    <asp:SqlDataSource 
        ID="SqlDataSourceRoller" 
        runat="server" 
        ConnectionString='<%$ ConnectionStrings:ConnectionString %>' 
        SelectCommand="SELECT * FROM Roller">
    </asp:SqlDataSource>

    <!--DataSource til FormViewRolle-->
    <asp:SqlDataSource 
        ID="SqlDataSourceRolle" 
        runat="server" 
        ConnectionString='<%$ ConnectionStrings:ConnectionString %>' 
        SelectCommand="SELECT * FROM Roller WHERE Id = @Id">
        <SelectParameters>
            <asp:ControlParameter ControlID="GridViewRoller" Name="Id" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>

    <!--DataSource til RepeaterRettigheder-->
    <asp:SqlDataSource 
        ID="SqlDataSourceRolleRettigheder" 
        runat="server" 
        ConnectionString='<%$ ConnectionStrings:ConnectionString %>' 
        SelectCommand="SELECT  *
                       FROM Funktioner 
                       LEFT JOIN (
                       SELECT RollerFunktioner.FkFunktionerId
                       FROM Roller 
                       INNER JOIN RollerFunktioner ON Roller.Id = RollerFunktioner.FkRolleId
                       WHERE Roller.Id = @RolleId) AS Fav ON Fav.FkFunktionerId = Funktioner.Id">
        <SelectParameters>
            <asp:ControlParameter ControlID="GridViewRoller" Name="RolleId" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
</asp:Content>

