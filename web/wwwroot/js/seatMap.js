var selectedSeatMapId = parseInt($('#currentId').val(), 10) || 0;
var selectedSeatId = null;

function loadSeatMap(flightId) {
    var customer = sessionStorage.getItem('selectedCustomer');
    $.ajax({
        url:  `/SeatMaps/SeatMapPartial/${flightId}?cus=${customer}`,
        type: 'GET',
        success: function (result) {
            $('.plane-layout').html(result);
            // location.reload();
        },
        error: function () {
            alert('Không thể tải layout ghế.');
        }
    });
}

function changeCustomer(element) {
    // const customerFullName = $(element).find('.customer-name').text().trim().replace(/\s*:\s*/g, '');
    const customerFullName = $(element).find('.customer-name').text().trim();
    const nameAfterColon = customerFullName.split(':')[1]?.trim() || '';
    sessionStorage.setItem('selectedCustomer', nameAfterColon);
    // const customer = $(element).data('CustomerInlist');
    const id = parseInt($("#currentIdInlist").val());

    $.ajax({
        url: `/SeatMaps/SeatMapPartial/` + id,
        type: 'GET',
        // data: { Customer: customer, id: id },
        success: function (result) {
            // Đặt kết quả vào phần tử HTML `.plane-layout`
            $('.plane-layout').html(result);
            // location.reload();
        },
        error: function () {
            alert('Không thể tải thông tin chỗ ngồi. Vui lòng thử lại.');
        }
    });
}
function loadSeatMapA(flightId, cus) {
    $.ajax({
        url: `/SeatMaps/SeatMapPartial/${flightId}${cus ? '?cus=' + encodeURIComponent(cus) : ''}`,
        type: 'GET',
        success: function (result) {
            console.log(result);
            $('.plane-layout').html(result);
        },
        error: function () {
            alert('Không thể tải layout ghế.');
        }
    });
}



function saveBooking() {
    $.ajax({
        url: '/SeatMaps/SaveBookingData/' ,
        type: 'GET',
        // data: {currentId: selectedSeatMapId}, // Sử dụng biến đã khai báo
        success: function (result) {
            location.href = 'http://localhost:5278/Shoping/ShopingCart';
        },
        error: function () {
            alert('Không thể chuyển sang chuyến bay tiếp theo.');
        }
    });
}


function selectCustomer(element) {
    $('.customer-item').removeClass('changed');
    $(element).closest('.customer-item').addClass('changed');
}


function selectSeat(seatId) {
    selectedSeatId = seatId;
    selectedSeatNumber = seatId;
    // Hiển thị modal xác nhận
    $('#selectedSeatNumber').text(selectedSeatId);
    $('#seatConfirmationModal').modal('show');
}

function confirmSeat() {
    $('.seat.selected').removeClass('selected');
    $(`.seat[data-seat-id='${selectedSeatId}']`).addClass('selected');
    $('#seatConfirmationModal').modal('hide');
    updateSelectedSeats(selectedSeatId);
}

function cancelSeat() {
    $(`.seat[data-seat-id='${selectedSeatId}']`).removeClass('selected');
    selectedSeatId = null;
    selectedSeatNumber = '';
}

// Hàm cập nhật danh sách ghế đã chọn
function updateSelectedSeats(sNb) {

    var customer = sessionStorage.getItem('selectedCustomer');
    // sessionStorage.setItem('selectedCustomer', customer);
   

    // var cus = $('#customerp').val();

    // Lấy ID chuyến bay và tên khách hàng
    var flightId = parseInt($('#currentIdp').val());

    $.ajax({
        url: '/SeatMaps/DoSelectSeat',
        type: 'POST',
        contentType: 'application/json',
        data: JSON.stringify({
            seatNumber: sNb,
            flightId: flightId,
            customerName: customer
        }),
        success: function (response) {
            loadSeatMapA(flightId, customer)
        },
        error: function (xhr, status, error) {
            console.error('Có lỗi xảy ra:', error);
        }
    });
}

// Gán sự kiện cho các ghế
$('.seat.available').on('click', function () {
    var seatId = $(this).data('seat-id'); // Lấy ID ghế từ phần tử được nhấp
    var isBooked = $(this).hasClass('booked');

    if (!isBooked) {
        selectSeat(seatId); // Gọi hàm chọn ghế
    }
});


