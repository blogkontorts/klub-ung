<%@ Page Title="" Language="C#" MaintainScrollPositionOnPostback="true" MasterPageFile="~/ADMIN/AdminMasterPage.master" AutoEventWireup="true" CodeFile="Events.aspx.cs" Inherits="ADMIN_Events" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
<%--    <asp:Label ID="LabelTest" runat="server" Text=""></asp:Label>--%>
    <!--Admin View Panel-->
    <asp:Panel ID="PanelAdminView" runat="server" Visible="false">
        <div class="col-sm-12">
            <asp:Button ID="ButtonAddEvent" runat="server" Text="Tilføj ny Event" CssClass="btn btn-success" OnClick="ButtonAddEvent_Click"/>
        </div>
        <div class="col-sm-6">
            <h3>Events</h3>
            <asp:Panel ID="PanelSearch" CssClass="input-group input-group-lg Search" runat="server">
                <span class="input-group-btn">
                    <asp:LinkButton ID="LinkButtonSearch" CssClass="btn btn-info" runat="server" OnClick="LinkButtonSearch_Click"><span class="glyphicon glyphicon-search"></span></asp:LinkButton>
                </span>
                <asp:TextBox ID="TextBoxSearch" CssClass="form-control" runat="server"></asp:TextBox>
                <span class="input-group-btn">
                    <asp:LinkButton ID="LinkButtonCancelSearch" Visible="false" CssClass="btn btn-danger" runat="server" OnClick="LinkButtonCancelSearch_Click"><span class="glyphicon glyphicon-remove"></span></asp:LinkButton>
                </span>
            </asp:Panel>
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
                                <asp:LinkButton ID="LinkButtonEdit" runat="server" CausesValidation="False" CommandName="Select" Text="Se Detaljer" CssClass="btn btn-xs btn-primary" OnClick="UpdateFormView"></asp:LinkButton>
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
                            <asp:Label ID="LabelEventAdresse" runat="server" Text='<%#Bind("Adresse") %>'></asp:Label></td>
                    </tr>
                    <tr>
                        <td>Fra:</td>
                        <td>
                            <asp:Label ID="LabelEventStartDato" runat="server" Text='<%#Eval("StartDato", "{0:dd MMMM, yyyy}")+" - "+Eval("StartTid")%>'></asp:Label></td>
                    </tr>
                    <tr>
                        <td>Til:</td>
                        <td>
                            <asp:Label ID="LabelEventSlutDato" runat="server" Text='<%#Eval("SlutDato", "{0:dd MMMM, yyyy}")+" - "+ Eval("SlutTid") %>'></asp:Label></td>
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
                            <asp:Label ID="LabelMapDescription" runat="server" Text="Indtast adressen på din event og tryk på submit"></asp:Label>
                            <embed src="../location.aspx" width="500" height="500" />
                        </td>
                    </tr>
                    <tr>
                        <td>Fra:</td>
                        <td>
                            <asp:ImageButton ID="ImageButtonPrevYearFra" runat="server" ImageUrl="~/Images/darrowcutleft.png" OnClick="ImageButtonPrevYear_Click" />
                            <asp:ImageButton ID="ImageButtonPrevMonthFra" runat="server" ImageUrl="~/Images/arrowcutleft.png" OnClick="ImageButtonPrevMonth_Click" />
                            <asp:ImageButton ID="ImageButtonNextMonthFra" runat="server" ImageUrl="~/Images/arrowcut.png" OnClick="ImageButtonNextMonth_Click" />
                            <asp:ImageButton ID="ImageButtonNextYearFra" runat="server" ImageUrl="~/Images/darrowcut.png" OnClick="ImageButtonNextYear_Click" />
                            <asp:Calendar
                                width="100%" 
                                ID="CalendarInsertEventFra" 
                                runat="server" 
                                SelectedDate='<%#Bind("StartDato") %>' 
                                VisibleDate="<%#DateTime.Now %>" 
                                ShowNextPrevMonth="false" 
                                TitleStyle-BackColor="#428bca" 
                                Font-Names="Verdana" 
                                OtherMonthDayStyle-BackColor="#cccccc" 
                                TodayDayStyle-BackColor="#5cb85c"
                                OnDayRender="CalendarInsertEventFra_DayRender"></asp:Calendar>
                            <asp:Label ID="CalendarInsertEventFraMsg" runat="server" Text=""></asp:Label>
                        
                            <asp:Label ID="LabelInsertEventStartTid" runat="server" Text="Tid:"></asp:Label>
                            <asp:TextBox ID="TextBoxInsertEventStartTid" CssClass="form-control" placeholder="ex: 00:00" runat="server" Text='<%#Bind("StartTid") %>'></asp:TextBox>
                            <asp:Label ID="TextBoxInsertEventStartTidMsg" runat="server" Text=""></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td>Til:</td>
                        <td>
                            <asp:ImageButton ID="ImageButtonPrevYearTil" runat="server" ImageUrl="~/Images/darrowcutleft.png" OnClick="ImageButtonPrevYear_Click" />
                            <asp:ImageButton ID="ImageButtonPrevMonthTil" runat="server" ImageUrl="~/Images/arrowcutleft.png" OnClick="ImageButtonPrevMonth_Click" />
                            <asp:ImageButton ID="ImageButtonNextMonthTil" runat="server" ImageUrl="~/Images/arrowcut.png" OnClick="ImageButtonNextMonth_Click" />
                            <asp:ImageButton ID="ImageButtonNextYearTil" runat="server" ImageUrl="~/Images/darrowcut.png" OnClick="ImageButtonNextYear_Click" />
                            <asp:Calendar 
                                width="100%"
                                ID="CalendarInsertEventTil" 
                                runat="server" 
                                SelectedDate='<%#Bind("SlutDato") %>' 
                                VisibleDate="<%#DateTime.Now %>" 
                                ShowNextPrevMonth="false" 
                                TitleStyle-BackColor="#428bca" 
                                Font-Names="Verdana" 
                                OtherMonthDayStyle-BackColor="#cccccc" 
                                TodayDayStyle-BackColor="#5cb85c"
                                OnDayRender="CalendarInsertEventTil_DayRender"></asp:Calendar>
                            <asp:Label ID="CalendarInsertEventTilMsg" runat="server" Text=""></asp:Label>
                        
                            <asp:Label ID="LabelInsertEventSlutTid" runat="server" Text="Tid:"></asp:Label>
                            <asp:TextBox ID="TextBoxInsertEventSlutTid" CssClass="form-control" placeholder="ex: 00:00" runat="server" Text='<%#Bind("SlutTid") %>'></asp:TextBox>
                            <asp:Label ID="TextBoxInsertEventSlutTidMsg" runat="server" Text=""></asp:Label>
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
                <h3>Rediger event</h3>
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
                            <asp:Label ID="LabelMapDescription" runat="server" Text="Indtast adressen på din event og tryk på submit"></asp:Label><br />
                            <asp:Label ID="Label1" runat="server" Text='<%#"Nuværende: " + Eval("Adresse") %>'></asp:Label>
                            <embed src="../location.aspx" width="500" height="500" />
                        </td>
                    </tr>
                    <tr>
                        <td>Fra:</td>
                        <td>
                            <asp:ImageButton ID="ImageButtonUpdatePrevYearFra" runat="server" ImageUrl="~/Images/darrowcutleft.png" OnClick="ImageButtonUpdatePrevYear_Click" />
                            <asp:ImageButton ID="ImageButtonUpdatePrevMonthFra" runat="server" ImageUrl="~/Images/arrowcutleft.png" OnClick="ImageButtonUpdatePrevMonth_Click" />
                            <asp:ImageButton ID="ImageButtonUpdateNextMonthFra" runat="server" ImageUrl="~/Images/arrowcut.png" OnClick="ImageButtonUpdateNextMonth_Click" />
                            <asp:ImageButton ID="ImageButtonUpdateNextYearFra" runat="server" ImageUrl="~/Images/darrowcut.png" OnClick="ImageButtonUpdateNextYear_Click" />
                            <asp:Calendar 
                                width="100%"
                                ID="CalendarUpdateEventFra" 
                                runat="server" 
                                SelectedDate='<%#Bind("StartDato") %>'
                                VisibleDate='<%#Eval("StartDato") %>' 
                                ShowNextPrevMonth="false" 
                                TitleStyle-BackColor="#428bca" 
                                Font-Names="Verdana" 
                                OtherMonthDayStyle-BackColor="#cccccc" 
                                TodayDayStyle-BackColor="#5cb85c"
                                OnDayRender="CalendarUpdateEventFra_DayRender"></asp:Calendar>
                            <asp:Label ID="LabelUpdateEventFra" runat="server" Text='<%#"Nuværende: " + Eval("StartDato", "{0:d}") %>'></asp:Label>
                            <asp:Label ID="CalendarUpdateEventFraMsg" runat="server" Text=""></asp:Label>
                            <br />
                            <asp:Label ID="LabelUpdateEventStartTid" runat="server" Text="Tid:"></asp:Label>
                            <asp:TextBox ID="TextBoxUpdateEventStartTid" CssClass="form-control" placeholder="ex: 00:00" runat="server" Text='<%#Bind("StartTid") %>'></asp:TextBox>
                            <asp:Label ID="TextBoxUpdateEventStartTidMsg" runat="server" Text=""></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td>Til:</td>
                        <td>
                            <asp:ImageButton ID="ImageButtonUpdatePrevYearTil" runat="server" ImageUrl="~/Images/darrowcutleft.png" OnClick="ImageButtonUpdatePrevYear_Click" />
                            <asp:ImageButton ID="ImageButtonUpdatePrevMonthTil" runat="server" ImageUrl="~/Images/arrowcutleft.png" OnClick="ImageButtonUpdatePrevMonth_Click" />
                            <asp:ImageButton ID="ImageButtonUpdateNextMonthTil" runat="server" ImageUrl="~/Images/arrowcut.png" OnClick="ImageButtonUpdateNextMonth_Click" />
                            <asp:ImageButton ID="ImageButtonUpdateNextYearTil" runat="server" ImageUrl="~/Images/darrowcut.png" OnClick="ImageButtonUpdateNextYear_Click" />
                            <asp:Calendar 
                                width="100%"
                                ID="CalendarUpdateEventTil" 
                                runat="server" 
                                SelectedDate='<%#Bind("SlutDato") %>'
                                VisibleDate='<%#Eval("SlutDato") %>' 
                                ShowNextPrevMonth="false" 
                                TitleStyle-BackColor="#428bca" 
                                Font-Names="Verdana" 
                                OtherMonthDayStyle-BackColor="#cccccc" 
                                TodayDayStyle-BackColor="#5cb85c"
                                OnDayRender="CalendarUpdateEventTil_DayRender"></asp:Calendar>
                            <asp:Label ID="LabelUpdateEventTil" runat="server" Text='<%#"Nuværende: " + Eval("SlutDato", "{0:d}") %>'></asp:Label>
                            <asp:Label ID="CalendarUpdateEventTilMsg" runat="server" Text=""></asp:Label>
                            <br />
                            <asp:Label ID="LabelUpdateEventSlutTid" runat="server" Text="Tid:"></asp:Label>
                            <asp:TextBox ID="TextBoxUpdateEventSlutTid" CssClass="form-control" placeholder="ex: 00:00" runat="server" Text='<%#Bind("SlutTid") %>'></asp:TextBox>
                            <asp:Label ID="TextBoxUpdateEventSlutTidMsg" runat="server" Text=""></asp:Label>
                        </td>
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
                                <asp:LinkButton ID="LinkButtonEdit" runat="server" CausesValidation="False" CommandName="Select" Text="Se Detaljer" CssClass="btn btn-xs btn-primary" OnClick="UpdateFormView"></asp:LinkButton>
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
                            <asp:Label ID="LabelEventAdresse" runat="server" Text='<%#Eval("Adresse") %>'></asp:Label></td>
                    </tr>
                    <tr>
                        <td>Fra:</td>
                        <td>
                            <asp:Label ID="LabelEventStartDato" runat="server" Text='<%#Eval("StartDato", "{0:dd MMMM, yyyy}")+" - "+Eval("StartTid")%>'></asp:Label></td>
                    </tr>
                    <tr>
                        <td>Til:</td>
                        <td>
                            <asp:Label ID="LabelEventSlutDato" runat="server" Text='<%#Eval("SlutDato", "{0:dd MMMM, yyyy}")+" - "+ Eval("SlutTid") %>'></asp:Label></td>
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
                            <asp:Label ID="LabelMapDescription" runat="server" Text="Indtast adressen på din event og tryk på submit"></asp:Label>
                            <embed src="../location.aspx" width="500" height="500" />
                        </td>
                    </tr>
                    <tr>
                        <td>Fra:</td>
                        <td>
                            <asp:ImageButton ID="ImageButtonPrevYearFra" runat="server" ImageUrl="~/Images/darrowcutleft.png" OnClick="ImageButtonPrevYear_Click" />
                            <asp:ImageButton ID="ImageButtonPrevMonthFra" runat="server" ImageUrl="~/Images/arrowcutleft.png" OnClick="ImageButtonPrevMonth_Click" />
                            <asp:ImageButton ID="ImageButtonNextMonthFra" runat="server" ImageUrl="~/Images/arrowcut.png" OnClick="ImageButtonNextMonth_Click" />
                            <asp:ImageButton ID="ImageButtonNextYearFra" runat="server" ImageUrl="~/Images/darrowcut.png" OnClick="ImageButtonNextYear_Click" />
                            <asp:Calendar 
                                width="100%"
                                ID="CalendarInsertEventFra" 
                                runat="server" 
                                SelectedDate='<%#Bind("StartDato") %>' 
                                VisibleDate="<%#DateTime.Now %>" 
                                ShowNextPrevMonth="false" 
                                TitleStyle-BackColor="#428bca" 
                                Font-Names="Verdana" 
                                OtherMonthDayStyle-BackColor="#cccccc" 
                                TodayDayStyle-BackColor="#5cb85c"
                                OnDayRender="CalendarInsertEgenEventFra_DayRender"></asp:Calendar>
                            <asp:Label ID="CalendarInsertEventFraMsg" runat="server" Text=""></asp:Label>
                            <br />
                            <asp:Label ID="LabelInsertEventStartTid" runat="server" Text="Tid:"></asp:Label>
                            <asp:TextBox ID="TextBoxInsertEventStartTid" CssClass="form-control" placeholder="ex: 00:00" runat="server" Text='<%#Bind("StartTid") %>'></asp:TextBox>
                            <asp:Label ID="TextBoxInsertEventStartTidMsg" runat="server" Text=""></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td>Til:</td>
                        <td>
                            <asp:ImageButton ID="ImageButtonPrevYearTil" runat="server" ImageUrl="~/Images/darrowcutleft.png" OnClick="ImageButtonPrevYear_Click" />
                            <asp:ImageButton ID="ImageButtonPrevMonthTil" runat="server" ImageUrl="~/Images/arrowcutleft.png" OnClick="ImageButtonPrevMonth_Click" />
                            <asp:ImageButton ID="ImageButtonNextMonthTil" runat="server" ImageUrl="~/Images/arrowcut.png" OnClick="ImageButtonNextMonth_Click" />
                            <asp:ImageButton ID="ImageButtonNextYearTil" runat="server" ImageUrl="~/Images/darrowcut.png" OnClick="ImageButtonNextYear_Click" />
                            <asp:Calendar 
                                width="100%"
                                ID="CalendarInsertEventTil" 
                                runat="server" 
                                SelectedDate='<%#Bind("SlutDato") %>' 
                                VisibleDate="<%#DateTime.Now %>" 
                                ShowNextPrevMonth="false" 
                                TitleStyle-BackColor="#428bca" 
                                Font-Names="Verdana" 
                                OtherMonthDayStyle-BackColor="#cccccc" 
                                TodayDayStyle-BackColor="#5cb85c"
                                OnDayRender="CalendarInsertEgenEventTil_DayRender"></asp:Calendar>
                            <asp:Label ID="CalendarInsertEventTilMsg" runat="server" Text=""></asp:Label>
                            <br />
                            <asp:Label ID="LabelInsertEventSlutTid" runat="server" Text="Tid:"></asp:Label>
                            <asp:TextBox ID="TextBoxInsertEventSlutTid" CssClass="form-control" placeholder="ex: 00:00" runat="server" Text='<%#Bind("SlutTid") %>'></asp:TextBox>
                            <asp:Label ID="TextBoxInsertEventSlutTidMsg" runat="server" Text=""></asp:Label>
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
                <h3>Rediger event</h3>
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
                            <asp:Label ID="LabelMapDescription" runat="server" Text="Indtast adressen på din event og tryk på submit"></asp:Label><br />
                            <asp:Label ID="Label1" runat="server" Text='<%#"Nuværende: " + Eval("Adresse") %>'></asp:Label>
                            <embed src="../location.aspx" width="500" height="500" />
                        </td>
                    </tr>
                    <tr>
                        <td>Fra:</td>
                        <td>
                            <asp:ImageButton ID="ImageButtonUpdatePrevYearFra" runat="server" ImageUrl="~/Images/darrowcutleft.png" OnClick="ImageButtonUpdatePrevYear_Click" />
                            <asp:ImageButton ID="ImageButtonUpdatePrevMonthFra" runat="server" ImageUrl="~/Images/arrowcutleft.png" OnClick="ImageButtonUpdatePrevMonth_Click" />
                            <asp:ImageButton ID="ImageButtonUpdateNextMonthFra" runat="server" ImageUrl="~/Images/arrowcut.png" OnClick="ImageButtonUpdateNextMonth_Click" />
                            <asp:ImageButton ID="ImageButtonUpdateNextYearFra" runat="server" ImageUrl="~/Images/darrowcut.png" OnClick="ImageButtonUpdateNextYear_Click" />
                            <asp:Calendar 
                                width="100%"
                                ID="CalendarUpdateEventFra" 
                                runat="server" 
                                SelectedDate='<%#Bind("StartDato") %>'
                                VisibleDate='<%#Eval("StartDato") %>' 
                                ShowNextPrevMonth="false" 
                                TitleStyle-BackColor="#428bca" 
                                Font-Names="Verdana" 
                                OtherMonthDayStyle-BackColor="#cccccc" 
                                TodayDayStyle-BackColor="#5cb85c"
                                OnDayRender="CalendarUpdateEgenEventFra_DayRender"></asp:Calendar>
                            <asp:Label ID="LabelUpdateEventFra" runat="server" Text='<%#"Nuværende: " + Eval("StartDato", "{0:d}") %>'></asp:Label>
                            <asp:Label ID="CalendarUpdateEventFraMsg" runat="server" Text=""></asp:Label>
                            <br />
                            <asp:Label ID="LabelUpdateEventStartTid" runat="server" Text="Tid:"></asp:Label>
                            <asp:TextBox ID="TextBoxUpdateEventStartTid" CssClass="form-control" placeholder="ex: 00:00" runat="server" Text='<%#Bind("StartTid") %>'></asp:TextBox>
                            <asp:Label ID="TextBoxUpdateEventStartTidMsg" runat="server" Text=""></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td>Til:</td>
                        <td>
                            <asp:ImageButton ID="ImageButtonUpdatePrevYearTil" runat="server" ImageUrl="~/Images/darrowcutleft.png" OnClick="ImageButtonUpdatePrevYear_Click" />
                            <asp:ImageButton ID="ImageButtonUpdatePrevMonthTil" runat="server" ImageUrl="~/Images/arrowcutleft.png" OnClick="ImageButtonUpdatePrevMonth_Click" />
                            <asp:ImageButton ID="ImageButtonUpdateNextMonthTil" runat="server" ImageUrl="~/Images/arrowcut.png" OnClick="ImageButtonUpdateNextMonth_Click" />
                            <asp:ImageButton ID="ImageButtonUpdateNextYearTil" runat="server" ImageUrl="~/Images/darrowcut.png" OnClick="ImageButtonUpdateNextYear_Click" />
                            <asp:Calendar 
                                width="100%"
                                ID="CalendarUpdateEventTil" 
                                runat="server" 
                                SelectedDate='<%#Bind("SlutDato") %>'
                                VisibleDate='<%#Eval("SlutDato") %>' 
                                ShowNextPrevMonth="false" 
                                TitleStyle-BackColor="#428bca" 
                                Font-Names="Verdana" 
                                OtherMonthDayStyle-BackColor="#cccccc" 
                                TodayDayStyle-BackColor="#5cb85c"
                                OnDayRender="CalendarUpdateEgenEventTil_DayRender"></asp:Calendar>
                            <asp:Label ID="LabelUpdateEventTil" runat="server" Text='<%#"Nuværende: " + Eval("SlutDato", "{0:d}") %>'></asp:Label>
                            <asp:Label ID="CalendarUpdateEventTilMsg" runat="server" Text=""></asp:Label>
                            <br />
                            <asp:Label ID="LabelUpdateEventSlutTid" runat="server" Text="Tid:"></asp:Label>
                            <asp:TextBox ID="TextBoxUpdateEventSlutTid" CssClass="form-control" placeholder="ex: 00:00" runat="server" Text='<%#Bind("SlutTid") %>'></asp:TextBox>
                            <asp:Label ID="TextBoxUpdateEventSlutTidMsg" runat="server" Text=""></asp:Label>
                        </td>
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
                       WHERE Events.Slettet = 0 AND (Events.Navn LIKE '%'+@Search+'%' OR Brugere.Navn LIKE '%'+@Search+'%')"
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
                              Events.StartTid,
                              Events.SlutTid,
                              Brugere.Navn AS Bruger,
                              Brugere.Id AS BrugerId,
                              Events.Navn AS Navn,
                              Kategori.Id AS KategoriId,
                              Kategori.Navn AS Kategori,
                              Events.Beskrivelse,
                              Events.Img,
                              Events.Adresse,
                              Godkendt
                       FROM Events JOIN Brugere ON FkBrugerId = Brugere.Id
                                   JOIN Kategori ON FkKategoriId = Kategori.Id
                       WHERE Events.Id = @Id"
        InsertCommand="INSERT INTO Events(Navn, Adresse, Beskrivelse, StartDato, SlutDato, Img, FkBrugerId, Godkendt, FkKategoriId, StartTid, SlutTid, Lat, Long) 
                             VALUES(@Navn, @Adresse, @Beskrivelse, @StartDato, @SlutDato, @Img, @BrugerId, @Bypass, @KategoriId, @StartTid, @SlutTid, @Lat, @Long);"
        UpdateCommand="UPDATE Events SET Navn = @Navn,
                                         Beskrivelse = @Beskrivelse,
                                         StartDato = @StartDato,
                                         SlutDato = @SlutDato,
                                         Img = @Img,
                                         FkBrugerId = @BrugerId,
                                         Godkendt = @Bypass,
                                         FkKategoriId = @KategoriId,
                                         StartTid = @StartTid,
                                         SlutTid = @SlutTid
                       WHERE Events.Id = @Id"
        DeleteCommand="UPDATE Events SET Slettet = 1
                       WHERE Events.Id = @Id"
        OnInserting="SqlDataSourceEventDetaljer_Inserting"
        OnUpdating="SqlDataSourceEventDetaljer_Updating"
        OnDeleting="SqlDataSourceEventDetaljer_Deleting"
        OnInserted="SqlDataSourceEventDetaljer_Inserted"
        OnDeleted="OnSqlChanged"
        OnUpdated="SqlDataSourceEventDetaljer_Updated">
        <SelectParameters>
            <asp:ControlParameter ControlID="GridViewEvents" Name="Id" Type="Int32" />
        </SelectParameters>
        <InsertParameters>
            <asp:Parameter Name="Img" Type="String" DefaultValue="noimg.jpg" />
            <asp:SessionParameter Name="Bypass" DefaultValue="0" SessionField="Bypass" Type="String" />
            <asp:SessionParameter Name="Lat" type="String" SessionField="lat"/>
            <asp:SessionParameter Name="Long" type="String" SessionField="long"/>
            <asp:SessionParameter Name="Adresse" type="String" SessionField="address"/>
        </InsertParameters>
        <UpdateParameters>
            <asp:SessionParameter Name="Bypass" DefaultValue="0" SessionField="Bypass" Type="String" />
        </UpdateParameters>
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
                              Events.StartTid,
                              Events.SlutTid,
                              Brugere.Navn AS Bruger,
                              Brugere.Id AS BrugerId,
                              Events.Navn AS Navn,
                              Kategori.Id AS KategoriId,
                              Kategori.Navn AS Kategori,
                              Events.Beskrivelse,
                              Events.Img,
                              Events.Adresse,
                              Godkendt
                       FROM Events JOIN Brugere ON FkBrugerId = Brugere.Id
                                   JOIN Kategori ON FkKategoriId = Kategori.Id
                       WHERE Events.Id = @Id"
        InsertCommand="INSERT INTO Events(Navn, Adresse, Beskrivelse, StartDato, SlutDato, Img, FkBrugerId, Godkendt, FkKategoriId, StartTid, SlutTid, Lat, Long) 
                             VALUES(@Navn, @Adresse, @Beskrivelse, @StartDato, @SlutDato, @Img, @BrugerId, @Bypass, @KategoriId, @StartTid, @SlutTid, @Lat, @Long)"
        UpdateCommand="UPDATE Events SET Navn = @Navn,
                                         Beskrivelse = @Beskrivelse,
                                         StartDato = @StartDato,
                                         SlutDato = @SlutDato,
                                         Img = @Img,
                                         Godkendt = @Bypass,
                                         FkBrugerId = @BrugerId,
                                         FkKategoriId = @KategoriId,
                                         StartTid = @StartTid,
                                         SlutTid = @SlutTid
                       WHERE Events.Id = @Id"
        DeleteCommand="UPDATE Events SET Slettet = 1
                       WHERE Events.Id = @Id"
        OnInserting="SqlDataSourceEgenEvent_Inserting"
        OnUpdating="SqlDataSourceEgenEvent_Updating"
        OnDeleting="SqlDataSourceEgenEvent_Deleting"
        OnInserted="SqlDataSourceEgenEvent_Inserted"
        OnDeleted="OnSqlChanged"
        OnUpdated="SqlDataSourceEgenEvent_Updated">
        <SelectParameters>
            <asp:ControlParameter ControlID="GridViewEgneEvents" Name="Id" Type="Int32" />
        </SelectParameters>
        <InsertParameters>
            <asp:SessionParameter SessionField="Id" Name="BrugerId" Type="String" />
            <asp:Parameter Name="Img" Type="String" DefaultValue="noimg.jpg" />
            <asp:SessionParameter Name="Bypass" DefaultValue="0" SessionField="Bypass" Type="String" />
            <asp:SessionParameter Name="Lat" Type="String" SessionField="lat" />
            <asp:SessionParameter Name="Long" Type="String" SessionField="long" />
            <asp:SessionParameter Name="Adresse" Type="String" SessionField="address" />
        </InsertParameters>
        <UpdateParameters>
            <asp:SessionParameter SessionField="Id" Name="BrugerId" Type="String" />
            <asp:SessionParameter Name="Bypass" DefaultValue="0" SessionField="Bypass" Type="String" />
        </UpdateParameters>
    </asp:SqlDataSource>
</asp:Content>

