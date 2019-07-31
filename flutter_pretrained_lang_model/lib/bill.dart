import 'dart:io';

class Bill {
  final String priceText;
  final String dateText;
  final FileSystemEntity invoiceFile;

  Bill(this.invoiceFile)
      : priceText = "",
        dateText = "";

  Bill.from(this.priceText, this.dateText, this.invoiceFile);
}

class BillOverview {
  double totalPrice;
  List<Bill> billList;

  BillOverview(this.totalPrice, this.billList);

  BillOverview.from(this.totalPrice, this.billList);
}
