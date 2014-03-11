<%@ Page Title="" Language="C#" MasterPageFile="~/ADMIN/AdminMasterPage.master" AutoEventWireup="true" CodeFile="Godkendelser.aspx.cs" Inherits="ADMIN_Godkendelser" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="col-sm-8">
        <h3>Events, der mangler godkendelse</h3>
        <asp:GridView
            ID="GridViewEvents"
            runat="server"
            AutoGenerateColumns="False"
            DataKeyNames="Id"
            DataSourceID="SqlDataSourceEvents"
            EmptyDataText="Ingen data fundet."
            AllowSorting="True"
            CssClass="table table-striped"
            BorderStyle="None"
            GridLines="None"
            AllowPaging="True">
            <Columns>
                <asp:BoundField DataField="Id" HeaderText="Id" ReadOnly="True" InsertVisible="False" SortExpression="Id" Visible="false"></asp:BoundField>
                <asp:BoundField DataField="Navn" HeaderText="Navn" SortExpression="Navn"></asp:BoundField>
                <asp:BoundField DataField="Bruger" HeaderText="Bruger" SortExpression="Bruger"></asp:BoundField>
                <asp:BoundField DataField="Kategori" HeaderText="Kategori" SortExpression="Kategori"></asp:BoundField>
                <asp:BoundField DataField="Dato" HeaderText="Dato" SortExpression="Dato"></asp:BoundField>
                <asp:TemplateField ShowHeader="False">
                    <ItemTemplate>
                        <div class="btn-group right-fix">
                            <asp:LinkButton 
                                ID="LinkButtonGodkend" 
                                runat="server"
                                CommandArgument='<%#Eval("Id") %>' 
                                CausesValidation="False" 
                                CssClass="btn btn-xs btn-success right"
                                OnClick="LinkButtonGodkend_Click">
                                <span class="glyphicon glyphicon-thumbs-up"></span> Godkend
                            </asp:LinkButton>
                            <asp:LinkButton 
                                ID="LinkButtonSlet" 
                                runat="server"
                                CommandArgument='<%#Eval("Id") %>' 
                                CausesValidation="False" 
                                CssClass="btn btn-xs btn-danger right"
                                OnClick="LinkButtonSlet_Click">
                                <span class="glyphicon glyphicon-thumbs-down"></span> Slet
                            </asp:LinkButton>
                        </div>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
    </div>

    <!--
        -------------
        DataSources
        -------------
        -->

    <!--DataSource til GridviewBrugere-->
    <asp:SqlDataSource 
        ID="SqlDataSourceEvents" 
        runat="server" 
        ConnectionString='<%$ ConnectionStrings:ConnectionString %>' 
        SelectCommand="SELECT Events.Id,
                              Events.Navn,
                              CONCAT(Events.StartDato, ' - ', Events.SlutDato) AS Dato,
                              Brugere.Navn AS Bruger,
                              Kategori.Navn AS Kategori,
                              Godkendt
                       FROM Events
                       JOIN Brugere ON FkBrugerId = Brugere.Id
                       JOIN Kategori ON FkKategoriId = Kategori.Id
                       WHERE Godkendt = 0 AND Events.Slettet = 0">
    </asp:SqlDataSource>
</asp:Content>

