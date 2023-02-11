/* License
* Copyright (c) 2019 Andrey Ushakov. All rights reserved.
* 
* Redistribution and use in source and binary forms, with or without
* modification, are permitted provided that the following conditions are
* met:
* 
*     * Redistributions of source code must retain the above copyright
*       notice, this list of conditions and the following disclaimer.
*     * Redistributions in binary form must reproduce the above
*       copyright notice, this list of conditions and the following
*       disclaimer in the documentation and/or other materials provided
*       with the distribution.
*     * Neither the name of the copyright holder nor the names of its
*       contributors may be used to endorse or promote products derived
*       from this software without specific prior written permission.
* 
* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
* "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
* LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
* A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
* OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
* SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
* LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
* DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
* THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
* (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
* OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/
import 'dart:async';
import 'dart:io';

/// [NetworkAnalyzer] class returns instances of [NetworkAddress].
///
/// Found ip addresses will have [exists] == true field.
class NetworkAddress {
  NetworkAddress(this.ip, this.exists);
  bool exists;
  String ip;
}

/// Pings a given subnet (xxx.xxx.xxx) on a given port using [discover] method.
class NetworkAnalyzer {
  /// Pings a given [subnet] (xxx.xxx.xxx) on a given [port].
  ///
  /// Pings IP:PORT one by one
  static Stream<NetworkAddress> discover(
    String subnet,
    int port, {
    Duration timeout = const Duration(milliseconds: 400),
  }) async* {
    if (port < 1 || port > 65535) {
      throw 'Incorrect port';
    }

    for (int i = 1; i < 256; ++i) {
      final host = '$subnet.$i';

      try {
        final Socket s = await Socket.connect(host, port, timeout: timeout);
        s.destroy();
        yield NetworkAddress(host, true);
      } catch (e) {
        if (e is! SocketException) {
          rethrow;
        }

        // Check if connection timed out or we got one of predefined errors
        if (e.osError == null || _errorCodes.contains(e.osError?.errorCode)) {
          yield NetworkAddress(host, false);
        } else {
          // Error 23,24: Too many open files in system
          rethrow;
        }
      }
    }
  }

  static Future<NetworkAddress> discoverOnly(
    String ip,
    int port, {
    Duration timeout = const Duration(seconds: 5),
  }) async {
    if (port < 1 || port > 65535) {
      throw 'Incorrect port';
    }
    late NetworkAddress printer;
    try {
      final socket = await _ping(ip, port, timeout);
      socket.destroy();
      printer = NetworkAddress(ip, true);
    } catch (e) {
      if (e is! SocketException) {
        rethrow;
      }

      // Check if connection timed out or we got one of predefined errors
      if (e.osError == null || _errorCodes.contains(e.osError?.errorCode)) {
        printer = NetworkAddress(ip, false);
      } else {
        // Error 23,24: Too many open files in system
        rethrow;
      }
    }
    return printer;
  }

  /// Pings a given [subnet] (xxx.xxx.xxx) on a given [port].
  ///
  /// Pings IP:PORT all at once
  static Stream<NetworkAddress> discover2(
    String subnet,
    int port, {
    Duration timeout = const Duration(seconds: 5),
  }) {
    if (port < 1 || port > 65535) {
      throw 'Incorrect port';
    }

    final out = StreamController<NetworkAddress>();
    final futures = <Future<Socket>>[];
    for (int i = 1; i < 256; ++i) {
      final host = '$subnet.$i';
      final Future<Socket> f = _ping(host, port, timeout);
      futures.add(f);
      f.then((socket) {
        socket.destroy();
        out.sink.add(NetworkAddress(host, true));
      }).catchError((dynamic e) {
        if (e is! SocketException) {
          throw e;
        }

        // Check if connection timed out or we got one of predefined errors
        if (e.osError == null || _errorCodes.contains(e.osError?.errorCode)) {
          out.sink.add(NetworkAddress(host, false));
        } else {
          // Error 23,24: Too many open files in system
          throw e;
        }
      });
    }

    Future.wait<Socket>(futures)
        .then<void>((sockets) => out.close())
        .catchError((dynamic e) => out.close());

    return out.stream;
  }

  static Future<Socket> _ping(String host, int port, Duration timeout) {
    return Socket.connect(host, port, timeout: timeout).then((socket) {
      return socket;
    });
  }

  // 13: Connection failed (OS Error: Permission denied)
  // 49: Bind failed (OS Error: Can't assign requested address)
  // 61: OS Error: Connection refused
  // 64: Connection failed (OS Error: Host is down)
  // 65: No route to host
  // 101: Network is unreachable
  // 111: Connection refused
  // 113: No route to host
  // <empty>: SocketException: Connection timed out
  static final _errorCodes = [13, 49, 61, 64, 65, 101, 111, 113];
}
