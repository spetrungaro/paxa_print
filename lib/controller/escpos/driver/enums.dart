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
class PosPrintResult {
  const PosPrintResult._internal(this.value);
  final int value;
  static const success = PosPrintResult._internal(1);
  static const timeout = PosPrintResult._internal(2);
  static const printerNotSelected = PosPrintResult._internal(3);
  static const ticketEmpty = PosPrintResult._internal(4);
  static const printInProgress = PosPrintResult._internal(5);
  static const scanInProgress = PosPrintResult._internal(6);
  static const noRouteToHost = PosPrintResult._internal(7);
  static const notImplemented = PosPrintResult._internal(8);

  String get msg {
    if (value == PosPrintResult.success.value) {
      return 'Success';
    } else if (value == PosPrintResult.timeout.value) {
      return 'Error. Printer connection timeout';
    } else if (value == PosPrintResult.printerNotSelected.value) {
      return 'Error. Printer not selected';
    } else if (value == PosPrintResult.ticketEmpty.value) {
      return 'Error. Ticket is empty';
    } else if (value == PosPrintResult.printInProgress.value) {
      return 'Error. Another print in progress';
    } else if (value == PosPrintResult.scanInProgress.value) {
      return 'Error. Printer scanning in progress';
    } else if (value == PosPrintResult.noRouteToHost.value) {
      return 'Error. No Route to host';
    } else {
      return 'Unknown error';
    }
  }
}
