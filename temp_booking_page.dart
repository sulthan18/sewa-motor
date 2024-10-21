import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:sewa_motor/models/bike.dart';
import 'package:sewa_motor/widgets/button_primary.dart';
import 'package:sewa_motor/widgets/input.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({super.key, required this.bike});
  final Bike bike;

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final edtName = TextEditingController();
  final edtStartDate = TextEditingController();
  final edtEndDate = TextEditingController();
  int selectedIndex = 1;

  pickDate(TextEditingController editingController) {
    showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      initialDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) return;

      editingController.text = DateFormat('dd MMM yyyy').format(pickedDate);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(0),
        children: [
          Gap(20 + MediaQuery.of(context).padding.top),
          buildHeader(),
          const Gap(24),
          buildSnippetBike(),
          const Gap(24),
          buildInput(),
          const Gap(24),
          buildAgency(),
          const Gap(24),
          buildInsurance(),
          const Gap(24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ButtonPrimary(
                text: 'Proceed to Checkout',
                onTap: () {
                  Navigator.pushNamed(context, '/checkout', arguments: {
                    'bike': widget.bike,
                    'startDate': edtStartDate.text,
                    'endDate': edtEndDate.text,
                  });
                }),
          ),
          const Gap(30),
        ],
      ),
    );
  }

  Widget buildInsurance() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Insurance',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xff070623),
            ),
          ),
          const Gap(12),
          SizedBox(
            height: 52,
            child: DropdownButtonFormField(
              value: 'Select available insurance',
              icon: Image.asset(
                'assets/ic_arrow_down.png',
                width: 20,
                height: 20,
              ),
              items: [
                'Select available insurance',
                'Allianz Indonesia',
                'Astra Life',
                'Prudential Indonesia',
                'Manulife Indonesia',
              ].map((e) {
                return DropdownMenuItem(
                  value: e,
                  child: Text(
                    e,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff070623),
                    ),
                  ),
                );
              }).toList(),
              onChanged: (value) {},
              decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(right: 16),
                  prefixIcon: UnconstrainedBox(
                    alignment: const Alignment(0.2, 0),
                    child: Image.asset(
                      'assets/ic_insurance.png',
                      width: 24,
                      height: 24,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: const BorderSide(
                        width: 2,
                        color: Color(0xff4A1DFF),
                      ))),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildAgency() {
    final listAgency = ['RapidRev', 'DriftLab', 'Zenith Rides'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'Agency',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xff070623),
            ),
          ),
        ),
        const Gap(12),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: listAgency.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedIndex = index;
                  });
                },
                child: Container(
                  width: 120,
                  margin: EdgeInsets.only(
                    left: index == 0 ? 24 : 8,
                    right: index == listAgency.length - 1 ? 24 : 8,
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
                        'assets/agency.png',
                        width: 38,
                        height: 38,
                      ),
                      const Gap(10),
                      Text(
                        listAgency[index],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff070623),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget buildInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Complete Name',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xff070623),
            ),
          ),
          const Gap(12),
          Input(
              icon: 'assets/ic_profile.png',
              hint: 'Write your name',
              editingController: edtName),
          const Gap(16),
          const Text(
            'Start Rent Date',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xff070623),
            ),
          ),
          const Gap(12),
          Input(
            icon: 'assets/ic_calendar.png',
            hint: 'Choose your date',
            editingController: edtStartDate,
            enable: false,
            onTapBox: () => pickDate(edtStartDate),
          ),
          const Gap(16),
          const Text(
            'End Date',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xff070623),
            ),
          ),
          const Gap(12),
          Input(
            icon: 'assets/ic_calendar.png',
            hint: 'Choose your date',
            editingController: edtEndDate,
            enable: false,
            onTapBox: () => pickDate(edtEndDate),
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
              'Booking',
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
}
