
import 'package:asm/models/send_data_to_api.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;

import 'tiger_in_car_state.dart';

class SendTigerInCarDataToAPI {
  submitData(TigerInCarState state) async {
    bg.Location currLocation =
        await bg.BackgroundGeolocation.getCurrentPosition();

    SendDataToAPI sendDataToAPI = SendDataToAPI();

    sendDataToAPI.submitData(currLocation, "tiger_car", state.message);
  }
}
