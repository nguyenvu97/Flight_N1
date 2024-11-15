function toSeatmap() {
    $.ajax({
        url: '/SeatMaps/MapSeatsToSession/',
        type: 'POST',
        contentType: 'application/json',
        success: function (result) {
            console.log(result.message);
            location.href = "/SeatMaps/SeatMap/";
        },
        error: function (xhr, status, error) {
            console.error('Error:', error);
        }
    });
}


function toggleDetails(element) {
    const $details = $(element).closest('.sels').find('ul');
    $details.toggleClass('hidden');

    // Đổi icon khi mở/đóng
    const $icon = $(element).find('svg');
    $icon.toggleClass('fa-angle-down fa-angle-up');
}

function toggleBaggage() {
    const $baggageSection = $('.baggage-section');
    $baggageSection.toggleClass('hidden');
}

function updateBaggageCount(customerName, change, bagType) {
    const $inputField = $('#' + bagType + '_' + customerName);
    let currentCount = parseInt($inputField.val()) || 0;
    let newCount = currentCount + change;

    $inputField.val(newCount < 0 ? 0 : newCount);

    let baggageSummary = JSON.parse(sessionStorage.getItem('baggageSummary')) || {};

    if (!baggageSummary[customerName]) {
        baggageSummary[customerName] = {bag_go: 0, bag_back: 0};
    }

    let validCount = newCount < 0 ? 0 : newCount;
    if (bagType === 'bag_go') {
        baggageSummary[customerName].bag_go = validCount;
    } else if (bagType === 'bag_back') {
        baggageSummary[customerName].bag_back = validCount;
    }

    sessionStorage.setItem('baggageSummary', JSON.stringify(baggageSummary));

    updateOverallBaggageSummary();
}

function updateOverallBaggageSummary() {
    let totalGoCount = 0;
    let totalBackCount = 0;
    const pricePerBag = 500000;

    const baggageSummary = JSON.parse(sessionStorage.getItem('baggageSummary')) || {};

    Object.keys(baggageSummary).forEach(customerName => {
        totalGoCount += baggageSummary[customerName].bag_go || 0;
        totalBackCount += baggageSummary[customerName].bag_back || 0;
    });

    const totalGoPrice = totalGoCount * pricePerBag;
    const totalBackPrice = totalBackCount * pricePerBag;

    console.log('Total Go Price:', totalGoPrice);
    console.log('Total Back Price:', totalBackPrice);

    $('.total-bag-bag_go').text(totalGoPrice.toLocaleString());
    $('.total-bag-bag_back').text(totalBackPrice.toLocaleString());

    const grandTotal = totalGoPrice + totalBackPrice;
    $('.total-price').text('Tổng tiền: ' + grandTotal.toLocaleString());
}

function confirmBaggageSelection() {
    const baggageSummary = JSON.parse(sessionStorage.getItem("baggageSummary")) || {};
    const confirmButton = $('.confirm-button');
    confirmButton.prop('disabled', true);
    $.ajax({
        url: '/Shoping/ConfirmBaggage/',
        type: 'POST',
        contentType: 'application/json',
        data: JSON.stringify(baggageSummary),
        success: function (result) {
            setTimeout(function () {
                location.reload();
            }, 2000);
            confirmButton.prop('disabled', false);
        },
        error: function (xhr, status, error) {
            console.error('Error:', error);
        }
    });
}

function confirmTicket() {
    $.ajax({
        url: '/Shoping/ConfirmTickket/',
        type: 'POST',
        contentType: 'application/json',
        // data: JSON.stringify(baggageSummary),
        success: function (result) {
            if (result && result.success === false) {
                alert(result.message); 
            } else {
                sessionStorage.setItem("fromShoppingCart", "true");
                location.href = "/Payment/Payment";
                
            }
        },
        error: function (xhr, status, error) {
            console.error('Error:', error);
        }
    });
}