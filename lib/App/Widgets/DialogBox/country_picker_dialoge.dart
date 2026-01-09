import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pandlive/App/Controllers/country_picker_controller.dart';
import 'package:pandlive/App/Models/country_picker_model.dart';

class CountryPickerDialog {
  static void show(BuildContext context, TextEditingController controller) {
    final isArabic = Get.locale?.languageCode == "ar";

    List<CountryModel> countries = CountryService.getCountries(context);

    RxList<CountryModel> filtered = RxList<CountryModel>.from(countries);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: SizedBox(
          height: 420,
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(
                  hintText: isArabic ? "ابحث عن الدولة" : "Search country",
                  prefixIcon: const Icon(Icons.search),
                ),
                onChanged: (v) {
                  filtered.value = countries
                      .where(
                        (c) => c.name.toLowerCase().contains(v.toLowerCase()),
                      )
                      .toList();
                },
              ),
              const SizedBox(height: 10),
              Expanded(
                child: Obx(
                  () => ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (_, i) => ListTile(
                      title: Text(
                        filtered[i].name,
                        textDirection: isArabic
                            ? TextDirection.rtl
                            : TextDirection.ltr,
                      ),
                      onTap: () {
                        controller.text = filtered[i].name;
                        Get.back();
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
