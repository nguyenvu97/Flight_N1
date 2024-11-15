function doCreate(el) {
    var form = $('#form')[0];
    var formData = new FormData(form);

    $.ajax({
        url: "/Menu/DoCreate",
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
        url: "/Menu/DoEdit",
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

function onDelete(id) {
    if (confirm('Có chắc chắn xóa không?')) {
        $.ajax({
            type: "POST",
            url: "/Menu/DoDelete",
            data: { id: id },
            success: function (data) {
                if (data.status === "Success") {
                    window.location.reload();
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
    var url = "/Menu/Edit/" + id;
    console.log("url", url);
    $.get(url, function (data) {
        bindModal('#ctrModal', data);
    });
};

$("#select_menu").select2(menu);