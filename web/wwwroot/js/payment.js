// function togglePayment(element) {
//     const aboutPayment = element.querySelector('.about_payment');
//     const toggleIcon = element.querySelector('.toggle-icon1');
//
//     if (aboutPayment) {
//         aboutPayment.classList.toggle('hidden');
//         if (aboutPayment.classList.contains('hidden')) {
//             toggleIcon.classList.remove('fa-angle-up');
//             toggleIcon.classList.add('fa-angle-down');
//         } else {
//             toggleIcon.classList.remove('fa-angle-down');
//             toggleIcon.classList.add('fa-angle-up');
//         }
//     }
// }

function togglePayment(clickId, toggleId) {
    const clickElement = document.querySelector(clickId);
    const toggleElement = document.querySelector(toggleId);
    const toggleIcon = clickElement.querySelector('.toggle-icon1');

    if (toggleElement) {
        toggleElement.classList.toggle('hidden');
        if (toggleElement.classList.contains('hidden')) {
            toggleIcon.classList.remove('fa-angle-up');
            toggleIcon.classList.add('fa-angle-down');
        } else {
            toggleIcon.classList.remove('fa-angle-down');
            toggleIcon.classList.add('fa-angle-up');
        }
    }
}


function handlePayment(method, orderNo) {
    let termsCheckbox = document.getElementById('termsCheckboxVNPay');
    if (!termsCheckbox.checked) {
        alert(`Vui lòng chấp nhận điều khoản trước khi thanh toán bằng ${method}.`);
    } else {
        if (method === 'VNPay') {
            $.ajax({
                url: `/Payment/PaymentVnpay?orderNo=${orderNo}`,
                type: 'GET',
                contentType: 'application/json',
                // data: JSON.stringify(customers),
                success: function (result) {
                    console.log(result);
                    if (result.status === "200") {
                        location.href = result.url;
                    } else {
                        alert("Lỗi hệ thống");
                    }
                },
                error: function (xhr, status, error) {
                    alert("Lỗi hệ thống");
                }
            });
        }
    }
}

function clearSessionOnServer() {
    $.ajax({
        url: '/Payment/clearSecsion/',
        type: 'POST',
        contentType: 'application/json',
        success: function (result) {
            if (result.status === "200") {
                location.href = "/Home/Index";
            }
        },
        error: function (xhr, status, error) {
            console.error('Error:', error);
        }
    });
}


// window.addEventListener('beforeunload', function (event) {
//     // Nếu người dùng muốn thoát khỏi trang
//     event.preventDefault();
//     event.returnValue = ''; // Kích hoạt hộp thoại xác nhận mặc định
// });
//
// // Theo dõi hành vi "Quay lại" của trình duyệt với `popstate`
// window.addEventListener('popstate', function (event) {
//     // Xác nhận nếu người dùng sử dụng nút "Back" để thoát trang
//     const confirmExit = confirm("Bạn có muốn hủy giao dịch không?");
//     if (confirmExit) {
//         clearSessionOnServer(); // Nếu người dùng chọn OK, gọi hàm xóa session
//     } else {
//         history.pushState(null, "", location.href); // Đẩy lại trạng thái để người dùng không thoát
//     }
// });