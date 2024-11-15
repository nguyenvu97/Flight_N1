
function dofilter(pi) {
    if (pi > 0)
        setCurrentPage(pi);
    doPaging();
}
function doPaging() {
    let currPageIdx = getCurrentPage();
    if (currPageIdx > 0)
        $("#PagingModel_Idx").val(currPageIdx);
    console.time('PagingRequest');
    let formData = new FormData($('#search-form')[0]);
    $.ajax({
        url: "/Airline/Paging",
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
    var form = $('#form')[0];
    var formData = new FormData(form);

    $.ajax({
        url: "/Airline/DoCreate",
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
}

function doUpdate(el) {
    var form = $('#form')[0];
    var formData = new FormData(form);
    $.ajax({
        url: "/Airline/DoEdit",
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
    if (confirm('Có chắc chắn xóa không?!')) {
        $.ajax({
            type: "POST",
            url: "/Airline/DoDelete",
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
    var url = "/Airline/Edit/" + id;
    console.log("url", url);
    $.get(url, function (data) {
        bindModal('#ctrModal', data);
    });
};

function view (id){
    var url = "/Airline/View/" + id;
    console.log("url", url);
    $.get(url, function (data) {
        window.open(url, '_blank');
    });
}