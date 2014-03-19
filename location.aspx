<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="location.aspx.cs" Inherits="location" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <meta name="viewport" content="initial-scale=1.0, user-scalable=no">
    <%-- style til kortet kun --%>
    <style>
        html, body, #map-canvas {
            height: 100%;
            margin: 0px;
            padding: 0px;
        }

        button[type="submit"]:enabled {
            background-color:#5cb85c;
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
            width: 50%;
            font-family: Roboto;
            font-size: 15px;
            font-weight: 300;
            text-overflow: ellipsis;
        }

        #pac-input:focus {
            border-color: #4d90fe;    
            margin-left: -1px;
            padding-left: 14px; /* Regular padding-left + 1. */
            width: 50%;
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
        
        var datatable;//hentet fra backenden med json
        var map;//selve kortet
        var mapOptions; 
        var infowindow;
        var defaultlatlog;
        var input;
        var submitButton;
        var searchBox;
        var places;
        var defaultBounds;

        function InitializeMap() {
            MakeMap();
            showEvents();
            makeScarchField();
            addListeners();
            document.getElementById('submitPosition').disabled = true;
        }


        function MakeMap() {
            //hentet datatable fra backend og convertere det således at 
            //det kan bruges i javascript
            //String replace bruges til at håndtere linjeskifte. Ellers breaker google map
            datatable = JSON.parse('<%=ConvertDataTabletoString() %>'.replace(/(\r\n|\n|\r\\)/gm, " "));
            //hvor kortete skal starte kordinaterne ræpresentere roskilde
            defaultlatlog = new google.maps.LatLng(55.642446, 12.084052);
            //sætter kortopsætning  
            mapOptions = {
                zoom: 12,
                center: defaultlatlog,
                mapTypeId: google.maps.MapTypeId.ROADMAP
            };
            //laver kortet og gemmer det i variablen map
            map = new google.maps.Map(document.getElementById("map-canvas"), mapOptions);
        }

        //denne funktion tager de events der er givet i datatablet og sætter markater på
        //kortet med beskrivelse 
        function showEvents() {
            //looper array
            for (var i = 0; i < datatable.length; i++) {
                //henter række i tabellen
                var datarow = datatable[i];
                //laver en latlng
                var Latlong = new google.maps.LatLng(datarow['Lat'], datarow['Long']);
                //laver Marker til den givne event
                marker = new google.maps.Marker({
                    map: map,
                    position: Latlong,
                    title: datarow['Navn']
                });
                //tilføjer eventlistener således at når der bliver klikket
                //kommer der beskrivelse fren til den givne marker på kortet
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

        //her bliver søgfeltet funktionerne oprettet det vil sige 
        //her tilføjes googles autocomplete
        //samtidig bliver søgboksen proppet ind på selve kortet.
        function makeScarchField() {
            markers = [];
            // Create the search box and link it to the UI element.
            input = /** @type {HTMLInputElement} */(
                document.getElementById('pac-input'));
            map.controls[google.maps.ControlPosition.TOP_LEFT].push(input);

            searchBox = new google.maps.places.SearchBox(
              /** @type {HTMLInputElement} */(input));
            submitButton = /** @type {HTMLInputElement} */(
                document.getElementById('submitPosition')); submitButton
            map.controls[google.maps.ControlPosition.TOP_LEFT].push(submitPosition);
        }

        //selve søgningen sker her 
        function Search() {
            // [START region_getplaces]
            // Listen for the event fired when the user selects an item from the
            // pick list. Retrieve the matching places for that item.  
            places = searchBox.getPlaces();

            //fjerner markers for tidligere søgninger
            for (var i = 0, marker; marker = markers[i]; i++) {
                marker.setMap(null);
            }

            // For each place, get the icon, place name, and location.
            markers = [];
            address = [];
            bounds = new google.maps.LatLngBounds();
            //place er det der retuneres fra searchBox.getPlaces()
            //som er et array
            for (var i = 0, place; place = places[i]; i++) {
                // Create a marker for each place.
                var marker = new google.maps.Marker({
                    map: map,
                    title: place.name,
                    position: place.geometry.location
                });
                //fulder data i address og markers arrays
                address.push(place.formatted_address);
                markers.push(marker);
                bounds.extend(place.geometry.location);
            }


            //sætter størelsen på kortet alt efter hvormange resultater der
            //er på søgningen
            if (markers.length > 1) {
                map.fitBounds(bounds);
            } else {
                map.setOptions({
                    zoom: 12,
                    center: markers[0].getPosition()
                });
            }
            //tilføjer data til de hidden fields som er definere i html
            //således at man kan hente dataen ud i backenden.
            //her kan de ses at det kun er resultat nr1 fra søgningen der
            //gemmes. Så hvis en gørninger giver flere resultataer er 
            //det det som google først finder der bliver gemt
            document.getElementById('address').value = address[0];
            document.getElementById('lat').value = markers[0].getPosition().lat();
            document.getElementById('long').value = markers[0].getPosition().lng();
        };
        // [END region_getplaces]


        //tilføjer listeners således at events bliver kørt når  
        //de skal
        //denne er går der sker en ændring i søgfeltet
        function addListeners() {
            google.maps.event.addListener(searchBox, 'places_changed', function() {
                Search();
                document.getElementById('submitPosition').disabled = false;
                document.getElementById('submitPosition').value = "true";
            });

            // Bias the SearchBox results towards places that are within the bounds of the
            // current map's viewport.
            google.maps.event.addListener(map, 'bounds_changed', function () {
                var bounds = map.getBounds();
                searchBox.setBounds(bounds);
            });
        }

        //disabler submit knappe således at der skal være en søgning
        //før man kan submitte
        function checkChanged(tfValue) {
            document.getElementById('submitPosition').disabled = true;
        }

        //starter helprocessen når siden bliver loaded
        google.maps.event.addDomListener(window, 'load', InitializeMap);
    </script>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <%-- Skjult input box der skal være der ellers laver siden et postback når man trykker på enter
         hvilket gør at siden ikke kan lave søgn  --%>
    <input id="lat" name="lat" type="hidden"/>
    <input id="long" name="long" type="hidden"/>
    <input id="address" name="address" type="hidden"/>
    <input id="pac-input" class="controls" type="text" placeholder="Search Box" onkeypress="checkChanged( this );"/>
    <button id ="submitPosition" name="submitPosition" class="controls submitbutton" type ="submit">submit</button>
    <div id="map-canvas"></div>
</asp:Content>

