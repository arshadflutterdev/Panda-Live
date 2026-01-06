import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // TextEditingController for country field
    final TextEditingController countryController = TextEditingController();

    // Function to show country dialog
    void selectCountry() {
      List<String> countries = [
        "Pakistan",
        "India",
        "USA",
        "Canada",
        "UK",
        "Australia",
        "China",
        "Japan",
        "Germany",
        "France",
        "Brazil",
        "Mexico",
        "Saudi Arabia",
        "UAE",
        "Russia",
        "Italy",
        "Spain",
        "Turkey",
        "Egypt",
        "South Africa",
      ];

      RxList<String> filteredCountries = RxList.from(countries);

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            contentPadding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            content: Container(
              width: double.maxFinite,
              height: 400,
              child: Column(
                children: [
                  // Search Bar
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Search country",
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade200,
                      ),
                      onChanged: (value) {
                        filteredCountries.value = countries
                            .where(
                              (c) =>
                                  c.toLowerCase().contains(value.toLowerCase()),
                            )
                            .toList();
                      },
                    ),
                  ),

                  // Country list
                  Expanded(
                    child: Obx(
                      () => ListView.builder(
                        itemCount: filteredCountries.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(filteredCountries[index]),
                            onTap: () {
                              countryController.text = filteredCountries[index];
                              Get.back();
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text("Select Country Example")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: countryController,
              readOnly: true,
              onTap: selectCountry,
              decoration: InputDecoration(
                hintText: "Select Your Country",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                suffixIcon: Icon(Icons.arrow_drop_down),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
