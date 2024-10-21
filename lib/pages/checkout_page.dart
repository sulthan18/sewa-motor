import 'package:d_session/d_session.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:sewa_motor/models/account.dart';
import 'package:sewa_motor/models/bike.dart';
import 'package:sewa_motor/widgets/button_primary.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage(
      {super.key,
      required this.bike,
      required this.startDate,
      required this.endDate});
  final Bike bike;
  final String startDate;
  final String endDate;

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  num balance = 85000000; // Default balance value
  int selectedIndex = 0; // Selected payment method index

  late double grandTotal;
  late int duration;
  bool showError = false; // Flag to control error message visibility

  @override
  void initState() {
    super.initState();
    duration = _calculateDuration();
    grandTotal = _calculateGrandTotal();
  }

  int _calculateDuration() {
    DateTime start = DateFormat('dd MMM yyyy').parse(widget.startDate);
    DateTime end = DateFormat('dd MMM yyyy').parse(widget.endDate);
    return end.difference(start).inDays;
  }

  double _calculateGrandTotal() {
    double subTotal = widget.bike.price * duration;
    double insurance = subTotal * 0.10;
    double tax = (subTotal + insurance) * 0.11;
    return subTotal + insurance + tax;
  }

  void _updateBalance(int index) {
    switch (index) {
      case 0:
        balance = 85000000;
        break;
      case 1:
        balance = 10000000;
        break;
      case 2:
        balance = 5000000;
        break;
      default:
        balance = 0;
    }
  }

  void checkoutNow() {
    if (selectedIndex == 0 && balance >= grandTotal) {
      Navigator.pushNamed(context, '/pin', arguments: widget.bike);
    } else {
      setState(() {
        showError = true; // Show the error message
      });

      Future.delayed(const Duration(seconds: 3), () {
        setState(() {
          showError = false; // Hide the error message after 3 seconds
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(0),
            children: [
              Gap(20 + MediaQuery.of(context).padding.top),
              buildHeader(),
              const Gap(24),
              buildSnippetBike(),
              const Gap(24),
              buildDetails(),
              const Gap(24),
              buildPaymentMethod(),
              const Gap(24),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: ButtonPrimary(
                  text: 'Checkout Now',
                  onTap: checkoutNow,
                ),
              ),
              const Gap(30),
            ],
          ),
          if (showError)
            buildErrorMessage(), // Show the error message if showError is true
        ],
      ),
    );
  }

  Widget buildErrorMessage() {
    return Positioned(
      top: 20 + MediaQuery.of(context).padding.top,
      left: 24,
      right: 24,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.red.shade400,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text(
          'Checkout failed. Insufficient balance. Please change your payment method.',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget buildPaymentMethod() {
    final payments = [
      ['Debit', 'assets/bca.png'],
      ['E-Wallet', 'assets/gopay.png'],
      ['Credit Card', 'assets/bni.png'],
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'Payment Method',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xff070623),
            ),
          ),
        ),
        const Gap(12),
        SizedBox(
          height: 130,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: payments.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedIndex = index;
                    _updateBalance(index); // Perbarui saldo saat metode dipilih
                  });
                },
                child: Container(
                  width: 120,
                  margin: EdgeInsets.only(
                    left: index == 0 ? 24 : 8,
                    right: index == payments.length - 1 ? 24 : 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: selectedIndex == index
                        ? Border.all(
                            width: 3,
                            color: const Color(0xff4A1DFF),
                          )
                        : null,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        payments[index][1],
                        width: 38,
                        height: 38,
                      ),
                      const Gap(10),
                      Text(
                        payments[index][0],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff070623),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const Gap(24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: FutureBuilder(
            future: DSession.getUser(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (!snapshot.hasData || snapshot.data == null) {
                return const Center(
                  child: Text(
                    'Failed to load account data.',
                    style: TextStyle(color: Colors.red),
                  ),
                );
              }
              Account account = Account.fromJson(Map.from(snapshot.data!));

              return Stack(
                children: [
                  Image.asset(
                    'assets/bg_wallet.png',
                    width: double.infinity,
                    fit: BoxFit.fitWidth,
                  ),
                  Positioned(
                    top: 0,
                    bottom: 0,
                    left: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Balance',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Color(0xffFFFFFF),
                          ),
                        ),
                        const Gap(6),
                        Text(
                          NumberFormat.currency(
                                  decimalDigits: 0,
                                  locale: 'id_ID',
                                  symbol: 'Rp')
                              .format(balance),
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w700,
                            color: Color(0xffFFFFFF),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    left: 20,
                    right: 20,
                    bottom: 20,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          account.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Color(0xffFFFFFF),
                          ),
                        ),
                        const Text(
                          '02/30',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Color(0xffFFFFFF),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget buildDetails() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.symmetric(
        vertical: 14,
        horizontal: 16,
      ),
      child: Column(children: [
        buildItemDetail1('Price', _formatCurrency(widget.bike.price), '/day'),
        const Gap(14),
        buildItemDetail2('Start Date', widget.startDate),
        const Gap(14),
        buildItemDetail2('End Date', widget.endDate),
        const Gap(14),
        buildItemDetail1('Duration', '$duration', ' day'),
        const Gap(14),
        buildItemDetail2(
            "Sub Total Price", _formatCurrency(widget.bike.price * duration)),
        const Gap(14),
        buildItemDetail2('Insurance 10%',
            _formatCurrency(widget.bike.price * duration * 0.10)),
        const Gap(14),
        buildItemDetail2('Tax 11%',
            _formatCurrency((widget.bike.price * duration * 1.10) * 0.11)),
        const Gap(14),
        buildItemDetail3(
          'Grand Total',
          _formatCurrency(grandTotal),
        ),
      ]),
    );
  }

  String _formatCurrency(double amount) {
    return NumberFormat.currency(
            decimalDigits: 0, locale: 'id_ID', symbol: 'Rp')
        .format(amount);
  }

  Widget buildItemDetail1(String title, String data, String unit) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Color(0xff838384),
          ),
        ),
        const Spacer(),
        Text(
          data,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xff070623),
          ),
        ),
        Text(
          unit,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Color(0xff070623),
          ),
        ),
      ],
    );
  }

  Widget buildItemDetail2(String title, String data) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Color(0xff838384),
          ),
        ),
        const Spacer(),
        Text(
          data,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xff070623),
          ),
        ),
      ],
    );
  }

  Widget buildItemDetail3(String title, String data) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Color(0xff838384),
          ),
        ),
        const Spacer(),
        Text(
          data,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xff4A1DFF),
          ),
        ),
      ],
    );
  }

  Widget buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              height: 46,
              width: 46,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              alignment: Alignment.center,
              child: Image.asset(
                'assets/ic_arrow_back.png',
                height: 24,
                width: 24,
              ),
            ),
          ),
          const Expanded(
            child: Text(
              'Checkout',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xff070623),
              ),
            ),
          ),
          Container(
            height: 46,
            width: 46,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            alignment: Alignment.center,
            child: Image.asset(
              'assets/ic_more.png',
              height: 24,
              width: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSnippetBike() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.symmetric(
        vertical: 14,
        horizontal: 16,
      ),
      height: 98,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
      ),
      child: Row(
        children: [
          ExtendedImage.network(
            widget.bike.image,
            width: 90,
            height: 70,
            fit: BoxFit.contain,
          ),
          const Gap(10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.bike.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff070623),
                  ),
                ),
                Text(
                  widget.bike.category,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff838384),
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Text(
                '${widget.bike.rating}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff070623),
                ),
              ),
              const Gap(4),
              const Icon(
                Icons.star,
                size: 20,
                color: Color(0xffFFBC1C),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
