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
            ID="FormViewRettigheder" 
            DataKeyNames="Id" 
            DataSourceID="SqlDataSourceRettigheder" 
            RenderOuterTable="False" 
            DefaultMode="ReadOnly"
            runat="server">
            <ItemTemplate>
                <h3><%#Eval("Navn") %></h3>
                <h5>Rettigheder:</h5>
                <table class="table table-hover">
                    <tr>
                        <asp:Repeater ID="RepeaterRettigheder" DataSourceID="SqlDataSourceRolleRettigheder" runat="server">
                            <ItemTemplate>
                                <td><%# Eval("Navn") %></td>
                                <td>
                                    <asp:LinkButton ID="LinkButtonTilfoej" CssClass="btn btn-xs btn-success" runat="server">Tilføj</asp:LinkButton>
                                    <asp:LinkButton ID="LinkButtonFjern" CssClass="btn btn-xs btn-danger" runat="server">Fjern</asp:LinkButton>
                                </td>
                            </ItemTemplate>
                        </asp:Repeater>
                    </tr>
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

    <!--DataSource til RepeaterRettigheder-->
    <asp:SqlDataSource 
        ID="SqlDataSourceRolleRettigheder" 
        runat="server" 
        ConnectionString='<%$ ConnectionStrings:ConnectionString %>' 
        SelectCommand="SELECT * FROM Funktioner">
    </asp:SqlDataSource>
</asp:Content>

