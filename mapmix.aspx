<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="location.aspx.cs" Inherits="location" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <meta name="viewport" content="initial-scale=1.0, user-scalable=no">
    <style>
        html, body, #map-canvas {
            height: 100%;
            margin: 0px;
            padding: 0px;
        }

        .controls {
            margin-top: 16px;
            border: 1px solid transparent;
            border-radius: 2px 0 0 2px;
            box-sizing: border-box;
            -moz-box-sizing: border-box;
            height: 32px;
            outline: none;
            box-shadow: 0 2px 6px rgba(0, 0, 0, 0.3);
        }

        #pac-input {
            background-color: #fff;
            padding: 0 11px 0 13px;
            width: 400px;
            font-family: Roboto;
            font-size: 15px;
            font-weight: 300;
            text-overflow: ellipsis;
        }

            #pac-input:focus {
                border-color: #4d90fe;
                margin-left: -1px;
                padding-left: 14px; /* Regular padding-left + 1. */
                width: 401px;
            }

        .pac-container {
            font-family: Roboto;
        }

        #type-selector {
            color: #fff;
            background-color: #4d90fe;
            padding: 5px 11px 0px 11px;
        }

            #type-selector label {
                font-family: Roboto;
                font-size: 13px;
                font-weight: 300;
            }

        #target {
            width: 345px;
        }
    </style>
    <script type="text/javascript" src="http://maps.googleapis.com/maps/api/js?sensor=false&libraries=places"></script>
    <script>

        //var datatable;
        //var map;
        //var mapOptions
        //var infowindow;
        //var defaultlatlog;
        //var input;
        //var searchBox;
        //var places;
        //var defaultBounds;

        function InitializeMap() {
            //MakeMap();
            //showEvents();
            scarchForLocation();
        }


        function MakeMap(){
            datatable = JSON.parse('<%=ConvertDataTabletoString() %>');
            defaultlatlog = new google.maps.LatLng(55.642446, 12.084052);
            mapOptions = {
                zoom: 12,
                center: defaultlatlog,
                mapTypeId: google.maps.MapTypeId.ROADMAP
            };
            map = new google.maps.Map(document.getElementById("map-canvas"), mapOptions);
        }

        function showEvents() {
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
       
        function scarchForLocation() {
            var markers = [];
            var map = new google.maps.Map(document.getElementById('map-canvas'), {
                mapTypeId: google.maps.MapTypeId.ROADMAP
            });

            var defaultBounds = new google.maps.LatLngBounds(
                new google.maps.LatLng(-33.8902, 151.1759),
                new google.maps.LatLng(-33.8474, 151.2631));
            map.fitBounds(defaultBounds);

            // Create the search box and link it to the UI element.
            var input = /** @type {HTMLInputElement} */(
                document.getElementById('pac-input'));
            map.controls[google.maps.ControlPosition.TOP_LEFT].push(input);

            var searchBox = new google.maps.places.SearchBox(
              /** @type {HTMLInputElement} */(input));

            // [START region_getplaces]
            // Listen for the event fired when the user selects an item from the
            // pick list. Retrieve the matching places for that item.
            google.maps.event.addListener(searchBox, 'places_changed', function () {
                var places = searchBox.getPlaces();

                for (var i = 0, marker; marker = markers[i]; i++) {
                    marker.setMap(null);
                }

                // For each place, get the icon, place name, and location.
                markers = [];
                var bounds = new google.maps.LatLngBounds();
                for (var i = 0, place; place = places[i]; i++) {
                    var image = {
                        url: place.icon,
                        size: new google.maps.Size(71, 71),
                        origin: new google.maps.Point(0, 0),
                        anchor: new google.maps.Point(17, 34),
                        scaledSize: new google.maps.Size(25, 25)
                    };

                    // Create a marker for each place.
                    var marker = new google.maps.Marker({
                        map: map,
                        title: place.name,
                        position: place.geometry.location
                    });

                    markers.push(marker);

                    bounds.extend(place.geometry.location);
                }

                map.fitBounds(bounds);
            });
            // [END region_getplaces]

            // Bias the SearchBox results towards places that are within the bounds of the
            // current map's viewport.
            google.maps.event.addListener(map, 'bounds_changed', function () {
                var bounds = map.getBounds();
                searchBox.setBounds(bounds);
            });
        }

        function myFunction() {
            //do stuff
        }

        google.maps.event.addDomListener(window, 'load', InitializeMap);
    </script>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <%-- Skjult input box der skal være der ellers laver siden et postback når man trykker på enter
         hvilket gør at siden ikke kan lave søgn  --%>
    <input type="text" style="display:none"/>
    <input id="pac-input" class="controls" type="text" placeholder="Search Box" onSubmit="return false;"/>
    <div id="map-canvas"></div>
</asp:Content>

