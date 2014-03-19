<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="_Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <svg class="svgbg" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns="http://www.w3.org/2000/svg" version="1.2">
        <filter id="pictureFilter">
            <feGaussianBlur stdDeviation="8" />
        </filter>
        <image class="svgimg" x="-8" height="105%" preserveAspectRatio="xMaxYMax slice" width="105%" xlink:href="Images/bg1W500.jpg">
        </image>
        <defs>
            <filter id="shadow" x="0" y="0" width="100%" height="100%">
                <feOffset result="offOut" in="SourceAlpha" dx="0" dy="0" />
                <feGaussianBlur result="blurOut" in="offOut" stdDeviation="5" />
                <feBlend in="SourceGraphic" in2="blurOut" mode="normal" />
            </filter>
        </defs>
    </svg>
        <div class="navbar navbar-inverse navbar-fixed-top" role="navigation">
            <div class="container">
                <div class="navbar-header>">
                    <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
                        <span class="sr-only">Toggle navigation</span>
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
                    </button>
                    <a class="navbar-brand" href="#">Event Kalender</a>
                </div>
                <div class="navbar-collapse collapse">
                    <ul class="nav navbar-nav">
                        <li class="active"><a href="#">Home</a></li>
                        <li class="dropdown">
                            <a href="#" class="dropdown-toggle" data-toggle="dropdown">Kategorier <b class="caret"></b></a>
                            <ul class="dropdown-menu">
                                <li><a class="musik" href="#">Musik</a></li>
                                <li><a class="friluft" href="#">Friluft</a></li>
                                <li><a class="rollespil" href="#">Rollespil</a></li>
                                <li><a class="it" href="#">IT</a></li>
                                <li><a class="andet" href="#">Andet</a></li>
                            </ul>
                        </li>

                        <li class="dropdown">
                            <a href="#" class="dropdown-toggle" data-toggle="dropdown">Søg</a>
                            <ul class="dropdown-menu">
                                <li>
                                    <asp:TextBox ID="TextBoxSearch" placeholder="søg" runat="server"></asp:TextBox></li>
                            </ul>
                        </li>
                        <li><a href="#event">Opret Event</a></li>
                    </ul>
                </div>
                <!--/.nav-collapse -->
            </div>
        </div>
        <div class="content col-md-12 col-lg-12">

            <div class="eventcontainer">
                <div class="hexrow">
                    <asp:SqlDataSource 
                        ID="SqlDataSource1" 
                        runat="server" 
                        ConnectionString='<%$ ConnectionStrings:ConnectionString %>' 
                        SelectCommand="SELECT Events.Id, 
                                              Events.Navn, 
                                              Events.Adresse, 
                                              Events.Beskrivelse, 
                                              Events.StartDato, 
                                              Events.SlutDato, 
                                              Events.Img, 
                                              Events.FkbrugerId, 
                                              Events.Godkendt, 
                                              Events.FkLokationId, 
                                              Events.FkKategoriId, 
                                              Events.Slettet, 
                                              Events.Oprettet, 
                                              Events.StartTid, 
                                              Events.SlutTid, 
                                              Events.Lat, 
                                              Events.Long, 
                                              Kategori.Farve 
                                      FROM Events INNER JOIN Kategori ON Events.FkKategoriId = Kategori.Id WHERE Events.Slettet = 0 AND Events.Godkendt = 1"></asp:SqlDataSource>
                    <asp:Repeater ID="RepeaterHex" DataSourceID="SqlDataSource1" runat="server">
                        <ItemTemplate>
                            <div class="eventcard">
                                <div class="cardtextheader">
                                    <h3><%#Truncate(30, Eval("Navn"))%></h3>
                                </div>
                                <div class="cardtexttime">
                                    <h6>kl: <%#Eval("StartTid", "{0:HH:mm}")%></h6>
                                    <h6><%#Eval("StartDato", "{0: dddd 'd.' dd.}")%></h6>
                                </div>
                                <div class="control-icons">
                                    <a href="<%--Eventet!querystring--%>" class="link">
                                        <div class="m-hex" style="background-color: #414141;">
                                            <span class="glyphicon glyphicon-info-sign"></span>
                                        </div>
                                    </a>
                                    <a href="<%#Eval("Navn")%>" class="link">
                                        <div class="m-hex" style="background-color: #414141;">
                                            <span class="glyphicon glyphicon-link"></span>
                                        </div>
                                    </a>
                                    <a href="<%--KORT!querystring--%>" class="link">
                                        <div class="m-hex" style="background-color: #414141;">
                                            <span class="glyphicon glyphicon-map-marker"></span>
                                        </div>
                                    </a>
                                </div>
                                <svg version="1.1" class="hex" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px"
                                    width="250px" height="250px" viewBox="0 0 500 500" enable-background="new 0 0 500 500" xml:space="preserve">
                                    <g>
                                    <clipPath Id="middle">
                                        <polygon class="middle"  points="69.687,368.002 1.49,250 65.641,139 435.357,139.997 498.51,250 430.314,368 " />
                                    </clipPath></g>
                                    <image clip-path="url(#middle)" x="0" y="50" xlink:href="Images/<%#Eval("Img")%>" width="100%" height="100%"></image>
                                    <polygon class="bottom" fill="#<%#Eval("farve") %>" points="125.745,465 69.687,368.002 430.314,368 374.255,465 " />
                                    <polygon class="top" fill="#<%#Eval("farve") %>" points="65.641,140 125.745,35 374.255,35 435.357,139.997 " />
                                </svg>
                                <div class="cardtexstbottom">
                                    <p><%#Truncate(30, Eval("Beskrivelse"))%></p>
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
            </div>
            <div class="t-panel-head">
                <div class="m-hex">
                    <h4 class="m-headline">Idag</h4>
                    <p class="m-text"></p>
                    <div class="m-pic"></div>
                </div>
            </div>
            <div class="t-panel">

                <asp:Repeater ID="RepeaterSideEvent" DataSourceID="SqlDataSource1" runat="server">
                    <ItemTemplate>
                        <div class="m-eventcard" onclick="">
                            <div class="m-date">
                                <div class="m-hex" style="background-color:#<%#Eval("farve") %>; border-color:#<%#Eval("farve")%>;">
                                    <%--<p class="m-day"><%#Eval("StartDato")%></p>--%>
                                    <p class="m-time"><%#Eval("StartTid", "{0:HH:mm}")%></p>
                                </div>
                            </div>
                            <a href="<%--Eventet!querystring--%>" class="m-link">
                                <div class="m-hex" style="background-color: #414141;">
                                    <span class="glyphicon glyphicon-info-sign"></span>
                                </div>
                            </a>
                            <a href="<%#Eval("Navn")%>" class="m-link">
                                <div class="m-hex" style="background-color: #414141;">
                                    <span class="glyphicon glyphicon-link"></span>
                                </div>
                            </a>
                            <a href="<%--KORT!querystring--%>" class="m-link">
                                <div class="m-hex" style="background-color: #414141;">
                                    <span class="glyphicon glyphicon-map-marker"></span>
                                </div>
                            </a>
                            <div class="m-event" >
                                <div class="m-hex" style="background-color:#<%#Eval("farve") %>; border-color:#<%#Eval("farve")%>;">
                                    <h4 class="m-headline"><%#Eval("Navn")%></h4>
                                    <p class="m-text"><%#Truncate(150, Eval("Beskrivelse"))%></p>
                                    <div class="m-pic" style="background-image: url(Images/<%#Eval("Img")%>)"></div>
                                </div>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
        </div>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"></script>
    <script src="Scripts/docs.min.js"></script>
    <script src="Scripts/bootstrap.min.js"></script>
</asp:Content>

