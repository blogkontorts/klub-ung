<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="location.aspx.cs" Inherits="location" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<title>Show/Add multiple markers to Google Maps from database in asp.net website</title>
<style type="text/css">
html { height: 100% }
body { height: 100%; margin: 0; padding: 0 }
#map_canvas { height: 100% }
</style>
<script type="text/javascript" src = "https://maps.googleapis.com/maps/api/js?key=AIzaSyC6v5-2uaq_wusHDktM9ILcqIrlPtnZgEk&sensor=false">
</script>
<script type="text/javascript">
    function initialize() {
        var markers = JSON.parse('<%=ConvertDataTabletoString() %>');
    var mapOptions = {
        center: new google.maps.LatLng(markers[0].lat, markers[0].lng),
        zoom: 5,
        mapTypeId: google.maps.MapTypeId.ROADMAP
        //  marker:true
    };
    var infoWindow = new google.maps.InfoWindow();
    var map = new google.maps.Map(document.getElementById("map_canvas"), mapOptions);
    for (i = 0; i < markers.length; i++) {
        var data = markers[i]
        var myLatlng = new google.maps.LatLng(data.lat, data.lng);
        var marker = new google.maps.Marker({
            position: myLatlng,
            map: map,
            title: data.title
        });
        (function (marker, data) {

            // Attaching a click event to the current marker
            google.maps.event.addListener(marker, "click", function (e) {
                infoWindow.setContent(data.description);
                infoWindow.open(map, marker);
            });
        })(marker, data);
    }
}
</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
<form id="form1" runat="server">
<div id="map_canvas" style="width: 500px; height: 400px"></div>
</asp:Content>

