import 'package:flutter_application_4/sevice_api/Ticket_Service.dart';
import 'package:flutter_application_4/sevice_api/gex_controller/Ticket_Getx.Controller.dart';
import 'package:get/get.dart';

class Assets_Block_Controller extends GetxController {
  TicKet_Service ticKet_Service = TicKet_Service();
  Ticket_Getx_Controller tickit_controller = Get.put(Ticket_Getx_Controller());

  List<String>? getData(
      List<Map<int, String>?> seats, int flight, List<String> data_seats) {
    if (seats.isEmpty) return [];

    for (var seat in seats) {
      if (seat!.containsKey(flight)) {
        String seats_data = seat[flight]!;
        data_seats.add(seats_data);
      }
    }

    return data_seats;
  }

  var flight_go_id = [].obs;
  var flight_back_id = [].obs;
  var seats_go_1 = <String>[].obs;
  var seats_go_child_1 = <String>[].obs;
  var seats_back_1 = <String>[].obs;
  var seats_back_child_1 = <String>[].obs;
  var isblock_assets = true.obs;
  var list_block_assets = [].obs;

  void check_seats_block(String seatNumber, int index, int? flightId,
      bool choose, int? flightId_back) {
    if (flightId_back == null) {
      if (tickit_controller.flightGo.value!.id == flightId) {
        if (list_block_assets.isNotEmpty || list_block_assets != null) {
          isblock_assets.value = list_block_assets.contains(seatNumber);
        }
      } else {
        if (list_block_assets.isNotEmpty || list_block_assets != null) {
          isblock_assets.value = list_block_assets.contains(seatNumber);
        }
      }
    } else {
      if (tickit_controller.flightBack.value!.id == flightId_back) {
        if (list_block_assets.isNotEmpty || list_block_assets != null) {
          isblock_assets.value = list_block_assets.contains(seatNumber);
        }
      } else {
        if (list_block_assets.isNotEmpty || list_block_assets != null) {
          isblock_assets.value = list_block_assets.contains(seatNumber);
        }
      }
    }
  }

  void clear_data_assets() {
    flight_go_id.clear();
    flight_back_id.clear();
    flight_go_id.clear();
    flight_back_id.clear();
    seats_go_1.clear();
    seats_back_child_1.clear();
    seats_back_1.clear();
    seats_back_child_1.clear();
  }

  Future<void> add_assest() async {
    var tickit_data = tickit_controller.tickitDto.value;
    if (tickit_data == null) {
      return;
    }

    clear_data_assets();
    if (tickit_data.flightsGo != null) {
      flight_go_id.add(tickit_data.flightsGo.id);
      if (tickit_data.flightsGo.flights != null) {
        flight_go_id.add(tickit_data.flightsGo.flights!.first.id);
      }
    }
    if (tickit_data.flightsBack != null) {
      flight_back_id.add(tickit_data.flightsBack!.id);
      if (tickit_data.flightsBack!.flights != null) {
        flight_back_id.add(tickit_data.flightsBack!.flights!.first.id);
      }
    }
    var seatsGo = tickit_data.customers.map((e) => e.seatsGo).toList();
    var seats_go_child;
    if (flight_go_id.length > 1) {
      seats_go_child =
          tickit_data.customers.map((e) => e.seatsGoChild).toList();
    }

    var seats_back;
    var seats_back_child;
    if (flight_back_id.isNotEmpty) {
      seats_back = tickit_data.customers.map((e) => e.seatsBack).toList();
      if (flight_back_id.length > 1) {
        seats_back_child =
            tickit_data.customers.map((e) => e.seatsBackChild).toList();
      }
    }

    if (flight_go_id.isNotEmpty) {
      getData(seatsGo, flight_go_id.first, seats_go_1);
      await add_assets_redis(
          flight_go_id.first, tickit_data.ticketTypeGo, null, seats_go_1);
      if (flight_go_id.length > 1) {
        getData(seats_go_child, flight_go_id.first + 1, seats_go_child_1);
        await add_assets_redis(flight_go_id.last, tickit_data.ticketTypeGo,
            null, seats_go_child_1);
      }
    }

    if (flight_back_id.isNotEmpty) {
      getData(seats_back, flight_back_id.first, seats_back_1);
      await add_assets_redis(
          flight_back_id.first, null, tickit_data.ticketTypeBack, seats_back_1);
      if (flight_back_id.length > 1) {
        getData(seats_back_child, flight_back_id.last, seats_back_child_1);
        await add_assets_redis(flight_back_id.last, null,
            tickit_data.ticketTypeBack, seats_back_child_1);
      }
    }
  }

  void delete_assets_flightId() {
    if (flight_go_id.isNotEmpty) {
      delete_assets(flight_go_id.first, seats_go_1);
      if (flight_go_id.length > 1) {
        delete_assets(flight_go_id.last, seats_go_child_1);
      }
    }
    if (flight_back_id.isNotEmpty) {
      delete_assets(flight_back_id.first, seats_back_1);
      if (flight_back_id.length > 1) {
        delete_assets(flight_back_id.last, seats_back_child_1);
      }
    }
  }

  Future<void> check_assets_block(int? flight_go, int? flight_back) async {
    if (flight_back == null) {
      if (tickit_controller.isSelectTicketOneWay.value) {
        await list_asets_block(flight_go!, "Economy");
      } else {
        await list_asets_block(flight_go!, "Business");
      }
    } else {
      if (tickit_controller.isSelectbusiness.value) {
        await list_asets_block(flight_back, "Economy");
      } else {
        await list_asets_block(flight_back, "Business");
      }
    }
  }

  Future<void> list_asets_block(int flightId, String ticket_type) async {
    var response = await ticKet_Service.get_assets_block(flightId, ticket_type);
    list_block_assets.clear();
    if (response != null) {
      list_block_assets.value = response;
      return;
    } else {
      list_block_assets.value = [];
      return;
    }
  }

  // add assets in redis
  Future<void> add_assets_redis(int flightId, String? ticket_type_go,
      String? ticket_type_back, List<String> assets) async {
    var response = await ticKet_Service.block_assets(
        flightId, ticket_type_go, ticket_type_back, assets);
    await list_asets_block(flightId, ticket_type_go!);
    if (response != null && response.isEmpty || response == "ok") {
      return;
    }
  }

  //delete assets in redis
  Future<void> delete_assets(int flightId, List<String> assets) async {
    await ticKet_Service.delete_assets(flightId, assets);
  }
}
