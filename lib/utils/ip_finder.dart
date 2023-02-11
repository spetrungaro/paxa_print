import 'dart:io';

Future<String> getIP() async {
  try {
    var interface = await NetworkInterface.list(
      includeLinkLocal: false,
      includeLoopback: false,
      type: InternetAddressType.IPv4,
    );
    var ip = interface.first.addresses.first.address;
    return ip;
  } catch (e) {
    return 'localhost';
  }
}
