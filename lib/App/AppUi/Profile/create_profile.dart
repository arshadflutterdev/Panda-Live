import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pandlive/App/Routes/app_routes.dart';
import 'package:pandlive/App/Widgets/Buttons/elevatedbutton0.dart';
import 'package:pandlive/App/Widgets/TextFields/textfield.dart';
import 'package:pandlive/Utils/Constant/app_colours.dart';
import 'package:pandlive/Utils/Constant/app_heightwidth.dart';
import 'package:pandlive/Utils/Constant/app_images.dart';
import 'package:pandlive/Utils/Constant/app_style.dart';

class CreateProfile extends StatefulWidget {
  const CreateProfile({super.key});

  @override
  State<CreateProfile> createState() => _CreateProfileState();
}

class _CreateProfileState extends State<CreateProfile> {
  RxBool isloading = false.obs;
  final _formkey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  RxInt isSelected = 0.obs;
  //image picker
  Rxn<File> image = Rxn<File>();

  Future<void> imagepic() async {
    ImagePicker picker = ImagePicker();
    final XFile? images = await picker.pickImage(source: ImageSource.gallery);
    if (images == null) {
      return;
    }

    image.value = File(images!.path);
    print("here is image path $image");
  }

  //dialog box for countries
  void selectCountry() {
    // All country names
    List<String> countries = [
      "Afghanistan",
      "Albania",
      "Algeria",
      "Andorra",
      "Angola",
      "Antigua and Barbuda",
      "Argentina",
      "Armenia",
      "Australia",
      "Austria",
      "Azerbaijan",
      "The Bahamas",
      "Bahrain",
      "Bangladesh",
      "Barbados",
      "Belarus",
      "Belgium",
      "Belize",
      "Benin",
      "Bhutan",
      "Bolivia",
      "Bosnia and Herzegovina",
      "Botswana",
      "Brazil",
      "Brunei",
      "Bulgaria",
      "Burkina Faso",
      "Burundi",
      "Cabo Verde",
      "Cambodia",
      "Cameroon",
      "Canada",
      "Central African Republic",
      "Chad",
      "Chile",
      "China",
      "Colombia",
      "Comoros",
      "Costa Rica",
      "Côte d'Ivoire",
      "Croatia",
      "Cuba",
      "Cyprus",
      "Czech Republic",
      "Democratic Republic of the Congo",
      "Denmark",
      "Djibouti",
      "Dominica",
      "Dominican Republic",
      "Ecuador",
      "Egypt",
      "El Salvador",
      "Equatorial Guinea",
      "Eritrea",
      "Estonia",
      "Eswatini",
      "Ethiopia",
      "Fiji",
      "Finland",
      "France",
      "Gabon",
      "Gambia",
      "Georgia",
      "Germany",
      "Ghana",
      "Greece",
      "Grenada",
      "Guatemala",
      "Guinea",
      "Guinea-Bissau",
      "Guyana",
      "Haiti",
      "Honduras",
      "Hungary",
      "Iceland",
      "India",
      "Indonesia",
      "Iran",
      "Iraq",
      "Ireland",
      "Israel",
      "Italy",
      "Jamaica",
      "Japan",
      "Jordan",
      "Kazakhstan",
      "Kenya",
      "Kiribati",
      "Kuwait",
      "Kyrgyzstan",
      "Laos",
      "Latvia",
      "Lebanon",
      "Lesotho",
      "Liberia",
      "Libya",
      "Liechtenstein",
      "Lithuania",
      "Luxembourg",
      "Madagascar",
      "Malawi",
      "Malaysia",
      "Maldives",
      "Mali",
      "Malta",
      "Marshall Islands",
      "Mauritania",
      "Mauritius",
      "Mexico",
      "Micronesia",
      "Moldova",
      "Monaco",
      "Mongolia",
      "Montenegro",
      "Morocco",
      "Mozambique",
      "Myanmar",
      "Namibia",
      "Nauru",
      "Nepal",
      "Netherlands",
      "New Zealand",
      "Nicaragua",
      "Niger",
      "Nigeria",
      "North Korea",
      "North Macedonia",
      "Norway",
      "Oman",
      "Pakistan",
      "Palau",
      "Panama",
      "Papua New Guinea",
      "Paraguay",
      "Peru",
      "Philippines",
      "Poland",
      "Portugal",
      "Qatar",
      "Romania",
      "Russia",
      "Rwanda",
      "Saint Kitts and Nevis",
      "Saint Lucia",
      "Saint Vincent and the Grenadines",
      "Samoa",
      "San Marino",
      "Sao Tome and Principe",
      "Saudi Arabia",
      "Senegal",
      "Serbia",
      "Seychelles",
      "Sierra Leone",
      "Singapore",
      "Slovakia",
      "Slovenia",
      "Solomon Islands",
      "Somalia",
      "South Africa",
      "South Korea",
      "South Sudan",
      "Spain",
      "Sri Lanka",
      "Sudan",
      "Suriname",
      "Sweden",
      "Switzerland",
      "Syria",
      "Taiwan",
      "Tajikistan",
      "Tanzania",
      "Thailand",
      "Timor-Leste",
      "Togo",
      "Tonga",
      "Trinidad and Tobago",
      "Tunisia",
      "Turkey",
      "Turkmenistan",
      "Tuvalu",
      "Uganda",
      "Ukraine",
      "United Arab Emirates",
      "United Kingdom",
      "United States",
      "Uruguay",
      "Uzbekistan",
      "Vanuatu",
      "Vatican City",
      "Venezuela",
      "Vietnam",
      "Yemen",
      "Zambia",
      "Zimbabwe",
    ];

    // Copy for search filtering
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
            height: 400, // dialog height
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                // Search Bar
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 50,
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
                ),

