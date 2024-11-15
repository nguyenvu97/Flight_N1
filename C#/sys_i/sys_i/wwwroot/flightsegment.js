
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
        url: "/FlightSegment/PagingSegment",
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

// function doCreate(el) {
//     var form = $('#form')[0];
//     // var air_id = parseInt($("#air_id").val(), 10);
//     // var route_id = parseInt($("#route_id").val(), 10);
//     var formData = new FormData(form);
//     // formData.set('air_id', air_id);
//     // formData.set('route_id', route_id);
//     $.ajax({
//         url: "/FlightSegment/DoCreate",
//         type: "POST",
//         data: formData,
//         contentType: false,
//         processData: false,
//         success: function (data) {
//             console.log("data", data);
//             if (data.status === "Success") {
//                 closeModal("#ctrModal")
//                 window.location.reload();
//             }
//         },
//         error: function (xhr, status, error) {
//             console.error("Error uploading file:", error);
//         }
//     });
// }


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



function doUpdate(el) {
    var form = $('#form')[0];
    var de_a = parseInt($("#de_a").val(), 10);
    var ar_a = parseInt($("#ar_a").val(), 10);
    var formData = new FormData(form);
    formData.set('de_a', de_a);
    formData.set('ar_a', ar_a);
    $.ajax({
        url: "/FlightSegment/DoEdit",
        type: "POST",
        data: formData,
        contentType: false,
        processData: false,
        success: function (data) {
            console.log("data", data);
            if (data.status === "Success") {
                closeModal("#addRowModal")
                window.location.reload();
            }
        },
        error: function (xhr, status, error) {
            console.error("Error uploading file:", error);
        }
    });
};

// Delete button
function onDelete(id) {
    if (confirm('Có chắc chắn xóa không?')) {
        $.ajax({
            type: "POST",
            url: "/FlightSegment/DoDelete",
            data: { id: id },
            success: function (data) {
                if (data.status === "Success") {
                    $('#add-row tr[data-id="' + id + '"]').remove();
                } else {
                    alert("Failed to delete item: " + data.Data);
                }
            },
            error: function (jqXHR, textStatus, errorThrown) {
                alert("Error: " + textStatus + "\nResponse Text: " + jqXHR.responseText + "\nError Thrown: " + errorThrown);
            }
        });
    }
}

function viewEdit(id) {
    var url = "/FlightSegment/Edit/" + id;
    console.log("url", url);
    $.get(url, function (data) {
        bindModal('#ctrModal', data);
    });
};




$("#select_routes").select2(routes);
$("#select_aircarf").select2(aircarf);

$("#select_routes_connecting").select2(routes);
$("#select_aircarf_connecting").select2(aircarf);

$("#select_flights").select2(flights);

