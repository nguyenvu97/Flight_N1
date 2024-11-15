
function dofilter(pi) {
    if (pi > 0)
        setCurrentPage(pi);
    doPaging();
}
function doPaging() {
    let currPageIdx = getCurrentPage();
    if (currPageIdx > 0)
        $("#PagingModel_Idx").val(currPageIdx);

    let formData = new FormData($('#search-form')[0]);
    $.ajax({
        url: "/FlightSegment/PagingTrip",
        data: formData,
        type: 'POST',
        contentType: false,
        processData: false,
        success: function (data) {
            $('#object-list').html(data);
            console.timeEnd('PagingRequest');
        },
        error: function (ex) {
            console.log(ex);
        }
    });
}


function doCreate(el) {
    // const data = [
    //     {
    //         air_id: 1,
    //         route_id: 1,
    //         de_time: "2024-09-09T10:53:00",
    //         ar_time: "2024-09-09T12:53:00",
    //         status: 1,
    //         note: "Note for segment",
    //         order: 1,
    //         previousSegmentId: null
    //     },
    //     {
    //         air_id: 2,
    //         route_id: 1,
    //         de_time: "2024-09-08T11:00:00",
    //         ar_time: "2024-09-08T13:00:00",
    //         status: 1,
    //         note: "Another segment",
    //         order: 2,
    //         previousSegmentId: null
    //     }
    // ];

    // Lấy giá trị từ các trường của form
    const air_id = $('#select_aircarf').val();
    const route_id = $('#select_routes').val();
    const de_date = $('#date').val();
    const de_time = $('#time').val();
    const ar_date = $('#date1').val();
    const ar_time = $('#time1').val();
    const status = $('#status').val();
    const note = $('#note').val();

    // Xây dựng đối tượng FlightSegmentViewModel
    const flightSegments = [
        {
            air_id: air_id,
            route_id: route_id,
            de_time: `${de_date}T${de_time}`,
            ar_time: `${ar_date}T${ar_time}`,
            status: parseInt(status),
            fromCity: null,
            toCity:null,
            note: note,
            order: 1,
            previousSegmentId: null
        }
    ];

    if ($('#addConnectingFlight').is(':checked')) {
        const connectingAirId = $('#select_aircarf_connecting').val();
        const connectingRouteId = $('#select_routes_connecting').val();
        const connectingDeDate = $('#date_connecting').val();
        const connectingDeTime = $('#time_connecting').val();
        const connectingArDate = $('#date1_connecting').val();
        const connectingArTime = $('#time1_connecting').val();

        flightSegments.push({
            air_id: connectingAirId,
            route_id: connectingRouteId,
            de_time: `${connectingDeDate}T${connectingDeTime}`,
            ar_time: `${connectingArDate}T${connectingArTime}`,
            status: parseInt(status),
            fromCity: null,
            toCity:null,
            note: note,
            order: 2,
            previousSegmentId: null
        });
    }
    $.ajax({
        url: "/FlightSegment/DoCreate",
        type: "POST",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        data: JSON.stringify(flightSegments),
        success: function (response) {
            if (response.status === "Success") {
                closeModal("#ctrModal");
                window.location.reload();
            } else {
                console.error("Server returned an error:", response.message);
            }
        },
        error: function (xhr, status, error) {
            console.error("Error during AJAX request:", error);
        }
    });
}


function view (id){
    var url = "/FlightSegment/View/" + id;
    console.log("url", url);
    $.get(url, function (data) {
        bindModal('#ctrModal', data);
    });
}