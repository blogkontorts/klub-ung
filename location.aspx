<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="location.aspx.cs" Inherits="location" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <%--<title>Show/Add multiple markers to Google Maps from database in asp.net website</title>--%>
    <style type="text/css">
        html, body, #map-canvas {
            height: 1500px;
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

        .gm-style .gm-style-iw, .gm-style .gm-style-iw a, .gm-style .gm-style-iw span, .gm-style .gm-style-iw label, .gm-style .gm-style-iw div {
            font-size: 20px;
        }
    </style>


    <script src="https://maps.googleapis.com/maps/api/js?v=3.exp&sensor=false&libraries=places"></script>
    <script>
        //koden er i høj grad taget fra googles api eksempler på deres egen maps api side men med en masse tilpasning til dette projekt. 
        function initialize() {
            //opretter alle variabler der skal bruges i initialize
            var jmarkers = JSON.parse('<%=ConvertDataTabletoString() %>');
            var defaultBounds = new google.maps.LatLngBounds(
                new google.maps.LatLng(jmarkers[0].lat, jmarkers[0].long));
            var infoWindow = new google.maps.InfoWindow();

            var currentmarkers = [];
            var mapOptions = {
                mapTypeId: google.maps.MapTypeId.ROADMAP
                //  marker:true
            };

            var defaultBounds = new google.maps.LatLngBounds(
                                    new google.maps.LatLng(55.500000, 11.914365),
                                    new google.maps.LatLng(55.707301, 12.249105));


            var map = new google.maps.Map(document.getElementById("map-canvas"), mapOptions);
            map.fitBounds(defaultBounds);

            // Create the search box and link it to the UI element.
            var input = /** @type {HTMLInputElement} */(
                document.getElementById('pac-input'));
            map.controls[google.maps.ControlPosition.TOP_LEFT].push(input);
            var searchBox = new google.maps.places.SearchBox(
              /** @type {HTMLInputElement} */(input));

            map.fitBounds(defaultBounds);

            for (i = 0; i < jmarkers.length; i++) {
                var data = jmarkers[i]
                var myLatlng = new google.maps.LatLng(data.lat, data.long);
                var marker = new google.maps.Marker({
                    position: myLatlng,
                    map: map,
                    title: data.Navn
                });
                (function (marker, data) {
                    // Attaching a click event to the current marker
                    google.maps.event.addListener(marker, "click", function (e) {
                        //set the data to be displayed in the infoWindow
                        infoWindow.setContent(data.Navn + "<br>" + data.Beskrivelse);
                        infoWindow.open(map, marker);
                    });
                })(marker, data);
            }

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
                        icon: image,
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
        google.maps.event.addDomListener(window, 'load', initialize);
    </script>


</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <input id="pac-input" class="controls" type="text" placeholder="Search Box" />
    <div id="map-canvas"></div>
</asp:Content>
