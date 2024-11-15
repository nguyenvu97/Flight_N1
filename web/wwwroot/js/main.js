(function ($) {

})(window.jQuery);
$(document).ready(function () {
    $('.sub-tab-item input, .navtab a').on('click', function () {
        $('#overlay').removeClass('d-none');
        $('#overlay').fadeIn();
    });

    $('#closeOverlay').on('click', function () {
        $('#overlay').fadeOut();
    });


    $('#overlay').on('click', function (e) {
        if ($(e.target).is('#overlay')) {
            $('#overlay').fadeOut();
        }
    });
    
});


function toggleForm() {
    $('.change-content').toggleClass('d-none');
    $('.toggle-icon').toggleClass('fa-angle-down fa-angle-up');
}

///date
function formatDate(date) {
    const day = date.getDate().toString().padStart(2, '0');
    const month = (date.getMonth() + 1).toString().padStart(2, '0');
    const year = date.getFullYear();
    return `${day}/${month}/${year}`;
}

function getDaysAroundRequestedDate(requestedDate) {
    const days = [];
    const date = new Date(requestedDate);

    const startDate = new Date(date);
    startDate.setDate(date.getDate() - 10);
    const endDate = new Date(date);
    endDate.setDate(date.getDate() + 10);

    let currentDate = new Date(startDate);
    while (currentDate <= endDate) {
        const hasFlight = Math.random() > 0.3;
        const price = hasFlight ? Math.floor(Math.random() * 1000000 + 300000) : null;

        days.push({
            date: new Date(currentDate),
            price: price,
            hasFlight: hasFlight,
        });

        currentDate.setDate(currentDate.getDate() + 1);
    }

    return days;
}


function renderCalendar(requestedDate) {
    const days = getDaysAroundRequestedDate(requestedDate);

    const $carousel = $('.carousel');
    $carousel.empty();

    $.each(days, (index, day) => {
        const $li = $('<li>').addClass('calendar-cell-wrapper');
        const $button = $('<button>')
            .addClass('calendar-btn')
            .data('index', index)

        if (!day.hasFlight) {
            $button.addClass('disabled').html(`
                <div class="cell-content-top inactive">Không có chuyến</div>
                <div class="cell-content-bottom">${formatDate(day.date)}</div>
            `);
        } else {
            $button.html(`
                <div class="cell-content-top price">${day.price.toLocaleString('vi-VN', {
                style: 'currency',
                currency: 'VND'
            })}</div>
                <div class="cell-content-bottom">${formatDate(day.date)}</div>
            `);
        }

        $button.on('click', function () {
            $('.calendar-btn').removeClass('selected');
            $(this).addClass('selected');
            centerSelectedDay(this);
        });

        $li.append($button);
        $carousel.append($li);
    });

    const $initialButton = $carousel.find(`button[data-index="10"]`);
    if ($initialButton.length) {
        $initialButton.addClass('selected');
        centerSelectedDay($initialButton);
    }
}

function centerSelectedDay(selectedButton) {
    const $carousel = $('.carousel');
    const $selectedLi = $(selectedButton).parent();
    const liPosition = $selectedLi.position().left - ($carousel.width() / 2) + ($selectedLi.width() / 2);
    $carousel.animate({scrollLeft: liPosition}, 'smooth');
}

$(window).on('load', function () {
    const requestedDate = new Date('2026-08-01');
    renderCalendar(requestedDate);
});


function togglePanel() {
    const content = $('#calendar-content');
    content.toggleClass('d-none');
    $('.toggle-icon-expansion-panel').toggleClass('fa-angle-up fa-angle-down');
    const buttonText = content.hasClass('d-none') ? 'Hiển thị ngày' : 'Ẩn ngày';
    $('#expansion-header-btn p').text(buttonText);
}

