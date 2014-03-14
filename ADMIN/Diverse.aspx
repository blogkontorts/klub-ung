<%@ Page Title="" Language="C#" MasterPageFile="~/ADMIN/AdminMasterPage.master" AutoEventWireup="true" CodeFile="Diverse.aspx.cs" Inherits="ADMIN_Diverse" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <script src="../Scripts/jscolor/jscolor.js"></script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div class="col-sm-6">
            <h3>Kategorier</h3>
            <asp:GridView
                ID="GridViewKategorier"
                runat="server"
                AutoGenerateColumns="False"
                DataKeyNames="Id"
                DataSourceID="SqlDataSourceKategori"
                EmptyDataText="Ingen kategorier fundet."
                AllowSorting="True"
                CssClass="table table-striped"
                BorderStyle="None"
                GridLines="None"
                AllowPaging="True"
                OnDataBound="GridViewKategorier_DataBound"
                OnRowUpdating="GridViewKategorier_RowUpdating">
                <Columns>
                    <asp:TemplateField ShowHeader="false">
                        <ItemTemplate>
                            <asp:LinkButton 
                                ID="LinkButtonSlet" 
                                CssClass="btn btn-xs btn-danger" 
                                CommandArgument='<%#Eval("Id") %>' 
                                CausesValidation="false" 
                                runat="server"
                                CommandName="Delete">
                                <span class="glyphicon glyphicon-remove"></span>
                            </asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="Id" HeaderText="Id" ReadOnly="True" InsertVisible="False" SortExpression="Id" Visible="false"></asp:BoundField>
                    <asp:TemplateField HeaderText="Navn" InsertVisible="False" SortExpression="Navn">
                        <EditItemTemplate>
                            <asp:TextBox runat="server" CssClass="form-control" Text='<%# Bind("Navn") %>' ID="TextBoxEditNavn"></asp:TextBox>
                            <asp:Label ID="TextBoxEditNavnMsg" runat="server" Text=""></asp:Label>
                        </EditItemTemplate>
                        <ItemTemplate>
                            <asp:Label runat="server" Text='<%# Bind("Navn") %>' ID="LabelNavn"></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField Visible="false" HeaderText="Farve">
                        <ItemTemplate>
                            <asp:Label ID="LabelColor" runat="server" Text='<%#Eval("Farve") %>'></asp:Label>
                        </ItemTemplate>
                        <EditItemTemplate>
                            <asp:TextBox ID="TextBoxColor" CssClass="color form-control" runat="server" Text='<%#Bind("Farve") %>'></asp:TextBox>
                        </EditItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Farve" SortExpression="Farve">
                        <ItemTemplate>
                            <asp:Panel ID="PanelColor" Width="20" Height="20" BackColor='<%#CheckColor(Eval("Farve")) %>' runat="server"></asp:Panel>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField ShowHeader="False">
                        <EditItemTemplate>
                            <div class="btn-group btn-group-sm">
                                <asp:LinkButton runat="server" Text="" CommandName="Update" CausesValidation="True" ID="LinkButtonSave"><span class="glyphicon glyphicon-ok"></span></asp:LinkButton>&nbsp;
                                <asp:LinkButton runat="server" Text="" CommandName="Cancel" CausesValidation="False" ID="LinkButtonCancel"><span class="glyphicon glyphicon-remove"></span></asp:LinkButton>
                            </div>
                        </EditItemTemplate>
                        <ItemTemplate>
                            <asp:LinkButton runat="server" Text="" CommandName="Edit" CausesValidation="False" ID="LinkButtonEdit"><span class="glyphicon glyphicon-pencil"></span></asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>

                </Columns>
            </asp:GridView>
        </div>
    <div class="col-sm-4">
        <asp:FormView
            ID="FormViewKategori"
            DataKeyNames="Id"
            DataSourceID="SqlDataSourceKategori"
            RenderOuterTable="False"
            runat="server"
            DefaultMode="Insert"
            OnItemInserting="FormViewKategori_ItemInserting">
            <InsertItemTemplate>
                <h3>Tilføj ny kategori</h3>
                <asp:Label ID="LabelKategoriNavn" runat="server" Text="Kategorinavn: "></asp:Label>
                <asp:TextBox ID="TextBoxAddKategori" runat="server" CssClass="form-control"></asp:TextBox>
                <asp:Label ID="TextBoxAddKategoriMsg" runat="server" Text=""></asp:Label><br />
                <asp:Label ID="LabelKategoriFarve" runat="server" Text="Farve: "></asp:Label>
                <asp:TextBox ID="TextBoxColor" CssClass="color form-control" runat="server"></asp:TextBox>
                <asp:Label ID="TextBoxColorMsg" runat="server" Text=""></asp:Label>
                <asp:Button ID="ButtonAddKategori" CssClass="btn btn-sm btn-success btn-fix" runat="server" Text="Tilføj kategori" CommandName="Insert" />
            </InsertItemTemplate>
        </asp:FormView>
    </div>

    <!--
        -------------
        DataSources
        -------------
        -->

    <!--DataSource til GridViewKategorier-->
    <asp:SqlDataSource 
        ID="SqlDataSourceKategori" 
        runat="server" 
        ConnectionString='<%$ ConnectionStrings:ConnectionString %>' 
        SelectCommand="SELECT * FROM Kategori WHERE Slettet = 0"
        DeleteCommand="UPDATE Kategori SET Slettet = 1 WHERE Id = @Id"
        UpdateCommand="UPDATE Kategori SET Navn = @Navn, Farve = @Farve WHERE Id = @Id"
        InsertCommand="INSERT INTO Kategori (Navn, Farve) VALUES (@Navn, @Farve)">
        <InsertParameters>
            <asp:ControlParameter ControlID="FormViewKategori$TextBoxAddKategori" Name="Navn" Type="String"/>
            <asp:ControlParameter ControlID="FormViewKategori$TextBoxColor" Name="Farve" Type="String"/>
        </InsertParameters>
    </asp:SqlDataSource>
</asp:Content>

