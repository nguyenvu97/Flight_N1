var airline = {
    placeholder: "Chọn hãng hàng không",
    ajax: {
        url: '/Airline/Search/',
        dataType: 'json',
        delay: 250,
        data: function(params) {
            return {
                key: params.term, 
            };
        },
        processResults: function(data) {
            console.log(data); 
            return {
                results: $.map(data.$values, function(item) {
                    return {
                        id: item.id,
                        text: item.name + " (" + item.code + ")"
                    };
                })
            };
        },
        cache: false
    }
};

var airlineaction = {
    placeholder: "Chọn hãng hàng không",
    dropdownParent: $("#ctrModal"),
    ajax: {
        url: '/Airline/Search/',
        dataType: 'json',
        delay: 250,
        data: function(params) {
            return {
                key: params.term,
            };
        },
        processResults: function(data) {
            console.log(data);
            return {
                results: $.map(data.$values, function(item) {
                    return {
                        id: item.id,
                        text: item.name + " (" + item.code + ")"
                    };
                })
            };
        },
        cache: false
    }
};


var flights = {
    placeholder: "Tìm chuyến bay",
    dropdownParent: $("#ctrModal"),
    ajax: {
        url: '/FlightSegment/Search/',
        dataType: 'json',
        delay: 250,
        data: function(params) {
            return {
                key: params.term,
            };
        },
        processResults: function(data) {
            console.log(data);
            return {
                results: $.map(data.$values, function(item) {
                    return {
                        id: item.TripId,
                        text: item.FromCity +"-"+ item.ToCity + "(" + item.DepartureTime.toString() + item.ArrivalTime.toString() + ")"
                    };
                })
            };
        },
        cache: false
    }
};


var airportIndex = {
    placeholder: "Chọn sân bay",
    ajax: {
        url: '/Airport/Search/',
        dataType: 'json',
        delay: 250,
        data: function(params) {
            return {
                key: params.term,
            };
        },
        processResults: function(data) {
            console.log(data);
            return {
                results: $.map(data.$values, function(item) {
                    return {
                        id: item.id,
                        text: item.name
                    };
                })
            };
        },
        cache: false
    }
};

var airport = {
    placeholder: "Chọn sân bay",
    dropdownParent: $("#ctrModal"),
    ajax: {
        url: '/Airport/Search/',
        dataType: 'json',
        delay: 250,
        data: function(params) {
            return {
                key: params.term,
            };
        },
        processResults: function(data) {
            console.log(data);
            return {
                results: $.map(data.$values, function(item) {
                    return {
                        id: item.id,
                        text:item.name
                    };
                })
            };
        },
        cache: false
    }
};

var aircarf = {
    placeholder: "Chọn máy bay",
    dropdownParent: $("#ctrModal"),
    ajax: {
        url: '/Aircarf/Search/',
        dataType: 'json',
        delay: 250,
        data: function(params) {
            return {
                key: params.term,
            };
        },
        processResults: function(data) {
            return {
                results: $.map(data.$values, function(item) {
                    console.log(data.values);
                    return {
                        id: item.id,
                        text: item.type + " (" + item.code + ")"
                    };
                })
            };
        },
        cache: false
    }
};

var aircarfIndex = {
    placeholder: "Chọn máy bay",
    ajax: {
        url: '/Aircarf/Search/',
        dataType: 'json',
        delay: 250,
        data: function(params) {
            return {
                key: params,
            };
        },
        processResults: function(data) {
            return {
                results: $.map(data.$values, function(item) {
                    //console.log(item);
                    return {
                        id: item.id,
                        text: item.type + " (" + item.code + ")"
                    };
                })
            };
        },
        cache: false
    }
};

var routes = {
    placeholder: "Chọn tuyến bay",
    dropdownParent: $("#ctrModal"),
    ajax: {
        url: '/Routes/Search/',
        dataType: 'json',
        delay: 250,
        data: function(params) {
            return {
                key: params.term,
            };
        },
        processResults: function(data) {
            console.log(data);
            return {
                results: $.map(data.$values, function(item) {
                    return {
                        id: item.id,
                        text: item.search + " (" + item.distance + ")"
                    };
                })
            };
        },
        cache: false
    }
};

var routesIndex = {
    placeholder: "Chọn tuyến bay",
    ajax: {
        url: '/Routes/Search/',
        dataType: 'json',
        delay: 250,
        data: function(params) {
            return {
                key: params.term,
            };
        },
        processResults: function(data) {
            console.log(data);
            return {
                results: $.map(data.$values, function(item) {
                    return {
                        id: item.id,
                        text: item.name + " (" + item.code + ")"
                    };
                })
            };
        },
        cache: false
    }
};

var menu = {
    placeholder: "Chọn Menu cha",
    dropdownParent: $("#ctrModal"),
    ajax: {
        url: '/Menu/Search/',
        dataType: 'json',
        delay: 250,
        data: function(params) {
            return {
                key: params,
            };
        },
        processResults: function(data) {
            return {
                results: $.map(data.$values, function(item) {
                    console.log(item);
                    return {
                        id: item.id,
                        text: item.name
                    };
                })
            };
        },
        cache: false
    }
};
