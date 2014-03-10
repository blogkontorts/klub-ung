<%@ Page Title="" Language="C#" MasterPageFile="~/ADMIN/AdminMasterPage.master" AutoEventWireup="true" CodeFile="Events.aspx.cs" Inherits="ADMIN_Events" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <asp:Label ID="LabelTest" runat="server" Text=""></asp:Label>
    <!--Admin View Panel-->
    <asp:Panel ID="PanelAdminView" runat="server" Visible="false">
        <div class="col-sm-12">
            <asp:Button ID="ButtonAddEvent" runat="server" Text="Tilføj ny Event" CssClass="btn btn-success" OnClick="ButtonAddEvent_Click"/>
        </div>
        <div class="col-sm-6">
            <h3>Events</h3>
            <div class="input-group input-group-lg Search">
                <span class="input-group-btn">
                    <asp:LinkButton ID="LinkButtonSearch" CssClass="btn btn-info" runat="server" OnClick="LinkButtonSearch_Click"><span class="glyphicon glyphicon-search"></span></asp:LinkButton>
                </span>
                <asp:TextBox ID="TextBoxSearch" CssClass="form-control" runat="server"></asp:TextBox>
                <span class="input-group-btn">
                    <asp:LinkButton ID="LinkButtonCancelSearch" Visible="false" CssClass="btn btn-danger" runat="server" OnClick="LinkButtonCancelSearch_Click"><span class="glyphicon glyphicon-remove"></span></asp:LinkButton>
                </span>
            </div>
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
                    <asp:TemplateField ShowHeader="false">
                        <ItemTemplate>
                            <asp:LinkButton 
                                ID="LinkButtonSlet" 
                                CssClass="btn btn-xs btn-danger" 
                                CommandArgument='<%#Eval("Id") %>' 
                                CausesValidation="false" 
                                runat="server"
                                OnClick="LinkButtonSlet_Click">
                                <span class="glyphicon glyphicon-remove"></span>
                            </asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="Id" HeaderText="Id" ReadOnly="True" InsertVisible="False" SortExpression="Id" Visible="false"></asp:BoundField>
                    <asp:BoundField DataField="Navn" HeaderText="Navn" SortExpression="Navn"></asp:BoundField>
                    <asp:BoundField DataField="Bruger" HeaderText="Bruger" SortExpression="Bruger"></asp:BoundField>
                    <asp:TemplateField HeaderText="Oprettet" SortExpression="Oprettet">
                        <ItemTemplate>
                            <asp:Label runat="server" Text='<%# Bind("Oprettet", "{0:dd MMM, yyyy}") %>' ID="LabelOprettet"></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Godkendt" SortExpression="Godkendt">
                        <ItemTemplate>
                            <asp:Label runat="server" Text='<%#(Eval("Godkendt").Equals(true)? "Ja":"Nej" )%>' ID="LabelGodkendt"></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField ShowHeader="false">
                        <ItemTemplate>
                                <asp:LinkButton 
                                    Visible='<%# !IsApproved(Eval("Godkendt")) %>' 
                                    ID="LinkButtonGodkend" 
                                    CssClass="btn btn-xs btn-success" 
                                    OnClick="LinkButtonGodkend_Click"
                                    CommandArgument='<%#Eval("Id") %>' 
                                    runat="server"><span class="glyphicon glyphicon-thumbs-up"></span>
                                </asp:LinkButton>
                                <asp:LinkButton 
                                    Visible='<%# IsApproved(Eval("Godkendt")) %>' 
                                    ID="LinkButtonAfvis" 
                                    CssClass="btn btn-xs btn-danger" 
                                    OnClick="LinkButtonAfvis_Click" 
                                    CommandArgument='<%#Eval("Id") %>'
                                    runat="server"><span class="glyphicon glyphicon-thumbs-down"></span>
                                </asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField ShowHeader="False">
                        <ItemTemplate>
                            <div class="btn-group right-fix">
                                <asp:LinkButton ID="LinkButtonEdit" runat="server" CausesValidation="False" CommandName="Select" Text="Se Detaljer" CssClass="btn btn-xs btn-primary"></asp:LinkButton>
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>

        <div class="col-sm-6">
            <asp:FormView 
            ID="FormViewEventDetaljer" 
            DataKeyNames="Id" 
            DataSourceID="SqlDataSourceEventDetaljer" 
            RenderOuterTable="False" 
            runat="server"
            OnItemInserting="FormViewEventDetaljer_ItemInserting"
            OnItemUpdating="FormViewEventDetaljer_ItemUpdating">
            <ItemTemplate>
                <h3>Eventdetaljer</h3>
                <table class="table table-hover">
                    <tr>
                        <td>Navn:</td>
                        <td>
                            <asp:Label ID="LabelEventNavn" runat="server" Text='<%#Bind("Navn") %>'></asp:Label></td>
                    </tr>
                    <tr>
                        <td>Bruger:</td>
                        <td>
                            <asp:Label ID="LabelEventBruger" runat="server" Text='<%#Bind("Bruger") %>'></asp:Label></td>
                    </tr>
                    <tr>
                        <td>Adresse:</td>
                        <td>
                            <asp:Label ID="LabelEventAdresse" runat="server" Text='<%#Bind("Sted") %>'></asp:Label></td>
                    </tr>
                    <tr>
                        <td>Fra:</td>
                        <td>
                            <asp:Label ID="LabelEventStartDato" runat="server" Text='<%#Bind("StartDato", "{0:dd MMMM, yyyy H:mm}") %>'></asp:Label></td>
                    </tr>
                    <tr>
                        <td>Til:</td>
                        <td>
                            <asp:Label ID="LabelEventSlutDato" runat="server" Text='<%#Bind("SlutDato", "{0:dd MMMM, yyyy H:mm}") %>'></asp:Label></td>
                    </tr>
                    <tr>
                        <td>Kategori:</td>
                        <td>
                            <asp:Label ID="LabelEventKategori" runat="server" Text='<%#Bind("Kategori") %>'></asp:Label></td>
                    </tr>
                    <tr>
                        <td>Beskrivelse:</td>
                        <td>
                            <asp:Label ID="LabelEventBeskrivelse" runat="server" Text='<%#Bind("Beskrivelse") %>'></asp:Label></td>
                    </tr>
                    <tr>
                        <td>Billede:</td>
                        <td>
                            <asp:Label ID="LabelEventImg" runat="server"><img src='../Thumbs/<%#Eval("Img") %>' /></asp:Label></td>
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
                <h3>Tilføj ny Event</h3>
                <table class="table">
                    <tr>
                        <td>Navn:</td>
                        <td>
                            <asp:TextBox ID="TextBoxInsertEventNavn" CssClass="form-control" runat="server" Text='<%#Bind("Navn") %>'></asp:TextBox>
                            <asp:Label ID="TextBoxInsertEventNavnMsg" runat="server" Text=""></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td>Bruger:</td>
                        <td>
                            <asp:DropDownList 
                                ID="DropDownListBrugere" 
                                CssClass="form-control" 
                                runat="server"
                                DataSourceID="SqlDataSourceDropDownListBrugere"
                                DataTextField="BrugerNavn"
                                DataValueField="BrugerId"
                                SelectedValue='<%#Bind("BrugerId") %>'></asp:DropDownList></td>
                    </tr>
                    <tr>
                        <td>Adresse:</td>
                        <td>
                            <asp:TextBox ID="TextBoxInsertEventAdresse" runat="server" CssClass="form-control" Text='<%#Bind("Adresse") %>'></asp:TextBox>
                            <asp:Label ID="TextBoxInsertEventAdresseMsg" runat="server" Text=""></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td>By:</td>
                        <td>
                            <asp:TextBox ID="TextBoxInsertEventBy" runat="server" CssClass="form-control" Text='<%#Bind("Bynavn") %>'></asp:TextBox>
                            <asp:Label ID="TextBoxInsertEventByMsg" runat="server" Text=""></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td>Postnr:</td>
                        <td>
                            <asp:TextBox ID="TextBoxInsertEventPostnr" runat="server" CssClass="form-control" Text='<%#Bind("Postnr") %>'></asp:TextBox>
                            <asp:Label ID="TextBoxInsertEventPostnrMsg" runat="server" Text=""></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td>Fra:</td>
                        <td>
                            <asp:TextBox ID="TextBoxFra" CssClass="form-control" TextMode="DateTime" placeholder="dd-mm-åååå 00:00 ex: 13-5-2014 16:30" runat="server" Text='<%#Bind("StartDato") %>'></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td>Til:</td>
                        <td>
                            <asp:TextBox ID="TextBoxTil" CssClass="form-control" TextMode="DateTime" placeholder="dd-mm-åååå 00:00 ex: 13-5-2014 16:30" runat="server" Text='<%#Bind("SlutDato") %>'></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td>Kategori:</td>
                        <td>
                            <asp:DropDownList 
                                ID="DropDownListKategorier" 
                                CssClass="form-control" 
                                runat="server"
                                DataSourceID="SqlDataSourceDropDownListKategorier"
                                DataTextField="KategoriNavn"
                                DataValueField="KategoriId"
                                SelectedValue='<%#Bind("KategoriId") %>'></asp:DropDownList></td>
                    </tr>
                    <tr>
                        <td>Beskrivelse:</td>
                        <td>
                            <asp:TextBox ID="TextBoxInsertEventBeskrivelse" CssClass="form-control" TextMode="MultiLine" runat="server" Text='<%#Bind("Beskrivelse") %>'></asp:TextBox>
                            <asp:Label ID="TextBoxInsertEventBeskrivelseMsg" runat="server" Text=""></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td>Billede:</td>
                        <td>
                            <asp:FileUpload ID="FileUploadInsertEventImg" runat="server" FileName='<%# Bind("Img") %>' /></td>
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
                            <asp:TextBox ID="TextBoxUpdateEventNavn" CssClass="form-control" runat="server" Text='<%#Bind("Navn") %>'></asp:TextBox>
                            <asp:Label ID="TextBoxUpdateEventNavnMsg" runat="server" Text=""></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td>Bruger:</td>
                        <td>
                            <asp:DropDownList 
                                ID="DropDownListUpdateEventBruger" 
                                CssClass="form-control" 
                                runat="server"
                                DataSourceID="SqlDataSourceDropDownListBrugere"
                                DataValueField="BrugerId"
                                DataTextField="BrugerNavn"
                                SelectedValue='<%#Bind("BrugerId") %>'></asp:DropDownList></td>
                    </tr>
                    <tr>
                        <td>Adresse:</td>
                        <td>
                            <asp:TextBox ID="TextBoxUpdateEventAdresse" runat="server" CssClass="form-control" Text='<%#Bind("Adresse") %>'></asp:TextBox>
                            <asp:Label ID="TextBoxUpdateEventAdresseMsg" runat="server" Text=""></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td>By:</td>
                        <td>
                            <asp:TextBox ID="TextBoxUpdateEventBy" runat="server" CssClass="form-control" Text='<%#Bind("Bynavn") %>'></asp:TextBox>
                            <asp:Label ID="TextBoxUpdateEventByMsg" runat="server" Text=""></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td>Postnr:</td>
                        <td>
                            <asp:TextBox ID="TextBoxUpdateEventPostnr" runat="server" CssClass="form-control" Text='<%#Bind("Postnr") %>'></asp:TextBox>
                            <asp:Label ID="TextBoxUpdateEventPostnrMsg" runat="server" Text=""></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td>Fra:</td>
                        <td>
                            <asp:TextBox ID="TextBoxUpdateFra" CssClass="form-control" TextMode="DateTime" placeholder="dd-mm-åååå 00:00 ex: 13-5-2014 16:30" runat="server" Text='<%#Bind("StartDato") %>'></asp:TextBox></td>
                    </tr>
                    <tr>
                        <td>Til:</td>
                        <td>
                            <asp:TextBox ID="TextBoxUpdateTil" CssClass="form-control" TextMode="DateTime" placeholder="dd-mm-åååå 00:00 ex: 13-5-2014 16:30" runat="server" Text='<%#Bind("SlutDato") %>'></asp:TextBox></td>
                    </tr>
                    <tr>
                        <td>Kategori:</td>
                        <td>
                            <asp:DropDownList 
                                ID="DropDownListUpdateKategori" 
                                CssClass="form-control" 
                                runat="server"
                                DataSourceID="SqlDataSourceDropDownListKategorier"
                                DataValueField="KategoriId"
                                DataTextField="KategoriNavn"
                                SelectedValue='<%#Bind("KategoriId") %>'></asp:DropDownList></td>
                    </tr>
                    <tr>
                        <td>Beskrivelse:</td>
                        <td>
                            <asp:TextBox ID="TextBoxUpdateEventBeskrivelse" CssClass="form-control" TextMode="MultiLine" runat="server" Text='<%#Bind("Beskrivelse") %>'></asp:TextBox>
                            <asp:Label ID="TextBoxUpdateEventBeskrivelseMsg" runat="server" Text=""></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td>Billede:</td>
                        <td>
                            <asp:Label ID="LabelUpdateEventImg" runat="server" Text=""><img src='../Thumbs/<%#Eval("Img") %>' /></asp:Label>
                            <asp:FileUpload ID="FileUploadUpdateEventImg" runat="server" FileName='<%# Bind("Img") %>' /></td>
                    </tr>
                </table>
                <div class="btn-group">
                        <asp:LinkButton runat="server" Text="Gem" CommandName="Update" ID="InsertButton" CausesValidation="True" CssClass="btn btn-success"/>
                        <asp:LinkButton runat="server" Text="Annuller" CommandName="Cancel" ID="InsertCancelButton" CausesValidation="False" CssClass="btn btn-default"/>
                </div>
            </EditItemTemplate>
        </asp:FormView>
        </div>

        <div class="col-sm-12"></div>

        <div class="col-sm-2">
            <h3>Kategorier</h3>
            <asp:GridView
                ID="GridViewKategorier"
                runat="server"
                AutoGenerateColumns="False"
                DataKeyNames="Id"
                DataSourceID="SqlDataSourceKategoriGridView"
                EmptyDataText="Ingen kategorier fundet."
                AllowSorting="True"
                CssClass="table table-striped"
                BorderStyle="None"
                GridLines="None"
                AllowPaging="True">
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
                    <asp:BoundField DataField="Navn" HeaderText="Navn" ReadOnly="True" InsertVisible="False" SortExpression="Navn"></asp:BoundField>
                </Columns>
            </asp:GridView>
            <asp:TextBox ID="TextBoxAddKategori" runat="server" CssClass="form-control"></asp:TextBox>
            <asp:Label ID="TextBoxAddKategoriMsg" runat="server" Text=""></asp:Label>
            <asp:Button ID="ButtonAddKategori" CssClass="btn btn-sm btn-success btn-fix" runat="server" Text="Tilføj kategori" OnClick="ButtonAddKategori_Click" />
        </div>
    </asp:Panel>
    <!--Admin View End-->

    <!--User View Panel-->
    <asp:Panel ID="PanelUserView" runat="server">
        <div class="col-sm-12">
            <asp:Button ID="ButtonAddUserEvent" runat="server" Text="Tilføj ny Event" CssClass="btn btn-success" OnClick="ButtonAddEvent_Click"/>
        </div>
        <div class="col-sm-6">
            <h3>Events</h3>
            <asp:GridView
                ID="GridViewEgneEvents"
                runat="server"
                AutoGenerateColumns="False"
                DataKeyNames="Id"
                DataSourceID="SqlDataSourceEgneEvents"
                EmptyDataText="Ingen data fundet."
                AllowSorting="True"
                CssClass="table table-striped"
                BorderStyle="None"
                GridLines="None"
                AllowPaging="True">
                <Columns>
                    <asp:TemplateField ShowHeader="false">
                        <ItemTemplate>
                            <asp:LinkButton 
                                ID="LinkButtonSlet" 
                                CssClass="btn btn-xs btn-danger" 
                                CommandArgument='<%#Eval("Id") %>' 
                                CausesValidation="false" 
                                runat="server"
                                OnClick="LinkButtonSlet_Click">
                                <span class="glyphicon glyphicon-remove"></span>
                            </asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="Id" HeaderText="Id" ReadOnly="True" InsertVisible="False" SortExpression="Id" Visible="false"></asp:BoundField>
                    <asp:BoundField DataField="Navn" HeaderText="Navn" SortExpression="Navn"></asp:BoundField>
                    <asp:BoundField DataField="Bruger" HeaderText="Bruger" SortExpression="Bruger"></asp:BoundField>
                    <asp:TemplateField HeaderText="Oprettet" SortExpression="Oprettet">
                        <ItemTemplate>
                            <asp:Label runat="server" Text='<%# Bind("Oprettet", "{0:dd MMM, yyyy}") %>' ID="LabelOprettet"></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Godkendt" SortExpression="Godkendt">
                        <ItemTemplate>
                            <asp:Label runat="server" Text='<%#(Eval("Godkendt").Equals(true)? "Ja":"Nej" )%>' ID="LabelGodkendt"></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField ShowHeader="False">
                        <ItemTemplate>
                            <div class="btn-group right-fix">
                                <asp:LinkButton ID="LinkButtonEdit" runat="server" CausesValidation="False" CommandName="Select" Text="Se Detaljer" CssClass="btn btn-xs btn-primary"></asp:LinkButton>
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>

        <div class="col-sm-6">
        <asp:FormView 
            ID="FormViewEgenEventDetaljer" 
            DataKeyNames="Id" 
            DataSourceID="SqlDataSourceEgenEvent" 
            RenderOuterTable="False" 
            runat="server"
            OnItemInserting="FormViewEventDetaljer_ItemInserting"
            OnItemUpdating="FormViewEventDetaljer_ItemUpdating">
            <ItemTemplate>
                <h3>Eventdetaljer</h3>
                <table class="table table-hover">
                    <tr>
                        <td>Navn:</td>
                        <td>
                            <asp:Label ID="LabelEventNavn" runat="server" Text='<%#Bind("Navn") %>'></asp:Label></td>
                    </tr>
                    <tr>
                        <td>Bruger:</td>
                        <td>
                            <asp:Label ID="LabelEventBruger" runat="server" Text='<%#Bind("Bruger") %>'></asp:Label></td>
                    </tr>
                    <tr>
                        <td>Adresse:</td>
                        <td>
                            <asp:Label ID="LabelEventAdresse" runat="server" Text='<%#Bind("Sted") %>'></asp:Label></td>
                    </tr>
                    <tr>
                        <td>Fra:</td>
                        <td>
                            <asp:Label ID="LabelEventStartDato" runat="server" Text='<%#Bind("StartDato", "{0:dd MMMM, yyyy H:mm}") %>'></asp:Label></td>
                    </tr>
                    <tr>
                        <td>Til:</td>
                        <td>
                            <asp:Label ID="LabelEventSlutDato" runat="server" Text='<%#Bind("SlutDato", "{0:dd MMMM, yyyy H:mm}") %>'></asp:Label></td>
                    </tr>
                    <tr>
                        <td>Kategori:</td>
                        <td>
                            <asp:Label ID="LabelEventKategori" runat="server" Text='<%#Bind("Kategori") %>'></asp:Label></td>
                    </tr>
                    <tr>
                        <td>Beskrivelse:</td>
                        <td>
                            <asp:Label ID="LabelEventBeskrivelse" runat="server" Text='<%#Bind("Beskrivelse") %>'></asp:Label></td>
                    </tr>
                    <tr>
                        <td>Billede:</td>
                        <td>
                            <asp:Label ID="LabelEventImg" runat="server"><img src='../Thumbs/<%#Eval("Img") %>' /></asp:Label></td>
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
                <h3>Tilføj ny Event</h3>
                <table class="table">
                    <tr>
                        <td>Navn:</td>
                        <td>
                            <asp:TextBox ID="TextBoxInsertEventNavn" CssClass="form-control" runat="server" Text='<%#Bind("Navn") %>'></asp:TextBox>
                            <asp:Label ID="TextBoxInsertEventNavnMsg" runat="server" Text=""></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td>Adresse:</td>
                        <td>
                            <asp:TextBox ID="TextBoxInsertEventAdresse" runat="server" CssClass="form-control" Text='<%#Bind("Adresse") %>'></asp:TextBox>
                            <asp:Label ID="TextBoxInsertEventAdresseMsg" runat="server" Text=""></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td>By:</td>
                        <td>
                            <asp:TextBox ID="TextBoxInsertEventBy" runat="server" CssClass="form-control" Text='<%#Bind("Bynavn") %>'></asp:TextBox>
                            <asp:Label ID="TextBoxInsertEventByMsg" runat="server" Text=""></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td>Postnr:</td>
                        <td>
                            <asp:TextBox ID="TextBoxInsertEventPostnr" runat="server" CssClass="form-control" Text='<%#Bind("Postnr") %>'></asp:TextBox>
                            <asp:Label ID="TextBoxInsertEventPostnrMsg" runat="server" Text=""></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td>Fra:</td>
                        <td>
                            <asp:TextBox ID="TextBoxFra" CssClass="form-control" TextMode="DateTime" placeholder="dd-mm-åååå 00:00 ex: 13-5-2014 16:30" runat="server" Text='<%#Bind("StartDato") %>'></asp:TextBox></td>
                    </tr>
                    <tr>
                        <td>Til:</td>
                        <td>
                            <asp:TextBox ID="TextBoxTil" CssClass="form-control" TextMode="DateTime" placeholder="dd-mm-åååå 00:00 ex: 13-5-2014 16:30" runat="server" Text='<%#Bind("SlutDato") %>'></asp:TextBox></td>
                    </tr>
                    <tr>
                        <td>Kategori:</td>
                        <td>
                            <asp:DropDownList 
                                ID="DropDownListKategorier" 
                                CssClass="form-control" 
                                runat="server"
                                DataSourceID="SqlDataSourceDropDownListKategorier"
                                DataTextField="KategoriNavn"
                                DataValueField="KategoriId"
                                SelectedValue='<%#Bind("KategoriId") %>'></asp:DropDownList></td>
                    </tr>
                    <tr>
                        <td>Beskrivelse:</td>
                        <td>
                            <asp:TextBox ID="TextBoxInsertEventBeskrivelse" CssClass="form-control" TextMode="MultiLine" runat="server" Text='<%#Bind("Beskrivelse") %>'></asp:TextBox>
                            <asp:Label ID="TextBoxInsertEventBeskrivelseMsg" runat="server" Text=""></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td>Billede:</td>
                        <td>
                            <asp:FileUpload ID="FileUploadInsertEventImg" runat="server" FileName='<%# Bind("Img") %>' /></td>
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
                            <asp:TextBox ID="TextBoxUpdateEventNavn" CssClass="form-control" runat="server" Text='<%#Bind("Navn") %>'></asp:TextBox>
                            <asp:Label ID="TextBoxUpdateEventNavnMsg" runat="server" Text=""></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td>Bruger:</td>
                        <td>
                            <asp:Label ID="LabelEventBruger" runat="server" Text='<%#Eval("Bruger") %>'></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td>Adresse:</td>
                        <td>
                            <asp:TextBox ID="TextBoxUpdateEventAdresse" runat="server" CssClass="form-control" Text='<%#Bind("Adresse") %>'></asp:TextBox>
                            <asp:Label ID="TextBoxUpdateEventAdresseMsg" runat="server" Text=""></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td>By:</td>
                        <td>
                            <asp:TextBox ID="TextBoxUpdateEventBy" runat="server" CssClass="form-control" Text='<%#Bind("Bynavn") %>'></asp:TextBox>
                            <asp:Label ID="TextBoxUpdateEventByMsg" runat="server" Text=""></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td>Postnr:</td>
                        <td>
                            <asp:TextBox ID="TextBoxUpdateEventPostnr" runat="server" CssClass="form-control" Text='<%#Bind("Postnr") %>'></asp:TextBox>
                            <asp:Label ID="TextBoxUpdateEventPostnrMsg" runat="server" Text=""></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td>Fra:</td>
                        <td>
                            <asp:TextBox ID="TextBoxUpdateFra" CssClass="form-control" TextMode="DateTime" placeholder="dd-mm-åååå 00:00 ex: 13-5-2014 16:30" runat="server" Text='<%#Bind("StartDato") %>'></asp:TextBox></td>
                    </tr>
                    <tr>
                        <td>Til:</td>
                        <td>
                            <asp:TextBox ID="TextBoxUpdateTil" CssClass="form-control" TextMode="DateTime" placeholder="dd-mm-åååå 00:00 ex: 13-5-2014 16:30" runat="server" Text='<%#Bind("SlutDato") %>'></asp:TextBox></td>
                    </tr>
                    <tr>
                        <td>Kategori:</td>
                        <td>
                            <asp:DropDownList 
                                ID="DropDownListUpdateKategori" 
                                CssClass="form-control" 
                                runat="server"
                                DataSourceID="SqlDataSourceDropDownListKategorier"
                                DataValueField="KategoriId"
                                DataTextField="KategoriNavn"
                                SelectedValue='<%#Bind("KategoriId") %>'></asp:DropDownList></td>
                    </tr>
                    <tr>
                        <td>Beskrivelse:</td>
                        <td>
                            <asp:TextBox ID="TextBoxUpdateEventBeskrivelse" CssClass="form-control" TextMode="MultiLine" runat="server" Text='<%#Bind("Beskrivelse") %>'></asp:TextBox>
                            <asp:Label ID="TextBoxUpdateEventBeskrivelseMsg" runat="server" Text=""></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td>Billede:</td>
                        <td>
                            <asp:Label ID="LabelUpdateEventImg" runat="server" Text=""><img src='../Thumbs/<%#Eval("Img") %>' /></asp:Label>
                            <asp:FileUpload ID="FileUploadUpdateEventImg" runat="server" FileName='<%# Bind("Img") %>' /></td>
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
    <!--User View End-->

    <!--
        -------------
        DataSources
        -------------
        -->

    <!--DataSource til GridviewEvents-->
    <asp:SqlDataSource 
        ID="SqlDataSourceEvents" 
        runat="server" 
        ConnectionString='<%$ ConnectionStrings:ConnectionString %>' 
        SelectCommand="SELECT Events.Id,
                              Brugere.Navn AS Bruger,
                              Events.Navn AS Navn,
                              Events.Oprettet,
                              Godkendt
                       FROM Events JOIN Brugere ON FkBrugerId = Brugere.Id
                                   JOIN Kategori ON FkKategoriId = Kategori.Id
                       WHERE Events.Slettet = 0">
    </asp:SqlDataSource>

    <!--DataSource til Søgning-->
    <asp:SqlDataSource 
        ID="SqlDataSourceEventsSearch" 
        runat="server" 
        ConnectionString='<%$ ConnectionStrings:ConnectionString %>' 
        SelectCommand="SELECT Events.Id,
                              Brugere.Navn AS Bruger,
                              Events.Navn AS Navn,
                              Events.Oprettet,
                              Godkendt
                       FROM Events JOIN Brugere ON FkBrugerId = Brugere.Id
                                   JOIN Kategori ON FkKategoriId = Kategori.Id
                       WHERE Events.Slettet = 0 AND Events.Navn LIKE '%'+@Search+'%'"
        DeleteCommand="UPDATE Events SET Slettet = 1 WHERE Id = @Id">
        <SelectParameters>
            <asp:ControlParameter ControlID="TextBoxSearch" DefaultValue="%" Name="Search" Type="String" />
        </SelectParameters>
    </asp:SqlDataSource>

    <!--DataSource til FormViewEventDetaljer-->
    <asp:SqlDataSource 
        ID="SqlDataSourceEventDetaljer" 
        runat="server" 
        ConnectionString='<%$ ConnectionStrings:ConnectionString %>'
        SelectCommand="SELECT Events.Id,
                              Events.StartDato,
                              Events.SlutDato,
                              Brugere.Navn AS Bruger,
                              Brugere.Id AS BrugerId,
                              Events.Navn AS Navn,
                              Kategori.Id AS KategoriId,
                              Kategori.Navn AS Kategori,
                              Events.Beskrivelse,
                              Events.Img,
                              Events.Bynavn,
                              Events.Postnr,
                              Events.Adresse,
                              CONCAT(Events.Adresse, ', ', Events.Postnr, ', ', Events.Bynavn) AS Sted,
                              Godkendt
                       FROM Events JOIN Brugere ON FkBrugerId = Brugere.Id
                                   JOIN Kategori ON FkKategoriId = Kategori.Id
                       WHERE Events.Id = @Id"
        InsertCommand="INSERT INTO Events(Navn, Adresse, Beskrivelse, StartDato, SlutDato, Img, FkBrugerId, Godkendt, FkKategoriId, Bynavn, Postnr) 
                             VALUES(@Navn, @Adresse, @Beskrivelse, @StartDato, @SlutDato, @Img, @BrugerId, @Bypass, @KategoriId, @Bynavn, @Postnr)"
        UpdateCommand="UPDATE Events SET Navn = @Navn,
                                         Adresse = @Adresse,
                                         Beskrivelse = @Beskrivelse,
                                         StartDato = @StartDato,
                                         SlutDato = @SlutDato,
                                         Img = @Img,
                                         FkBrugerId = @BrugerId,
                                         FkKategoriId = @KategoriId,
                                         Bynavn = @Bynavn,
                                         Postnr = @Postnr
                       WHERE Events.Id = @Id"
        DeleteCommand="UPDATE Events SET Slettet = 1
                       WHERE Events.Id = @Id"
        OnInserting="SqlDataSourceEventDetaljer_Inserting"
        OnUpdating="SqlDataSourceEventDetaljer_Updating"
        OnDeleting="SqlDataSourceEventDetaljer_Deleting"
        OnInserted="OnSqlChanged"
        OnDeleted="OnSqlChanged"
        OnUpdated="OnSqlChanged">
        <SelectParameters>
            <asp:ControlParameter ControlID="GridViewEvents" Name="Id" Type="Int32" />
        </SelectParameters>
        <InsertParameters>
            <asp:Parameter Name="Img" Type="String" DefaultValue="noimg.jpg" />
            <asp:SessionParameter Name="Bypass" DefaultValue="0" SessionField="Bypass" Type="String" />
        </InsertParameters>
    </asp:SqlDataSource>

    <!--DataSource til DropDownListInsert/UpdateBruger-->
    <asp:SqlDataSource 
        ID="SqlDataSourceDropDownListBrugere" 
        runat="server"
        ConnectionString="<%$ ConnectionStrings:ConnectionString %>"
        SelectCommand="SELECT Id AS BrugerId, Navn AS BrugerNavn FROM Brugere WHERE Slettet=0">
    </asp:SqlDataSource>

    <!--DataSource til DropDownListKategorier-->
    <asp:SqlDataSource 
        ID="SqlDataSourceDropDownListKategorier" 
        runat="server"
        ConnectionString="<%$ ConnectionStrings:ConnectionString %>"
        SelectCommand="SELECT Id AS KategoriId, Navn AS KategoriNavn FROM Kategori">
    </asp:SqlDataSource>

    <!--DataSource til GridViewEgneEvents-->
    <asp:SqlDataSource 
        ID="SqlDataSourceEgneEvents" 
        runat="server" 
        ConnectionString='<%$ ConnectionStrings:ConnectionString %>' 
        SelectCommand="SELECT Events.Id,
                              Brugere.Navn AS Bruger,
                              Events.Navn AS Navn,
                              Events.Oprettet,
                              Godkendt
                       FROM Events JOIN Brugere ON FkBrugerId = Brugere.Id
                                   JOIN Kategori ON FkKategoriId = Kategori.Id
                       WHERE Events.Slettet = 0 AND FkBrugerId = @BrugerId"
        DeleteCommand="UPDATE Events SET Slettet = 1 WHERE Id = @Id">
        <SelectParameters>
            <asp:SessionParameter SessionField="Id" Name="BrugerId" Type="String" />
        </SelectParameters>
    </asp:SqlDataSource>

    <!--DataSource til FormViewEgenEvent-->
    <asp:SqlDataSource 
        ID="SqlDataSourceEgenEvent" 
        runat="server" 
        ConnectionString='<%$ ConnectionStrings:ConnectionString %>'
        SelectCommand="SELECT Events.Id,
                              Events.StartDato,
                              Events.SlutDato,
                              Brugere.Navn AS Bruger,
                              Brugere.Id AS BrugerId,
                              Events.Navn AS Navn,
                              Kategori.Id AS KategoriId,
                              Kategori.Navn AS Kategori,
                              Events.Beskrivelse,
                              Events.Img,
                              Events.Bynavn,
                              Events.Postnr,
                              Events.Adresse,
                              CONCAT(Events.Adresse, ', ', Events.Postnr, ', ', Events.Bynavn) AS Sted,
                              Godkendt
                       FROM Events JOIN Brugere ON FkBrugerId = Brugere.Id
                                   JOIN Kategori ON FkKategoriId = Kategori.Id
                       WHERE Events.Id = @Id"
        InsertCommand="INSERT INTO Events(Navn, Adresse, Beskrivelse, StartDato, SlutDato, Img, FkBrugerId, Godkendt, FkKategoriId, Bynavn, Postnr) 
                             VALUES(@Navn, @Adresse, @Beskrivelse, @StartDato, @SlutDato, @Img, @BrugerId, @Bypass, @KategoriId, @Bynavn, @Postnr)"
        UpdateCommand="UPDATE Events SET Navn = @Navn,
                                         Adresse = @Adresse,
                                         Beskrivelse = @Beskrivelse,
                                         StartDato = @StartDato,
                                         SlutDato = @SlutDato,
                                         Img = @Img,
                                         FkBrugerId = @BrugerId,
                                         FkKategoriId = @KategoriId,
                                         Bynavn = @Bynavn,
                                         Postnr = @Postnr
                       WHERE Events.Id = @Id"
        DeleteCommand="UPDATE Events SET Slettet = 1
                       WHERE Events.Id = @Id"
        OnInserting="SqlDataSourceEgenEvent_Inserting"
        OnUpdating="SqlDataSourceEgenEvent_Updating"
        OnDeleting="SqlDataSourceEgenEvent_Deleting"
        OnInserted="OnSqlChanged"
        OnDeleted="OnSqlChanged"
        OnUpdated="OnSqlChanged">
        <SelectParameters>
            <asp:ControlParameter ControlID="GridViewEgneEvents" Name="Id" Type="Int32" />
        </SelectParameters>
        <InsertParameters>
            <asp:SessionParameter SessionField="Id" Name="BrugerId" Type="String" />
            <asp:Parameter Name="Img" Type="String" DefaultValue="noimg.jpg" />
            <asp:SessionParameter Name="Bypass" DefaultValue="0" SessionField="Bypass" Type="String" />
        </InsertParameters>
        <UpdateParameters>
            <asp:SessionParameter SessionField="Id" Name="BrugerId" Type="String" />
        </UpdateParameters>
    </asp:SqlDataSource>

    <!--DataSource til GridViewKategorier-->
    <asp:SqlDataSource 
        ID="SqlDataSourceKategoriGridView" 
        runat="server" 
        ConnectionString='<%$ ConnectionStrings:ConnectionString %>' 
        SelectCommand="SELECT * FROM Kategori WHERE Slettet = 0"
        DeleteCommand="UPDATE Kategori SET Slettet = 1 WHERE Id = @Id">
    </asp:SqlDataSource>
</asp:Content>

