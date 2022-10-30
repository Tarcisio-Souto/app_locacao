class Loans {
  String pat_number;
  String lo_status;
  String asset_name;
  String dt_loan;
  String dt_devolution;

  Loans({required this.pat_number, required this.lo_status, required this.asset_name, required this.dt_loan, required this.dt_devolution});

  factory Loans.fromJson(Map<String, dynamic> json) {
    return Loans(
      pat_number: json['pat_number'].toString(),
      lo_status: json['lo_status'].toString(),
      asset_name: json['asset_name'].toString(),
      dt_loan: json['dt_loan'].toString(),
      dt_devolution: json['dt_devolution'].toString(),
    );
  }
}