                // List of countries
                Expanded(
                  child: Obx(
                    () => ListView.builder(
                      itemCount: filteredCountries.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          dense: true,

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

  Future<void> pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue, // header background
              onPrimary: Colors.white, // header text color
              onSurface: Colors.black, // body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue, // button color
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      String formattedDate =
          "${pickedDate.day.toString().padLeft(2, '0')}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.year}";
      setState(() {
        dobController.text = formattedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = AppHeightwidth.screenHeight(context);
    double width = AppHeightwidth.screenWidth(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Image(fit: BoxFit.cover, image: AssetImage(AppImages.halfbg)),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Complete personal data",
                              style: AppStyle.btext.copyWith(
                                fontSize: width * 0.066,
                              ),
                            ),
                            Text(
                              "Let everyone know you better",
                              style: AppStyle.halfblacktext,
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Obx(
                              () => Container(
                                height: 70,
                                width: 70,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.black26,
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: image.value != null
                                        ? FileImage(image.value!)
                                              as ImageProvider
                                        : AssetImage(AppImages.girl),
                                  ),
                                ),
                                child: Stack(
                                  children: [
                                    Positioned(
                                      bottom: -15,
                                      right: -2,
                                      child: IconButton(
                                        onPressed: () {
                                          imagepic();
                                        },
                                        icon: Icon(
                                          Icons.camera_alt,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            Text("Profile", style: AppStyle.halfblacktext),
                          ],
                        ),
                      ],
                    ),

                    Text("Name", style: AppStyle.halfblacktext),
                    Gap(5),
                    Form(
                      key: _formkey,
                      child: Column(
                        children: [
                          MyTextFormField(
                            validator: (value) {
                              if (nameController.text.isEmpty) {
                                return "Enter your name";
                              } else if (nameController.text.length < 6) {
                                return "Name too short";
                              }
                              return null;
                            },
                            controller: nameController,
                            keyboard: TextInputType.text,
                            hintext: "Enter Your Name",
                          ),
                          Gap(7),
                          Text("Date of Birth", style: AppStyle.halfblacktext),
                          Gap(5),
                          MyTextFormField(
                            read: true,
                            ontapp: () {
                              pickDate();
                            },
                            controller: dobController,
                            keyboard: TextInputType.datetime,
                            hintext: "DD-MM-YYYY",
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Add your date of birth";
                              }

                              return null; // ✅ valid
                            },
                          ),

                          Gap(7),
                          Row(
                            children: [
                              Text("Country", style: AppStyle.halfblacktext),
                              Text(" 👀 "),
                              Text(
                                "not to be altered once set",
                                style: AppStyle.halfblacktext.copyWith(
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                          Gap(5),
                          MyTextFormField(
                            controller: countryController,
                            read: true,
                            ontapp: selectCountry,
                            keyboard: TextInputType.text,
                            hintext: "Select Your Country",
                          ),
                        ],
                      ),
                    ),
                    Gap(7),
                    Row(
                      children: [
                        Text("Gender", style: AppStyle.halfblacktext),
                        Text(" 👀 "),
                        Text(
                          "not to be altered once set",
                          style: AppStyle.halfblacktext.copyWith(fontSize: 13),
                        ),
                      ],
                    ),
                    Gap(5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            isSelected.value = 1;
                          },
                          child: Obx(
                            () => Container(
                              height: height * 0.075,
                              width: width * 0.45,
                              decoration: BoxDecoration(
                                color: isSelected.value == 1
                                    ? Colors.blue.shade100
                                    : AppColours.greycolour,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  Gap(width * 0.050),
                                  Text("Male", style: AppStyle.btext),
                                  Spacer(),
                                  Image(
                                    // color: Colors.white,
                                    image: AssetImage(AppImages.boy),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        GestureDetector(
                          onTap: () {
                            isSelected.value = 2;
                          },
                          child: Obx(
                            () => Container(
                              height: height * 0.075,
                              width: width * 0.45,
                              decoration: BoxDecoration(
                                color: isSelected.value == 2
                                    ? Colors.blue.shade100
                                    : AppColours.greycolour,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  Gap(width * 0.050),
                                  Text("Female", style: AppStyle.btext),
                                  Spacer(),
                                  Image(
                                    // color: Colors.white,
                                    image: AssetImage(AppImages.girl),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Gap(height * 0.015),
                    Center(
                      child: MyElevatedButton(
                        width: width,
                        btext: isloading.value
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text(
                                "Submit",
                                style: AppStyle.btext.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                        onPressed: () {
                          if (_formkey.currentState!.validate()) {
                            isloading.value = true;
                            Timer(Duration(seconds: 2), () {
                              isloading.value = false;
                              Get.toNamed(AppRoutes.createprofile);
                            });
                          }
                        },
                      ),
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
}
