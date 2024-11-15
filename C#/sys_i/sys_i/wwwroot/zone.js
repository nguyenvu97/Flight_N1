
function dofilter(pi) {
    if (pi > 0)
        setCurrentPage(pi);
    doPaging();
}
function doCreate(el) {
    var form = $('#form')[0];
    var formData = new FormData(form);
    $.ajax({
        url: "/Zone/DoCreate",
        type: "POST",
        data: formData,
        contentType: false,
        processData: false,
        success: function (data) {
            console.log("data", data);
            if (data.status === "Success") {
                closeModal("#ctrModal")
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
        url: "/Zone/DoEdit",
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
            url: "/Zone/DoDelete",
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
    var url = "/Zone/Edit/" + id;
    console.log("url", url);
    $.get(url, function (data) {
        bindModal('#ctrModal', data);
    });
};

function view (id){
    var url = "/Zone/View/" + id;
    console.log("url", url);
    $.get(url, function (data) {
        bindModal('#ctrModal', data);
    });
}

