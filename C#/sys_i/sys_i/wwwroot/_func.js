
var currentlyOpenMenu = null;
document.querySelectorAll('[data-bs-toggle="collapse"]').forEach(function (toggle) {
    toggle.addEventListener('click', function (event) {
        event.preventDefault(); 

        const collapseId = this.getAttribute('href').substring(1);
        const collapseElement = document.getElementById(collapseId);
        
        if (currentlyOpenMenu && currentlyOpenMenu !== collapseElement) {
            currentlyOpenMenu.classList.remove('show');
        }
        if (collapseElement.classList.contains('show')) {
            collapseElement.classList.remove('show');
            currentlyOpenMenu = null; 
        } else {
            collapseElement.classList.add('show');
            currentlyOpenMenu = collapseElement; 
        }
    });
});


function changeTarget(el, targetId) {
    var selectElement = $(el).val();
    $('#' + targetId).val(selectElement);
}

function clearPage() {
    var form = document.getElementById('search-form');
    var elements = form.elements;

    for (var i = 0; i < elements.length; i++) {
        var element = elements[i];
        if (element.type === 'text' || element.type === 'hidden' || element.type === 'date') {
            element.value = ''; 
        } else if (element.tagName === 'SELECT') {
        element.selectedIndex = -1; 
        }
        
        $("#current_page").val(1);
    }
    doPaging();
}
function loadModuleModal(url) {
    $.get(url, function (data) {
        bindModal('#ctrModal', data);
    });
}

function bindModal(modalId, data) {
    if (modalId.indexOf('#') != 0)
        modalId = "#" + modalId;
    $(modalId + ' .modal-dialog').html(data);
    $(modalId).modal('show');
}

function closeModal(modalId) {
    if (modalId.indexOf('#') != 0)
        modalId = "#" + modalId;
    $(modalId).modal('hide');
}


function getCurrentPage() {
    $('body,html').animate({
        scrollTop: 0
    }, 500);
    return parseInt($('#current_page').val()) || 1;
}
function setCurrentPage(v) {
    if (v < 1) v = 1;
    $('#current_page').val(v);
}
function getCurrentPageSize() {
    return $('#PagingModel_pageSize').val();
}
function setCurrentPageSize(v) {
    $('#PagingModel_pageSize').val(v);
}

function loadPageSize(s) {
    $('.current-pagesize').text(s);
    $('#PagingModel_pageSize').val(s);
}
//set new values when paging succeed
function setPageConfig(pt, pi, ps) {
    $("#PagingModel_total").val(pt);
    $("#PagingModel_pageIndex").val(pi);
    $("#PagingModel_pageSize").val(ps);
    $("#search-form .current-pagesize").val(ps);
    setCurrentPage(pi);
}

function loadPageSize(s) {
    $('.current-pagesize').text(s);
    $('#PagingModel_pageSize').val(s);
}
function loadNext() {
    var pi = getCurrentPage();
    pi++;
    setCurrentPage(pi);
    reloadList();

    if (pi > 1)
        $('.btn-prev-page').removeAttr("disabled");
    else
        $('.btn-prev-page').attr("disabled", "disabled");
}
function loadPrev() {
    var pi = getCurrentPage(); pi--;
    if (pi == 0) { pi = 1; return }
    setCurrentPage(pi);
    reloadList();

    if (pi <= 1)
        $('.btn-prev-page').attr("disabled", "disabled");
    else
        $('.btn-prev-page').removeAttr("disabled");
}
function loadPage() {
    var pi = getCurrentPage();
    dofilter();
    if (pi > 1) {
        $('.btn-prev-page').removeAttr("disabled");
    } else {
        $('.btn-prev-page').attr("disabled", "disabled");
    }
}


function toggleDiv(name) {
    $(name).toggleClass('d-none');
}