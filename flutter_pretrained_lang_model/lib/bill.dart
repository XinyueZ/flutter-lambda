import 'dart:io';

class Bill {
  final String priceText;
  final double price;
  final String dateText;
  final FileSystemEntity invoiceFile;

  Bill(this.invoiceFile)
      : priceText = "",
        price = 0,
        dateText = "";

  Bill.from(this.priceText, this.price, this.dateText, this.invoiceFile);
}

class BillOverview {
  double totalPrice;
  List<Bill> billList;

  BillOverview(this.totalPrice, this.billList);

  BillOverview.from(this.totalPrice, this.billList);

  release() {
    totalPrice = 0;
    billList?.clear();
  }
}
