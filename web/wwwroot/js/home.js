function initialize() {
    initializeDropdowns();
    loadRegionsFromLocalStorage();
    setupEventListeners();
    $("#adult-quantity").val(1);
    $("#child-quantity").val(0);
    updateTotalPassengers();

    flatpickr("#startDate", {
        dateFormat: "d/m/Y",
        minDate: new Date(),
        onChange: function (selectedDates) {
            handleDateChange(selectedDates);
            $("#startDate_index").val($("#startDate").val());

        }
    });

    flatpickr("#endDate", {
        dateFormat: "d/m/Y",
        minDate: new Date(),

    });

    $('#roundTrip').prop('checked', true);
    updateReturnVisibility();
}


//update index-field

// Date
function handleDateChange(selectedDates) {
    if ($('input[name="flightType"]:checked').val() === 'roundTrip') {
        $('#return-date-container').show();
        flatpickr("#endDate", {
            dateFormat: "d/m/Y",
            minDate: selectedDates[0],
            onChange: function (selectedDates) {
                $("#endDate_index").val($("#endDate").val());
            }
        });
        $("#endDate_index").val($("#endDate").val());
    } else {
        $('#return-date-container').hide();
        $('#endDate').val('');
    }
}

function initializeDropdowns() {
    $("#dropdown-container-passenger").hide();
    $("#dropdown-container-from").hide();
    $("#dropdown-container-to").hide();
}

function updateReturnVisibility() {
    const flightType = $('input[name="flightType"]:checked').val();

    if (flightType === 'oneWay') {
        $('#endDate').closest('.sub-tab-item').hide();
        $('#endDate_index').closest('.sub-tab-item').hide();

    } else {
        $('#endDate').closest('.sub-tab-item').show();
        $('#endDate_index').closest('.sub-tab-item').show();
        $('#startDate').val("")
        $('#startDate_index').val("")
        $('#endDate').val("");
        $('#endDate_index').val("");
    }
}

function setupEventListeners() {
    console.log("Setting up event listeners...");
    const $passengerInput = $("#passenger");
    const $fromInput = $("#departure");
    const $toInput = $("#arrival");

    $passengerInput.on("click", function () {
        $("#dropdown-container-passenger").toggle();
    });

    $(document).on("click", function (event) {
        hideDropdowns(event, $passengerInput, "#dropdown-container-passenger");
        hideDropdowns(event, $fromInput, "#dropdown-container-from");
        hideDropdowns(event, $toInput, "#dropdown-container-to");
    });

    $fromInput.on("click", function () {
        selectedField = "departure";

        $("#dropdown-container-from").show();
        $("#dropdown-container-to").hide();
        displayLocations("Trong Nước", selectedTo, "location-list-from");
    });

    $toInput.on("click", function () {
        selectedField = "arrival";
        $("#dropdown-container-to").show();
        $("#dropdown-container-from").hide();
        displayLocations("Trong Nước", selectedFrom, "location-list-to");
    });

    $('input[name="flightType"]').change(function () {
        updateReturnVisibility();
    });

    $('input[name="flightType"]:checked').change();
}

function hideDropdowns(event, $input, dropdownSelector) {
    if (!$input.is(event.target) && !$(dropdownSelector).has(event.target).length) {
        $(dropdownSelector).hide();
    }
}

//Person
function changeQuantity(type, amount) {
    console.log("Setting up event listeners...");
    const $adultInput = $("#adult-quantity");
    const $childInput = $("#child-quantity");
    if (type === 'adult') {
        const newValue = Math.max(1, parseInt($adultInput.val()) + amount);
        $adultInput.val(newValue);
    } else if (type === 'child') {
        const newValue = Math.max(0, parseInt($childInput.val()) + amount);
        $childInput.val(newValue);
    }
    updateHiddenFields();
    updateTotalPassengers();
}

function updateTotalPassengers() {
    const adultQuantity = parseInt($("#adult-quantity").val());
    const childQuantity = parseInt($("#child-quantity").val());
    const totalPassengers = adultQuantity + childQuantity;
    $("#passenger").val(totalPassengers + ' hành khách');
}

