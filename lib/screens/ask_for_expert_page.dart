import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../constant/color.dart';
import '../home.dart';
import '../models/AskForExpertRequest.dart';
import '../provider/AreaProvider.dart';
import '../provider/AskForExpertProvider.dart';


class AskForExpertFormPage extends StatefulWidget {
  @override
  _AskForExpertFormPageFormPageState createState() => _AskForExpertFormPageFormPageState();
}

class _AskForExpertFormPageFormPageState extends State<AskForExpertFormPage> {
  final _formKey = GlobalKey<FormState>();

// Controllers for form fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _carTypeController = TextEditingController();
  final TextEditingController _carModelController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _problemDetailsController = TextEditingController();
  final TextEditingController _areaIdController = TextEditingController(); // Added for area_id
  int? _selectedAreaId;
  @override
  void initState() {
    // Fetch the areas when the screen loads
    Provider.of<AreaProvider>(context, listen: false).fetchAreas();
    super.initState();
  }
  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final provider = Provider.of<AskForExpertProvider>(context, listen: false);

      try {
        // Call the provider method to send the request
        final reservation = await provider.askForExpert(
          AskForExpertRequest(
            name: _nameController.text,
            phone: _phoneController.text,
            carType: _carTypeController.text,
            carModel: _carModelController.text,
            manufacturingYear: int.parse(_yearController.text),
            problemDetails: _problemDetailsController.text,
            areaId: int.parse(_areaIdController.text), // Pass the areaId
          ),
        );

        if (reservation != null && reservation.id > 0) {
          // Show success dialog with reservation details
          Future.microtask(() {
            showDialog(
              context: context,
              builder: (context) => Directionality(
                textDirection: TextDirection.rtl, // Set the entire dialog to RTL
                child: CarpinteonDialog(
                  title: 'تم الطلب بنجاح',
                  content: Text(
                    'رقم الحجز: ${reservation.id}\n'
                        'الاسم: ${reservation.name}\n'
                        'السيارة: ${reservation.carType} ${reservation.carModel}\n'
                        'المشكلة: ${reservation.problemDetails}',
                    style: GoogleFonts.amiri(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  onOkPressed: () {
                    // Clear the form and navigate to the HomePage
                    _formKey.currentState!.reset();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );
                  },
                  onCancelPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            );
          });
        } else {
          throw Exception('Failed to create reservation.');
        }
      } catch (e) {
        // Show error dialog in case of failure
        Future.microtask(() {
          showDialog(
            context: context,
            builder: (context) => CarpinteonDialog(
              title: 'خطأ',
              content: Text('Error: $e'),
              onOkPressed: () {
                Navigator.of(context).pop();
              },
            ),
          );
        });
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<AskForExpertProvider>().isLoading;
    final areaProvider = Provider.of<AreaProvider>(context);
    final areas = areaProvider.areas;
    return Scaffold(
      appBar: AppBar(
        title: Text('طلب خبير' ,
          style: GoogleFonts.amiri(fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.black
        ),), // Arabic title
        centerTitle: true,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl, // Set the direction to right-to-left
        child: Stack(
          children: [
            // Background image
            // SizedBox.expand(
            //   child: Image.asset(
            //     backgroundImage, // Path to background image
            //     fit: BoxFit.cover,
            //   ),
            // ),
            // Form content
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Name Field
                      SizedBox(height: 22,),
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'الاسم',
                          hintText: 'أدخل اسمك الكامل',
                          labelStyle: TextStyle(color: Colors.white), // White label text
                          hintStyle: TextStyle(color: Colors.white),  // White hint text
                          filled: true,
                          fillColor: Colors.black54,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)), // Rounded border with radius 20 when focused
                            borderSide: BorderSide(color: Colors.black54), // White border when focused
                          ),// White background with subtle transparency
                        ),
                        style: const TextStyle(color: Colors.white), // White text color
                        validator: (value) => value!.isEmpty ? 'الاسم مطلوب' : null,
                      ),
                      const SizedBox(height: 16),

                      // Phone Field
                      TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          labelText: 'رقم الهاتف',
                          hintText: 'أدخل رقم هاتفك',
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)), // Rounded border with radius 20 when focused
                            borderSide: BorderSide(color: Colors.black54), // White border when focused
                          ),
                          labelStyle: TextStyle(color: Colors.white), // White label text
                          hintStyle: TextStyle(color: Colors.white),  // White hint text
                          filled: true,
                          fillColor: Colors.black54, // White background with subtle transparency
                        ),
                        style: const TextStyle(color: Colors.white), // White text color
                        validator: (value) => value!.isEmpty ? 'رقم الهاتف مطلوب' : null,
                      ),
                      const SizedBox(height: 16),

                      // Car Type Field
                      TextFormField(
                        controller: _carTypeController,
                        decoration: const InputDecoration(
                          labelText: 'نوع السيارة',
                          hintText: 'أدخل ماركة سيارتك (مثل تويوتا)',
                          labelStyle: TextStyle(color: Colors.white), // White label text
                          hintStyle: TextStyle(color: Colors.white),  // White hint text
                          filled: true,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)), // Rounded border with radius 20 when focused
                            borderSide: BorderSide(color: Colors.black54), // White border when focused
                          ),
                          fillColor: Colors.black54,  // White background with subtle transparency
                        ),
                        style: const TextStyle(color: Colors.white), // White text color
                        validator: (value) => value!.isEmpty ? 'نوع السيارة مطلوب' : null,
                      ),
                      const SizedBox(height: 16),

                      // Car Model Field
                      TextFormField(
                        controller: _carModelController,
                        decoration: const InputDecoration(
                          labelText: 'موديل السيارة',
                          hintText: 'أدخل موديل سيارتك (مثل كورولا)',
                          labelStyle: TextStyle(color: Colors.white), // White label text
                          hintStyle: TextStyle(color: Colors.white),  // White hint text
                          filled: true,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)), // Rounded border with radius 20 when focused
                            borderSide: BorderSide(color: Colors.black54), // White border when focused
                          ),
                          fillColor: Colors.black54,  // White background with subtle transparency
                        ),
                        style: const TextStyle(color: Colors.white), // White text color
                        validator: (value) => value!.isEmpty ? 'موديل السيارة مطلوب' : null,
                      ),
                      const SizedBox(height: 16),

                      // Manufacturing Year Field
                      TextFormField(
                        controller: _yearController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'سنة الصنع',
                          hintText: 'أدخل سنة الصنع (مثل 2022)',
                          labelStyle: TextStyle(color: Colors.white), // White label text
                          hintStyle: TextStyle(color: Colors.white),  // White hint text
                          filled: true,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)), // Rounded border with radius 20 when focused
                            borderSide: BorderSide(color: Colors.black54), // White border when focused
                          ),
                          fillColor: Colors.black54,  // White background with subtle transparency
                        ),
                        style: const TextStyle(color: Colors.white), // White text color
                        validator: (value) {
                          if (value!.isEmpty) return 'سنة الصنع مطلوبة';
                          final year = int.tryParse(value);
                          if (year == null || year < 1900 || year > DateTime.now().year) {
                            return 'أدخل سنة صالحة';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      // Area Dropdown
                    DropdownButtonFormField<int>(
                      decoration: InputDecoration(
                        labelText: 'اختر المنطقة', // Label in Arabic
                        labelStyle: const TextStyle(color: Colors.white), // White label text
                        filled: true,
                        fillColor: Colors.black54, // Semi-transparent white background
                        focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)), // Rounded corners
                          borderSide: BorderSide(color: Colors.white), // White border on focus
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)), // Rounded corners
                          borderSide: BorderSide(color: Colors.black54), // Light white border
                        ),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)), // Default border with rounded corners
                        ),
                        hintStyle: const TextStyle(color: Colors.white), // White hint text
                      ),
                      value: _selectedAreaId,
                      onChanged: (int? newValue) {
                        setState(() {
                          _selectedAreaId = newValue;
                          _areaIdController.text = newValue?.toString() ?? '';
                        });
                      },
                      items: areas.map((area) {
                        return DropdownMenuItem<int>(
                          value: area.id,
                          child: Text(
                            area.name,
                            style: GoogleFonts.amiri(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black, // Black text for dropdown items
                            ),
                          ),
                        );
                      }).toList(),
                      selectedItemBuilder: (BuildContext context) {
                        return areas.map((area) {
                          return Text(
                            area.name,
                            style: GoogleFonts.amiri(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white, // White text for the selected item
                            ),
                          );
                        }).toList();
                      },
                      validator: (value) => value == null ? 'الرجاء اختيار المنطقة' : null, // Validation message in Arabic
                    ),
                      // Problem Details Field
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _problemDetailsController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: 'تفاصيل المشكلة',
                          hintText: 'صف المشكلة في سيارتك',
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)), // Rounded border with radius 20 when focused
                            borderSide: BorderSide(color: Colors.black54), // White border when focused
                          ),
                          labelStyle: TextStyle(color: Colors.white), // White label text
                          hintStyle: TextStyle(color: Colors.white),  // White hint text
                          filled: true,
                          fillColor: Colors.black54,

                        ),
                        style: const TextStyle(color: Colors.white), // White text color
                        validator: (value) => value!.isEmpty ? 'تفاصيل المشكلة مطلوبة' : null,
                      ),

                      const SizedBox(height: 24),

                      // Submit Button
                      isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : Center(
                        child: ElevatedButton(
                          onPressed: _submitForm,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 22),
                            backgroundColor: Colors.blue, // Change to your desired color
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child:  Text('إرسال الحجز'   ,
                            style: GoogleFonts.amiri(fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: white
                            ),),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class CarpinteonDialog extends StatelessWidget {
  final String title;
  final Widget content;
  final VoidCallback onOkPressed;
  final VoidCallback? onCancelPressed;

  const CarpinteonDialog({
    required this.title,
    required this.content,
    required this.onOkPressed,
    this.onCancelPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: content,
      actions: <Widget>[
        if (onCancelPressed != null)
          TextButton(
            onPressed: onCancelPressed,
            child: Text('Cancel'
              ,  style: GoogleFonts.amiri(fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black
              ),),
          ),
        TextButton(
          onPressed: onOkPressed,
          child: Text('OK',style: GoogleFonts.amiri(fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black
          ),),
        ),
      ],
    );
  }
}