import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sewa_motor/controllers/browse_featured_controller.dart';
import 'package:sewa_motor/controllers/browse_newest_controller.dart';
import 'package:sewa_motor/models/bike.dart';
import 'package:sewa_motor/widgets/failed_ui.dart';

class BrowseFragment extends StatefulWidget {
  const BrowseFragment({super.key});

  @override
  State<BrowseFragment> createState() => _BrowseFragmentState();
}

class _BrowseFragmentState extends State<BrowseFragment> {
  final browseFeaturedController = Get.put(BrowseFeaturedController());
  final browseNewestController = Get.put(BrowseNewestController());

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      browseFeaturedController.fetchFeatured();
      browseNewestController.fetchNewest();
    });
    super.initState();
  }

  @override
  void dispose() {
    Get.delete<BrowseFeaturedController>(force: true);
    Get.delete<BrowseNewestController>(force: true);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(0),
      children: [
        Gap(30 + MediaQuery.of(context).padding.top),
        buildHeader(),
        const Gap(30),
        buildCategories(),
        const Gap(30),
        buildFeatured(),
        const Gap(30),
        // buildNewest(),
        const Gap(30),
        buildDailyPick(), // Add the Pick your daily section
      ],
    );
  }

  // Widget buildNewest() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       const Padding(
  //         padding: EdgeInsets.symmetric(horizontal: 24),
  //         child: Text(
  //           'Newest Bikes',
  //           style: TextStyle(
  //             fontSize: 16,
  //             fontWeight: FontWeight.w700,
  //             color: Color(0xff070623),
  //           ),
  //         ),
  //       ),
  //       const Gap(10),
  //       Obx(() {
  //         String status =
  //             browseNewestController.status; // Correct controller here
  //         if (status == '') return const SizedBox();
  //         if (status == 'loading') {
  //           return const Center(child: CircularProgressIndicator());
  //         }
  //         if (status != 'success') {
  //           return Center(child: failedUI(message: status));
  //         }
  //         List<Bike> list = browseNewestController.list; // Correct list here
  //         return SizedBox(
  //           height: 295,
  //           child: ListView.builder(
  //             itemCount: list.length,
  //             scrollDirection: Axis.horizontal,
  //             itemBuilder: (context, index) {
  //               Bike bike = list[index];
  //               final margin = EdgeInsets.only(
  //                 left: index == 0 ? 24 : 12,
  //                 right: index == list.length - 1 ? 24 : 12,
  //               );
  //               bool isJustIn = true; // Newest Bikes will have "JUST IN" badge
  //               return buildItemNewest(bike, margin, isJustIn);
  //             },
  //           ),
  //         );
  //       }),
  //     ],
  //   );
  // }

  Widget buildDailyPick() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'Pick your daily',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xff070623),
            ),
          ),
        ),
        const Gap(10),
        Obx(() {
          String status =
              browseFeaturedController.status; // Use Featured Controller
          if (status == '') return const SizedBox();
          if (status == 'loading') {
            return const Center(child: CircularProgressIndicator());
          }
          if (status != 'success') {
            return Center(child: failedUI(message: status));
          }
          List<Bike> list = browseFeaturedController.list; // Use Featured list
          return SizedBox(
            height: 295,
            child: ListView.builder(
              itemCount: list.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                Bike bike = list[index];
                final margin = EdgeInsets.only(
                  left: index == 0 ? 24 : 12,
                  right: index == list.length - 1 ? 24 : 12,
                );
                bool isDailyPick =
                    true; // All bikes will have "DAILY PICK" badge
                return buildItemDailyPick(bike, margin, isDailyPick);
              },
            ),
          );
        }),
      ],
    );
  }

  Widget buildFeatured() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'Top Trend',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xff070623),
            ),
          ),
        ),
        const Gap(10),
        Obx(() {
          String status = browseFeaturedController.status;
          if (status == '') return const SizedBox();
          if (status == 'loading') {
            return const Center(child: CircularProgressIndicator());
          }
          if (status != 'success') {
            return Center(child: failedUI(message: status));
          }
          List<Bike> list = browseFeaturedController.list;
          return SizedBox(
            height: 295,
            child: ListView.builder(
              itemCount: list.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                Bike bike = list[index];
                final margin = EdgeInsets.only(
                  left: index == 0 ? 24 : 12,
                  right: index == list.length - 1 ? 24 : 12,
                );
                bool isTrending = true; // Set to true for all items in Trending
                return buildItemFeatured(bike, margin, isTrending);
              },
            ),
          );
        }),
      ],
    );
  }

  Widget buildItemNewest(Bike bike, EdgeInsetsGeometry margin, bool isJustIn) {
    return buildBikeItem(
        bike, margin, 'JUST IN', const Color(0xff008C8C)); // Newest Bikes Badge
  }

  Widget buildItemDailyPick(
      Bike bike, EdgeInsetsGeometry margin, bool isDailyPick) {
    return buildBikeItem(bike, margin, 'DAILY PICK',
        const Color(0xff1E90FF)); // Daily Pick Badge
  }

  Widget buildItemFeatured(
      Bike bike, EdgeInsetsGeometry margin, bool isTrending) {
    return buildBikeItem(bike, margin, 'TRENDING',
        const Color(0xffFF2055)); // Featured Bikes Badge
  }

  Widget buildBikeItem(Bike bike, EdgeInsetsGeometry margin, String badgeText,
      Color badgeColor) {
    return Container(
      width: 252,
      margin: margin,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Stack(
            children: [
              ExtendedImage.network(
                bike.image,
                width: 220,
                height: 170,
              ),
              Container(
                decoration: BoxDecoration(
                  color: badgeColor,
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: [
                    BoxShadow(
                      offset: const Offset(0, 4),
                      blurRadius: 10,
                      color: badgeColor.withAlpha(128),
                    )
                  ],
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 6,
                  horizontal: 14,
                ),
                child: Text(
                  badgeText,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.italic,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bike.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff070623),
                      ),
                    ),
                    const Gap(4),
                    Text(
                      bike.category,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff838384),
                      ),
                    ),
                  ],
                ),
              ),
              RatingBar.builder(
                initialRating: bike.rating.toDouble(),
                itemPadding: const EdgeInsets.all(0),
                itemSize: 16,
                unratedColor: Colors.grey[300],
                allowHalfRating: true,
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Color(0xffFFBC1C),
                ),
                ignoreGestures: true,
                onRatingUpdate: (value) {},
              ),
            ],
          ),
          const Gap(16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                NumberFormat.currency(
                  decimalDigits: 0,
                  locale: 'id_ID',
                  symbol: 'Rp',
                ).format(bike.price),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xff6747E9),
                ),
              ),
              const Text(
                '/day',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff838384),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildCategories() {
    final categories = [
      ['City', 'assets/ic_city.png'],
      ['Downhill', 'assets/ic_downhill.png'],
      ['Beach', 'assets/ic_beach.png'],
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'Categories',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xff070623),
            ),
          ),
        ),
        const Gap(10),
        SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.only(left: 24),
            child: Row(
              children: categories.map((e) {
                return Container(
                  height: 52,
                  margin: const EdgeInsets.only(right: 24),
                  padding: const EdgeInsets.fromLTRB(16, 14, 30, 14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.white,
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        e[1],
                        width: 24,
                        height: 24,
                      ),
                      const Gap(10),
                      Text(
                        e[0],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff070623),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(
            'assets/logo_text.png',
            height: 38,
            fit: BoxFit.fitHeight,
          ),
          Container(
            height: 46,
            width: 46,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Image.asset(
              'assets/ic_notification.png',
              height: 24,
              width: 24,
            ),
          ),
        ],
      ),
    );
  }
}