function updateHiddenFields() {
    $('#adultQuantity').val($("#adult-quantity").val());
    $('#childQuantity').val($("#child-quantity").val());
}


let selectedFrom = "";
let selectedTo = "";
let currentLocation = "Hà Nội";
let storedAirports = JSON.parse(sessionStorage.getItem("airports"));
let selectedField = null;


//ZONE
function displayRegions(regionListId) {
    const $regionList = $("#" + regionListId);
    $regionList.empty();

    let regions = Object.keys(storedAirports);
    if (regions.includes("Trong Nước")) {
        regions.splice(regions.indexOf("Trong Nước"), 1);
        regions.unshift("Trong Nước");
    }

    regions.forEach(region => {
        if (storedAirports[region] && storedAirports[region].length > 0) {
            let $li = $("<li/>", {
                class: "list-group-item item",
                "data-region": region,
                text: region
            });

            if (region === "Trong Nước") {
                $li.addClass('active');
            }

            $li.on("click", function () {
                changeRegion(region, regionListId);
            });

            $regionList.append($li);
        }
    });
}


//Airport
function displayLocations(region, exclude, locationListId) {
    const $locationList = $("#" + locationListId);
    $locationList.empty();

    if (storedAirports[region] && storedAirports[region].length > 0) {
        storedAirports[region].forEach(location => {
            if (location.name !== exclude) {
                let $li = $("<li/>", {
                    class: "list-group-item",
                    text: location.name,
                    "data-code": location.code
                });

                $li.on("click", function () {
                    if (selectedField === "departure") {
                        selectedFrom = location.name;
                        $("#departure").val(selectedFrom);
                    } else if (selectedField === "arrival") {
                        selectedTo = location.name;
                        $("#arrival").val(selectedTo);
                    }
                    $("#dropdown-container-from").hide();
                    $("#dropdown-container-to").hide();
                    $("#departure_index").val(selectedFrom);
                    $("#arrival_index").val(selectedTo);
                });

                $locationList.append($li);
            }
        });
    } else {
        let $li = $("<li/>", {
            class: "list-group-item",
            text: "Không có địa điểm trong khu vực này."
        });
        $locationList.append($li);
    }
}

function changeRegion(newRegion, regionListId) {
    $("#" + regionListId + " .list-group-item").removeClass("active");
    $(`#${regionListId} [data-region="${newRegion}"]`).addClass("active");

    const locationListId = regionListId.replace("region-list", "location-list");
    displayLocations(newRegion, selectedFrom || selectedTo, locationListId);
}

function loadRegionsFromLocalStorage() {
    if (storedAirports) {
        displayRegions("region-list-from");
        displayRegions("region-list-to");
        displayLocations("Trong Nước", selectedFrom, "location-list-from");
        displayLocations("Trong Nước", selectedTo, "location-list-to");
        // updateIndices()
    }
}

/////Load Action


function convertDate(dateStr) {
    var parts = dateStr.split("/");
    var day = parts[0];
    var month = parts[1];
    var year = parts[2];
    return `${year}-${month}-${day}`;
}

function doSearch(el) {
    var form = $('#form')[0];
    var formData = new FormData(form);
    var flightType = $('input[name="flightType"]:checked').val();
    var flightTypeNumber = (flightType === 'oneWay') ? 1 : 2;
    var startDate = convertDate($('#startDate').val());
    var endDate = convertDate($('#endDate').val());
    var adultQuantity = $('#adult-quantity').val();
    var childQuantity = $('#child-quantity').val();
    if (!endDate || endDate === 'undefined') {
        endDate = "";
    }
    formData.set('number', flightTypeNumber);
    formData.set('startDate', startDate);
    formData.set('endDate', endDate);
    formData.set('adultQuantity', adultQuantity);
    formData.set('childQuantity', childQuantity);
    $.ajax({
        url: "/FlightSearch/Search/",
        type: "POST",
        data: formData,
        contentType: false,
        processData: false,
        success: function (data) {

            window.location.href = data.redirectUrl;
            console.log(data.redirectUrl)
        },
        error: function (xhr, status, error) {
            console.error("Error uploading file:", error);
        }
    });
}