// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:pbp_django_auth/pbp_django_auth.dart';
// import 'package:provider/provider.dart';
// import 'package:wara_warung_mobile/models/add_edit_menu.dart';
// import 'package:wara_warung_mobile/screens/search_screen.dart';

// class ReviewPage extends StatefulWidget {
//   final String warung;
//   final String menu;
//   final int price;
//   final String imageUrl;
//   final int id;
//   const ReviewPage({
//     required this.warung,
//     required this.menu,
//     required this.price,
//     required this.imageUrl,
//     required this.id,
//     super.key,
//   });

//   @override
//   State<ReviewPage> createState() => _ReviewPageState();
// }

// class _ReviewPageState extends State<ReviewPage> {
//   final _formKey = GlobalKey<FormState>();
//   String _menu = "";
//   int _price = 0;
//   String _imageUrl = "";
//   String _reviewText = "";
//   int _rating = 0;

//   @override
//   void initState() {
//     _menu = widget.menu;
//     _price = widget.price;
//     _imageUrl = widget.imageUrl;
//     super.initState();
//   }


//   @override
//   Widget build(BuildContext context) {
//     final request = context.watch<CookieRequest>();

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Review Menu',
//           style: GoogleFonts.poppins(
//             fontWeight: FontWeight.bold,
//             fontSize: 20,
//           ),
//         ),
//         backgroundColor: Colors.white,
//         elevation: 0,
//         centerTitle: true,
//         iconTheme: IconThemeData(color: Colors.black),
//       ),
//       backgroundColor: Color(0xFFFFFBF2),
//       body: FutureBuilder(
//         future: fetchMenuData(request),
//         builder: (context, AsyncSnapshot snapshot) {
//           if (snapshot.data == null) {
//             return const Center(child: CircularProgressIndicator());
//           } else {
//             if (!snapshot.hasData) {
//               return const Column(
//                 children: [
//                   Text(
//                     'Terjadi kesalahan mengambil data menu',
//                     style: TextStyle(fontSize: 20, color: Color(0xff59A5D8)),
//                   ),
//                   SizedBox(height: 8),
//                 ],
//               );
//             } else {
//               AddEditMenu menuData = snapshot.data;
//               return Form(
//                 key: _formKey,
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: ListView(
//                     children: [
//                       // Menu Info Section
//                       Text(
//                         'Menu Information',
//                         style: GoogleFonts.poppins(
//                             fontSize: 16, fontWeight: FontWeight.w600),
//                       ),
//                       SizedBox(height: 8),
//                       Row(
//                         children: [
//                           Container(
//                             width: 100,
//                             height: 100,
//                             color: Colors.grey.shade300,
//                             child: _imageUrl.isEmpty
//                                 ? Icon(Icons.image, color: Colors.grey)
//                                 : Image.network(_imageUrl),
//                           ),
//                           SizedBox(width: 16),
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 _menu,
//                                 style: GoogleFonts.poppins(
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               Text(
//                                 'Price: Rp $_price',
//                                 style: GoogleFonts.poppins(fontSize: 14),
//                               ),
//                             ],
//                           )
//                         ],
//                       ),
//                       SizedBox(height: 16),

//                       // Review Input
//                       Text(
//                         'Your Review',
//                         style: GoogleFonts.poppins(
//                             fontSize: 16, fontWeight: FontWeight.w600),
//                       ),
//                       SizedBox(height: 8),

//                       // Rating Input
//                       Row(
//                         children: [
//                           Text('Rating: '),
//                           SizedBox(width: 10),
//                           DropdownButton<int>(
//                             items: List.generate(5, (index) {
//                               return DropdownMenuItem(
//                                 value: index + 1,
//                                 child: Text('${index + 1}'),
//                               );
//                             }),
//                             onChanged: (value) {
//                               setState(() {
//                                 _rating = value!;
//                               });
//                             },
//                             hint: Text('Select'),
//                             value: _rating == 0 ? null : _rating,
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: 10),

//                       // Review Comment TextField
//                       TextFormField(
//                         decoration: InputDecoration(
//                           labelText: 'Comment',
//                           contentPadding: EdgeInsets.symmetric(
//                               vertical: 15, horizontal: 10),
//                           border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(8)),
//                         ),
//                         maxLines: 4,
//                         onChanged: (value) {
//                           setState(() {
//                             _reviewText = value;
//                           });
//                         },
//                       ),
//                       SizedBox(height: 16),

//                       // Buttons: Submit and Cancel
//                       Row(
//                         children: [
//                           Expanded(
//                             child: ElevatedButton(
//                               onPressed: () {
//                                 Navigator.pop(context);
//                               },
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: Colors.grey[600],
//                                 padding: EdgeInsets.symmetric(vertical: 15),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(8),
//                                 ),
//                               ),
//                               child: Text(
//                                 'Cancel',
//                                 style: GoogleFonts.poppins(
//                                     fontSize: 16, color: Colors.white),
//                               ),
//                             ),
//                           ),
//                           SizedBox(width: 16),
//                           Expanded(
//                             child: ElevatedButton(
//                               onPressed: () async {
//                                 // Handle submit action
//                                 if (_formKey.currentState!.validate()) {
//                                   final response = await request.postJson(
//                                     "https://jeremia-rangga-warawarung.pbp.cs.ui.ac.id/review/add-review/",
//                                     jsonEncode(<String, dynamic>{
//                                       'menu_id': widget.id,
//                                       'rating': _rating,
//                                       'comment': _reviewText,
//                                     }),
//                                   );
//                                   if (context.mounted) {
//                                     if (response['status'] == 'success') {
//                                       ScaffoldMessenger.of(context)
//                                           .showSnackBar(const SnackBar(
//                                         content: Text("Review submitted!"),
//                                       ));
//                                       Navigator.pop(context);
//                                     } else {
//                                       ScaffoldMessenger.of(context)
//                                           .showSnackBar(const SnackBar(
//                                         content:
//                                             Text("Error, please try again."),
//                                       ));
//                                     }
//                                   }
//                                 }
//                               },
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: Colors.orange,
//                                 padding: EdgeInsets.symmetric(vertical: 15),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(8),
//                                 ),
//                               ),
//                               child: Text(
//                                 'Submit Review',
//                                 style: GoogleFonts.poppins(
//                                     fontSize: 16, color: Colors.white),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             }
//           }
//         },
//       ),
//     );
//   }
// }
