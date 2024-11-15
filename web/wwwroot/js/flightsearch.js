
var goFlightId = null; 
var returnFlightId = null;

$(document).ready(function () {
    initializeDropdowns();
    loadRegionsFromLocalStorage();
    setupEventListeners();
    updateTotalPassengers();

    flatpickr("#startDate", {
        dateFormat: "d/m/Y",
        minDate: new Date(),
        onChange: function (selectedDates, dateStr, instance) {
            if ($('input[name="flightType"]:checked').val() === 'roundTrip') {
                $('#return-date-container').show();
                // Cập nhật minDate cho ngày về
                flatpickr("#endDate", {
                    dateFormat: "d/m/Y",
                    minDate: selectedDates[0],
                });
            } else {
                $('#return-date-container').hide();
                $('#endDate').val('');
            }
        }
    });

    // Khởi tạo flatpickr cho ngày về
    flatpickr("#endDate", {
        dateFormat: "d/m/Y",
        minDate: new Date()
    });

    $('input[name="flightType"]').change(function () {
        if ($(this).val() === 'roundTrip') {
            $('#return-date-container').show();
            const departureDate = $("#startDate").val();
            if (departureDate) {
                flatpickr("#endDate", {
                    dateFormat: "d/m/Y",
                    minDate: departureDate,
                });
            }
        } else {
            $('#return-date-container').hide();
            $('#endDate').val('');
        }
    });
});

function initializeDropdowns() {
    $("#dropdown-container-passenger").hide();
    $("#dropdown-container-from").hide();
    $("#dropdown-container-to").hide();
    $('#roundTrip').prop('checked', true);
    $('#endDate').closest('.sub-tab-item').show();
    updateReturnVisibility();
}
function updateReturnVisibility() {
    const flightType = $('input[name="flightType"]:checked').val();

    if (flightType === 'oneWay') {
        $('#endDate').closest('.sub-tab-item').hide();
    } else {
        $('#endDate').closest('.sub-tab-item').show();
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
        console.log("From input clicked");
        selectedField = "departure";
        $("#dropdown-container-from").show();
        $("#dropdown-container-to").hide();
        displayLocations("Trong Nước", selectedTo, "location-list-from");
    });

    $toInput.on("click", function () {
        selectedField = "arrival"; // Track selected field
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

    updateTotalPassengers();
}

function updateTotalPassengers() {
    const totalPassengers = parseInt($("#adult-quantity").val()) + parseInt($("#child-quantity").val());
    $("#passenger").val(totalPassengers + ' hành khách');
}


///location change
let selectedFrom = "";
let selectedTo = "";
let currentLocation = "Hà Nội";
let storedAirports = JSON.parse(localStorage.getItem("airports"));
let selectedField = null;

function displayRegions(regionListId) {
    const $regionList = $("#" + regionListId);
    $regionList.empty(); // Clear previous regions

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
                       $("#departure").prop('defaultValue', selectedFrom);
                        $("#departure").val(selectedFrom);
                        console.log("Departure updated:", selectedFrom); 
                    } else if (selectedField === "arrival") {
                        selectedTo = location.name;
                        $("#arrival").prop('defaultValue', selectedTo);
                        $("#arrival").val(selectedTo);
                        console.log("Arrival updated:", selectedTo); 
                    }
                    $("#dropdown-container-from").hide();
                    $("#dropdown-container-to").hide();
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
        selectedFrom = currentLocation;
        $("#departure").val(selectedFrom);
        displayLocations("Trong Nước", selectedFrom, "location-list-from");
        displayLocations("Trong Nước", selectedTo, "location-list-to");
    }
}


$(document).ready(function () {

    $('#roundTrip').prop('checked', true);
    // Hiện ngày về khi trang được tải
    $('#endDate').closest('.sub-tab-item').show();
    $('input[name="flightType"]').change(function () {
        var flightType = $(this).val();

        if (flightType === 'oneWay') {

            $('#endDate').closest('.sub-tab-item').hide();
        } else if (flightType === 'roundTrip') {
            // Khứ hồi: Hiện cả hai ngày
            $('#endDate').closest('.sub-tab-item').show();
        } else if (flightType === 'multiCity') {

            $('#endDate').closest('.sub-tab-item').show();

        }
    });
    $('input[name="flightType"]:checked').change();
});




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
    var adultQuantity = $('#adult-quantity').val();
    var childQuantity = $('#child-quantity').val();
    formData.set('number', flightTypeNumber);
    var startDate = convertDate($('#startDate').val());
    var endDate = convertDate($('#endDate').val());
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
        },
        error: function (xhr, status, error) {
            console.error("Error uploading file:", error);
        }
    });
}


function selectFlightGo(flightId,number, seatsClass) {
    let totalprice = 0;
    if(seatsClass == 'economy'){
        totalprice =  parseFloat($('#money-go-economy').val().replace(/,/g, ''));;
    }
    if(seatsClass == 'business'){
         totalprice= parseFloat($('#money-go-business').val().replace(/,/g, ''));
    }
    console.log("Total Price:", totalprice);
    $.ajax({
        url: "/FlightSearch/SelectGo/",
        type: "POST",
        data: { flightId: flightId, number: number, seatsClass: seatsClass,totalPrice:totalprice }, 
        success: function (data) {
          
                window.location.href = data.redirectUrl; 
       
        },
        error: function (xhr, status, error) {
            console.error("Error uploading file:", error);
        }
    });
}

function selectFlightBack(flightId, number, seatsClass, adult, child) {
    let totalprice = 0;
    if(seatsClass == 'economy'){
        totalprice =  parseFloat($('#money-back-economy').val().replace(/,/g, ''));;
    }
    if(seatsClass == 'business'){
        totalprice= parseFloat($('#money-back-business').val().replace(/,/g, ''));
    }
    $.ajax({
        url: "/FlightSearch/SelectBack/",
        type: "POST",
        data: { flightId: flightId, number: number, seatsClass: seatsClass,totalPrice:totalprice },
        success: function (data) {
            window.location.href = data.redirectUrl; 
        },
        error: function (xhr, status, error) {
            console.error("Error uploading file:", error);
        }
    });
}




//function showFlightDetails(flightId, flightData) {

//    console.log("Thông tin chuyến bay:");
//    console.log("ID chuyến bay:", flightId);
//    console.log("Loại ghế:", flightData.seatsclass);
//    console.log("Dữ liệu chuyến bay:", flightData);
//    if (flightData.flights) {
//        flightData.flights.forEach(segment => {
//            console.log("Chặng bay:");
//            console.log("  ID:", segment.id);
//            console.log("  Từ:", segment.fromCity);
//            console.log("  Đến:", segment.toCity);
//            console.log("  Thời gian khởi hành:", segment.departureTime.toString("dd/MM/yyyy HH:mm"));
//            console.log("  Thời gian đến:", segment.arrivalTime.toString("HH:mm"));
//            console.log("  Hãng hàng không:", segment.airline);
//        });
//    }
//}