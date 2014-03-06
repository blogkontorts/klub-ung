<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="location.aspx.cs" Inherits="location" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <style>
        html, body, #map-canvas {
            height: 800px;
            margin: 0px;
            padding: 0px;
        }
    </style>
    <script type="text/javascript" src="http://maps.googleapis.com/maps/api/js?sensor=false"></script>
    <script>

        var datatable;
        var map;
        var infowindow;
        var defaultlatlog;

        function InitializeMap() {
            datatable = JSON.parse('<%=ConvertDataTabletoString() %>');
            defaultlatlog = new google.maps.LatLng(55.642446, 12.084052);
            var mapOptions = {
                zoom: 12,
                center: defaultlatlog,
                mapTypeId: google.maps.MapTypeId.ROADMAP

            };
            map = new google.maps.Map(document.getElementById("map-canvas"), mapOptions);
        }

        function markicons() {
            InitializeMap();
                for (var i = 0; i < datatable.length; i++) {
                    var datarow = datatable[i];
                    var Latlong = new google.maps.LatLng(datarow['lat'], datarow['long']);
                    marker = new google.maps.Marker({
                        map: map,
                        position: Latlong,
                        title: datarow['Navn']
                    });
                    (function (Beskrivelse, marker) {
                        google.maps.event.addListener(marker, 'click', function (e) {
                            if (!infowindow) {
                                infowindow = new google.maps.InfoWindow();
                            }
                            infowindow.setContent(Beskrivelse);
                            infowindow.open(map, marker);
                        });
                    })("<b>" + datarow['Navn'] + "</b>" + "<p>" + datarow['Beskrivelse'] + "</p>", marker);
                }
        }
        window.onload = markicons;
    </script>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <%--<input id="pac-input" class="controls" type="text" placeholder="Search Box" />--%>
    <div id="map-canvas"></div>
</asp:Content>

