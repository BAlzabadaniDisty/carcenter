import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../constant/color.dart';
import '../constant/images.dart';
import '../home.dart';
import '../provider/reservation_provider.dart';

class ReservationFormPage extends StatefulWidget {
  @override
  _ReservationFormPageState createState() => _ReservationFormPageState();
}

class _ReservationFormPageState extends State<ReservationFormPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for form fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _carTypeController = TextEditingController();
  final TextEditingController _carModelController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _problemDetailsController = TextEditingController();

  // Submit Form
  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final provider = Provider.of<ReservationProvider>(context, listen: false);

      try {
        // Send the request to create a reservation
        final reservation = await provider.createReservation(
          name: _nameController.text,
          phone: _phoneController.text,
          carType: _carTypeController.text,
          carModel: _carModelController.text,
          manufacturingYear: int.parse(_yearController.text),
          problemDetails: _problemDetailsController.text,
        );

        // Check the response from the provider (the API response)
        if (reservation != null && reservation.success) {
          final data = reservation.data;
// Show success dialog with the reservation details in Arabic and RTL direction
          showDialog(
            context: context,
            builder: (context) => Directionality(
              textDirection: TextDirection.rtl, // Set the entire dialog to RTL
              child: CarpinteonDialog(
                title: 'تمت الحجز بنجاح',
                content: Text(
                  'رقم الحجز: ${data?.id}\n'
                      'الاسم: ${data?.name}\n'
                      'السيارة: ${data?.carType} ${data?.carModel}\n'
                      'المشكلة: ${data?.problemDetails}',
                  style: GoogleFonts.amiri(fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black
                  ),
                ),
                onOkPressed: () {
                  // Handle the OK action (e.g., clear the form)
                  _formKey.currentState!.reset();
                  Navigator.push(context, MaterialPageRoute(builder:
                      (context) => HomePage(),));

                },
                onCancelPressed: () {
                  // Handle the Cancel action (optional)
                  Navigator.of(context).pop();
                },
              ),
            ),
          );
          // Clear the form
          _formKey.currentState!.reset();
        } else {
          throw Exception('Failed to create reservation.');
        }
      } catch (e) {
        // Show error dialog
        showDialog(
          context: context,
          builder: (context) => CarpinteonDialog(
            title: 'Error',
            content: Text('Error: $e'),
            onOkPressed: () {
              Navigator.of(context).pop();
            },
          ),
        );
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<ReservationProvider>().isLoading;

    return Scaffold(
      appBar: AppBar(
        title:  Text('خدمة حجز سيارة'   ,
          style: GoogleFonts.amiri(fontSize: 24,
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
                            borderSide: BorderSide(color: Colors.white), // White border when focused
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

                      // Problem Details Field
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

// Background image
// SizedBox.expand(
// child: Image.asset(
// backgroundImage, // Path to background image
// fit: BoxFit.cover,
// ),
// ),