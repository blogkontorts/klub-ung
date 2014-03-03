<%@ Page Title="" Language="C#" MasterPageFile="~/ADMIN/AdminMasterPage.master" AutoEventWireup="true" CodeFile="Brugere.aspx.cs" Inherits="ADMIN_Brugere" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <!--Admin View Panel-->
    <asp:Panel ID="PanelAdminView" runat="server">
        <div class="col-sm-12">
            <asp:Button ID="ButtonAddBruger" runat="server" Text="Tilføj ny Bruger" CssClass="btn btn-success" OnClick="ButtonAddInstruktor_Click"/>
        </div>
        <div class="col-sm-6">
            <h3>Brugere</h3>
            <asp:GridView
                ID="GridViewBrugere"
                runat="server"
                AutoGenerateColumns="False"
                DataKeyNames="Id"
                DataSourceID="SqlDataSourceBrugere"
                EmptyDataText="Ingen data fundet."
                AllowSorting="True"
                CssClass="table table-striped"
                BorderStyle="None"
                GridLines="None"
                AllowPaging="True">
                <Columns>
                    <asp:BoundField DataField="Id" HeaderText="Id" ReadOnly="True" InsertVisible="False" SortExpression="Id" Visible="false"></asp:BoundField>
                    <asp:BoundField DataField="Navn" HeaderText="Navn" SortExpression="Navn"></asp:BoundField>
                    <asp:BoundField DataField="Status" HeaderText="Status" SortExpression="Status"></asp:BoundField>
                    <asp:TemplateField ShowHeader="False">
                        <ItemTemplate>
                            <div class="btn-group right-fix">
                                <asp:LinkButton ID="LinkButtonEdit" runat="server" CausesValidation="False" CommandName="Select" Text="Se Detaljer" CssClass="btn btn-xs btn-primary right"></asp:LinkButton>
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>

        <div class="col-sm-6">
        <asp:FormView 
            ID="FormViewBrugerDetaljer" 
            DataKeyNames="Id" 
            DataSourceID="SqlDataSourceBrugerDetaljer" 
            RenderOuterTable="False" 
            runat="server">
            <ItemTemplate>
                <h3>Brugerdetaljer</h3>
                <table class="table table-hover">
                    <tr>
                        <td>Navn:</td>
                        <td>
                            <asp:Label ID="LabelBrugerNavn" runat="server" Text='<%#Bind("Navn") %>'></asp:Label></td>
                    </tr>
                    <tr>
                        <td>Email:</td>
                        <td>
                            <asp:Label ID="LabelBrugerEmail" runat="server" Text='<%#Bind("Email") %>'></asp:Label></td>
                    </tr>
                    <tr>
                        <td>Password:</td>
                        <td>
                            <asp:Label ID="LabelBrugerPassword" runat="server" Text='<%#Bind("Passcode") %>'></asp:Label></td>
                    </tr>
                    <tr>
                        <td>Status:</td>
                        <td>
                            <asp:Label ID="LabelBrugerStatus" runat="server" Text='<%#Bind("Status") %>'></asp:Label></td>
                    </tr>
                    <tr>
                        <td>Billede:</td>
                        <td>
                            <asp:Label ID="LabelBrugerImg" runat="server"><img src='../Thumbs/<%#Eval("Img") %>' /></asp:Label></td>
                    </tr>
                </table>
                <div class="btn-group">
                    <asp:LinkButton
                        ID="FormViewEdit"
                        Text="Rediger"
                        runat="server"
                        CausesValidation="true"
                        CommandName="Edit"
                        CommandArgument='<%# Eval("Id") %>'
                        CssClass="btn btn-warning" />
                    <asp:LinkButton
                        ID="FormViewDelete"
                        Text="Slet"
                        runat="server"
                        CausesValidation="true"
                        CommandName="Delete"
                        CommandArgument='<%# Eval("Id") %>'
                        CssClass="btn btn-danger" />
                </div>
            </ItemTemplate>
            <InsertItemTemplate>
                <h3>Tilføj ny bruger</h3>
                <table class="table">
                    <tr>
                        <td>Navn:</td>
                        <td>
                            <asp:TextBox ID="TextBoxInsertBrugerEfternavn" CssClass="form-control" runat="server" Text='<%#Bind("Navn") %>'></asp:TextBox></td>
                    </tr>
                    <tr>
                        <td>Email:</td>
                        <td>
                            <asp:TextBox ID="TextBoxInsertBrugerEmail" CssClass="form-control" runat="server" Text='<%#Bind("Email") %>'></asp:TextBox></td>
                    </tr>
                    <tr>
                        <td>Password:</td>
                        <td>
                            <asp:TextBox ID="TextBoxInsertBrugerPassword" CssClass="form-control" runat="server" Text='<%#Bind("Passcode") %>'></asp:TextBox></td>
                    </tr>
                    <tr>
                        <td>Status:</td>
                        <td><asp:DropDownList
                                        ID="DropDownListInsertBrugerStatus"
                                        runat="server"
                                        DataSourceID="SqlDataSourceDropDownListStatus"
                                        DataTextField="RolleNavn"
                                        DataValueField="RolleId"
                                        SelectedValue='<%# Bind("RolleId") %>'
                                        CssClass="form-control">
                            </asp:DropDownList></td>
                    </tr>
                    <tr>
                        <td>Billede:</td>
                        <td>
                            <asp:FileUpload ID="FileUploadInsertBrugerImg" runat="server" FileName='<%# Bind("Img") %>' /></td>
                    </tr>
                </table>
                <div class="btn-group">
                        <asp:LinkButton runat="server" Text="Tilføj" CommandName="Insert" ID="InsertButton" CausesValidation="True" CssClass="btn btn-success"/>
                        <asp:LinkButton runat="server" Text="Annuller" CommandName="Cancel" ID="InsertCancelButton" CausesValidation="False" CssClass="btn btn-default"/>
                </div>
            </InsertItemTemplate>
            <EditItemTemplate>
                <h3>Rediger bruger</h3>
                <table class="table table-hover">
                    <tr>
                        <td>Navn:</td>
                        <td>
                            <asp:TextBox ID="TextBoxUpdateBrugerFornavn" CssClass="form-control" runat="server" Text='<%#Bind("Fornavn") %>'></asp:TextBox></td>
                    </tr>
                    <tr>
                        <td>Email:</td>
                        <td>
                            <asp:TextBox ID="TextBoxUpdateBrugerEmail" CssClass="form-control" runat="server" Text='<%#Bind("Email") %>'></asp:TextBox></td>
                    </tr>
                    <tr>
                        <td>Password:</td>
                        <td>
                            <asp:TextBox ID="TextBoxUpdateBrugerPassword" CssClass="form-control" runat="server" Text='<%#Bind("Passcode") %>'></asp:TextBox></td>
                    </tr>
                    <tr>
                        <td>Status:</td>
                        <td><asp:DropDownList
                                        ID="DropDownListUpdateBrugerStatus"
                                        runat="server"
                                        DataSourceID="SqlDataSourceDropDownListStatus"
                                        DataTextField="RolleNavn"
                                        DataValueField="RolleId"
                                        SelectedValue='<%# Bind("RolleId") %>'
                                        CssClass="form-control">
                            </asp:DropDownList></td>
                    </tr>
                    <tr>
                        <td>Billede:</td>
                        <td>
                            <asp:Label ID="LabelUpdateBrugerImg" runat="server" Text=""><img src='../Thumbs/<%#Eval("Img") %>' /></asp:Label>
                            <asp:FileUpload ID="FileUploadUpdateBrugerImg" runat="server" FileName='<%# Bind("Img") %>' /></td>
                    </tr>
                </table>
                <div class="btn-group">
                        <asp:LinkButton runat="server" Text="Gem" CommandName="Update" ID="InsertButton" CausesValidation="True" CssClass="btn btn-success"/>
                        <asp:LinkButton runat="server" Text="Annuller" CommandName="Cancel" ID="InsertCancelButton" CausesValidation="False" CssClass="btn btn-default"/>
                </div>
            </EditItemTemplate>
        </asp:FormView>
    </div>
    </asp:Panel>
    <!--Admin View End-->
    <asp:Panel ID="PanelUserView" runat="server"></asp:Panel>

    <!--
        -------------
        DataSources
        -------------
        -->

    <!--DataSource til GridviewBrugere-->
    <asp:SqlDataSource 
        ID="SqlDataSourceBrugere" 
        runat="server" 
        ConnectionString='<%$ ConnectionStrings:familien_engmark_dk_dbConnectionString %>' 
        SelectCommand="SELECT [Brugere].[Id], 
                              [Brugere].[Navn], 
                              [Roller].[Navn] AS [Status] 
                      FROM [Brugere] 
                           JOIN [Roller] ON [FkRolleId] = [Roller].[Id]
                      WHERE Slettet = 0">
    </asp:SqlDataSource>

    <!--DataSource til FormViewBrugerDetaljer-->
    <asp:SqlDataSource 
        ID="SqlDataSourceBrugerDetaljer" 
        runat="server" 
        ConnectionString='<%$ ConnectionStrings:familien_engmark_dk_dbConnectionString %>'
        SelectCommand="SELECT Brugere.Id, Brugere.Navn, Email, Passcode, Roller.Navn AS Status, Img 
                       FROM Brugere JOIN Roller ON FkRolleId = Roller.Id 
                       WHERE Brugere.Id = @BrugerId"
        InsertCommand="INSERT INTO Brugere (Navn, Email, Passcode, Img, FkRolleId) 
                       VALUES (@Navn, @Email, @Passcode, @Img, @RolleId)"
        UpdateCommand="UPDATE Brugere 
                       SET Navn = @Navn, 
                           Email = @Email, 
                           Passcode = @Passcode, 
                           FkAdgangId = @AdgangId
                       WHERE Brugere.Id = @BrugerId"
        DeleteCommand = "UPDATE Brugere
                         SET Slettet = 1
                         WHERE Brugere.Id = @BrugerId"
        OnInserting="SqlDataSourceBrugerDetaljer_Inserting"
        OnDeleting="SqlDataSourceBrugerDetaljer_Deleting"
        OnUpdating="SqlDataSourceBrugerDetaljer_Updating"
        OnInserted="OnSqlChanged"
        OnDeleted="OnSqlChanged"
        OnUpdated="OnSqlChanged">
        <InsertParameters>
            <asp:Parameter Name="Img" Type="String" DefaultValue="noimg.jpg" />
        </InsertParameters>
        <SelectParameters>
            <asp:ControlParameter ControlID="GridViewBrugere" Name="BrugerId" PropertyName="SelectedValue" Type="Int32" />
        </SelectParameters>
        <DeleteParameters>
            <asp:ControlParameter ControlID="GridViewBrugere" Name="BrugerId" PropertyName="SelectedValue" Type="Int32" />
        </DeleteParameters>
        <UpdateParameters>
            <asp:ControlParameter ControlID="GridViewBrugere" Name="BrugerId" PropertyName="SelectedValue" Type="Int32" />
        </UpdateParameters>
    </asp:SqlDataSource>

    <!--DataSource til DropDownListInsertBrugerStatus-->
    <asp:SqlDataSource 
        ID="SqlDataSourceDropDownListStatus" 
        runat="server"
        ConnectionString="<%$ ConnectionStrings:familien_engmark_dk_dbConnectionString %>"
        SelectCommand="SELECT Id AS RolleId, Navn AS RolleNavn FROM Roller ORDER BY RolleId DESC">
    </asp:SqlDataSource>
</asp:Content>

