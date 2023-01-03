import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:snack_restaurant/models/item.dart';
import 'package:snack_restaurant/views/fragments/auth/login_page.dart';
import 'package:snack_restaurant/views/fragments/checkout.dart';
import 'package:snack_restaurant/views/fragments/item_detail.dart';
import 'package:snack_restaurant/views/navigation_drawer.dart';
import '../../controllers/handle_cart.dart';
import 'cart.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  static const String routeName = '/homePage';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CartController controller = Get.find();

  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavigationDrawer(),
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SnackBanner(),
                const Text(
                  'Menu',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 16.0),
                StreamBuilder<List<Item>>(
                  stream: readItems(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Something went wrong! ${snapshot.error}');
                    }
                    if (snapshot.hasData) {
                      final items = snapshot.data!;
                      return Expanded(
                        child: ListView(
                          physics: const BouncingScrollPhysics(),
                          children: items.map(_buildItem).toList(),
                        ),
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
                const SizedBox(height: 70),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              color: Colors.transparent,
              height: 90,
              padding: const EdgeInsets.all(20),
              child: Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        if (auth.currentUser == null) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()));
                        } else {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Cart()));
                        }
                      },
                      icon: const Icon(Icons.shopping_basket_outlined),
                      label: Text(
                        '${controller.items.length}',
                        style: TextStyle(fontSize: 18),
                      ),
                      style: ElevatedButton.styleFrom(
                          onPrimary: Colors.indigo,
                          primary: Colors.white,
                          minimumSize: const Size(100, 50),
                          side:
                              const BorderSide(color: Colors.indigo, width: 1)),
                    ),
                    ElevatedButton(
                      onPressed: controller.items.length == 0
                          ? null
                          : () {
                              if (auth.currentUser == null) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginPage()));
                              } else {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const Checkout()));
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        onPrimary: Colors.white,
                        primary: Colors.indigo,
                        minimumSize: const Size(180, 50),
                        onSurface: Colors.grey.shade600,
                      ),
                      child: const Text('Checkout',
                          style: TextStyle(fontSize: 16)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(Item item) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ItemDetail(item: item)),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(top: 10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(width: 1.0, color: Colors.grey.shade300))),
        height: 100.0,
        width: double.infinity,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      item.title,
                      style:
                          const TextStyle(fontSize: 16.0, color: Colors.black),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      softWrap: false,
                    ),
                    Text(
                      item.description,
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.grey.shade600,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      softWrap: false,
                    ),
                    const Spacer(),
                    Text(
                      NumberFormat.currency(locale: 'vi').format(item.price),
                      style:
                          const TextStyle(fontSize: 14.0, color: Colors.black),
                    )
                  ],
                ),
              ),
              const SizedBox(width: 16.0),
              if (item.imgLink != '')
                Container(
                  width: 85.0,
                  height: 85.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    image: DecorationImage(
                      image: NetworkImage(item.imgLink),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
            ]),
      ),
    );
  }

  Stream<List<Item>> readItems() => FirebaseFirestore.instance
      .collection('items')
      .orderBy('title')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Item.fromJson(doc.data())).toList());
}

class SnackBanner extends StatefulWidget {
  const SnackBanner({Key? key}) : super(key: key);
  State<SnackBanner> createState() => _SnackBannerState();
}

class _SnackBannerState extends State<SnackBanner> {
  int activeIndex = 0;
  final imgBanner = [
    'assets/banner1.jpg',
    'assets/banner2.jpg',
    'assets/banner3.jpg',
    'assets/banner4.jpg',
    'assets/banner5.png',
    'assets/banner6.jpg',
  ];
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CarouselSlider.builder(
            itemCount: imgBanner.length,
            options: CarouselOptions(
              height: 120,
              enlargeCenterPage: false,
              autoPlay: true,
              aspectRatio: 16 / 7,
              autoPlayCurve: Curves.fastOutSlowIn,
              enableInfiniteScroll: false,
              autoPlayAnimationDuration: Duration(milliseconds: 800),
              viewportFraction: 1,
              onPageChanged: (index, reaspn) =>
                  setState(() => activeIndex = index),
            ),
            itemBuilder: (BuildContext context, int index, int realIndex) {
              final _imgBanner = imgBanner[index];

              return buildImage(_imgBanner, index);
            },
          ),
          const SizedBox(height: 10),
          buildIndicator(),
        ],
      ),
    );
  }

  Widget buildImage(String imgBanner, int index) => Container(
          child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          //set border radius to 50% of square height and width
          image: DecorationImage(
            image: AssetImage(imgBanner),
            fit: BoxFit.cover, //change image fill type
          ),
        ),
      ));

  buildIndicator() => AnimatedSmoothIndicator(
        activeIndex: activeIndex,
        count: imgBanner.length,
        effect: SlideEffect(
            spacing: 5.0,
            radius: 4.0,
            dotWidth: 10.0,
            dotHeight: 2.0,
            dotColor: Colors.grey.shade300,
            activeDotColor: Colors.grey),
      );
}
