function setCustomner() {
    if (sessionStorage.getItem("baggageSummary")) {
        sessionStorage.removeItem("baggageSummary");
    }
    let customers = [];
    let adults = parseInt(document.getElementById("adults").value);
    let children = parseInt(document.getElementById("children").value);
    let flightGo = document.getElementById("flight_go").value.split(',').map(Number);
    let flightBackInput = document.getElementById("flight_back").value;
    let flightBack = flightBackInput ? flightBackInput.split(',').map(Number) : null;

    for (let i = 1; i <= adults; i++) {
        let customer = {
            fullName: document.getElementById(`fullName_${i}`).value,
            aliases: document.getElementById(`adultAliases_${i}`).value,
            birthOfDay: document.getElementById(`birthDate_${i}`).value,
            email: document.getElementById("email").value,
            phone: document.getElementById("phoneNumber").value,
            customType: "Người lớn",
            amountTotal: 0,
            bag_go: 0,
            bag_back: 0,
            seats_go: {},
            seats_go_child: {},
            seats_back: {},
            seats_back_child: {}
        };
        customers.push(customer);
    }

    for (let j = 1; j <= children; j++) {
        let customer = {
            fullName: document.getElementById(`fullName-child_${j}`).value,
            aliases: document.getElementById(`childAliases_${j}`).value,
            birthOfDay: document.getElementById(`birthDate-child_${j}`).value,
            email: document.getElementById("email").value,
            phone: document.getElementById("phoneNumber").value,
            customType: "Trẻ em",
            amountTotal: 0,
            bag_go: 0,
            bag_back: 0,
            seats_go: {},
            seats_go_child: {},
            seats_back: {},
            seats_back_child: {}
        };
        customers.push(customer);
    }

    // let bookingData = {
    //     flight_go: flightGo,
    //     flight_back: flightBack || null,
    //     customers: customers,
    //     ticketTypeGo: true,
    //     ticketTypeBack: !!flightBack
    // };
    $.ajax({
        url: '/Information/saveBookingData',
        type: 'POST',
        contentType: 'application/json',
        data: JSON.stringify(customers),
        success: function (result) {
            console.log(result.message);
            location.href = "/Shoping/ShopingCart";
        },
        error: function (xhr, status, error) {
            console.error('Error:', error);
        }
    });
}

function changeTarget(dropdown, aliasId) {
    let selectedValue = $(dropdown).val();
    $(`#${aliasId}`).val(selectedValue);
}

// function changeTarget(dropdown, aliasId) {
//     let selectedValue = $(dropdown).val();
//     $(`input[name="${aliasId}"]`).val(selectedValue);
// }

function changeTarget(dropdown, aliasId) {
    let selectedValue = $(dropdown).val();
    $(`#${aliasId}`).val(selectedValue);
}