class ReceiveOtpResetPasswordResponse {
  String status;
  String message;

  ReceiveOtpResetPasswordResponse({
      this.status, 
      this.message});

  ReceiveOtpResetPasswordResponse.fromJson(dynamic json) {
    status = json["status"];
    message = json["message"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["status"] = status;
    map["message"] = message;
    return map;
  }

}