import 'package:car_rental/widgets/homePage/brand_logo.dart';
import 'package:car_rental/widgets/homePage/category.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:car_rental/widgets/homePage/car_page.dart';

Column buildTopBrands(Size size, bool isDarkMode) {
  return Column(
    children: [
      buildCategory('Top Brands', size, isDarkMode),
      Padding(
        padding: EdgeInsets.only(top: size.height * 0.015),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                Get.off(() => const CarPage(carBrand: 'Wuling'));
              },
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: buildBrandLogo(
                  Image.network(
                    'assets/icons/wuling.png',
                    height: size.width * 0.1,
                    width: size.width * 0.15,
                    fit: BoxFit.fill,
                  ),
                  size,
                  isDarkMode,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Get.off(() => const CarPage(carBrand: 'Honda'));
              },
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: buildBrandLogo(
                  Image.network(
                    'assets/icons/honda.png',
                    height: size.width * 0.12,
                    width: size.width * 0.12,
                    fit: BoxFit.fill,
                  ),
                  size,
                  isDarkMode,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Get.off(() => const CarPage(carBrand: 'Toyota'));
              },
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: buildBrandLogo(
                  Image.network(
                    'assets/icons/toyota.png',
                    height: size.width * 0.08,
                    width: size.width * 0.12,
                    fit: BoxFit.fill,
                  ),
                  size,
                  isDarkMode,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Get.off(() => const CarPage(carBrand: 'Suzuki'));
              },
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: buildBrandLogo(
                  Image.network(
                    'assets/icons/susuzki.png',
                    height: size.width * 0.12,
                    width: size.width * 0.12,
                    fit: BoxFit.fill,
                  ),
                  size,
                  isDarkMode,
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
