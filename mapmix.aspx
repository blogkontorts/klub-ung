<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="location.aspx.cs" Inherits="location" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <style>
        html, body, #map-canvas {
            height: 800px;
            margin: 0px;
            padding: 0px;
        }
    </style>


<script type="text/javascript" src="http://maps.googleapis.com/maps/api/js?sensor=false">
</script>
<script>
    function InitializeMap() {
        var latlng = new google.maps.LatLng(-34.397, 150.644);

        var mapOptions = {
            zoom: 6,
            center: latlng,
            mapTypeId: google.maps.MapTypeId.ROADMAP,
            //   mapTypeControl: true,
            //   mapTypeControlOptions: { style: google.maps.MapTypeControlStyle.DROPDOWN_MENU,
            //                            poistion: google.maps.ControlPosition.TOP_RIGHT,
            //                            mapTypeIds: [google.maps.MapTypeId.ROADMAP,
            //                                         google.maps.MapTypeId.TERRAIN,
            //                                         google.maps.MapTypeId.HYBRID,
            //                                         google.maps.MapTypeId.SATELLITE]},
            //                           navigationControl: true,
            //                           navigationControlOptions: {
            //                               style: google.maps.NavigationControlStyle.ZOOM_PAN },
            //                           scaleControl: true,
            //                           disableDoubleClickZoom: true,
            //                           draggable: false,
            //                           streetViewControl: true,
            //                           draggableCursor: 'move'
        };


        var map = new google.maps.Map(document.getElementById("map-canvas"), mapOptions);
        //marker needs to be made after the map is created
        var marker1 = new google.maps.Marker({
            position: new google.maps.LatLng(-34.397, 150.644),
            map: map,
            title: 'Click me'
        });

        var marker2 = new google.maps.Marker({
            position: new google.maps.LatLng(-34.0, 150.0),
            map: map,
            title: 'Click me'
        });

        var infowindow1 = new google.maps.InfoWindow({
            content: 'marker1'
        });
        var infowindow2 = new google.maps.InfoWindow({
            content: 'marker2'
        });
        google.maps.event.addListener(marker1, 'click', function () {
            // Calling the open method of the infoWindow 
            infowindow1.open(map, marker1);
        });
        google.maps.event.addListener(marker2, 'click', function () {
            // Calling the open method of the infoWindow 
            infowindow2.open(map, marker2);
        });
    }


    window.onload = InitializeMap;

</script>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <input id="pac-input" class="controls" type="text" placeholder="Search Box" />
    <div id="map-canvas"></div>
</asp:Content>
