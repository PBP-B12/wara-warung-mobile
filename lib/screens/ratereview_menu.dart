import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:wara_warung_mobile/models/review.dart';

class ReviewPage extends StatefulWidget {
  final String warung;
  final String menu;
  final int price;
  final String imageUrl;
  final int id;
  final double avgRatings;
  const ReviewPage({
    required this.warung,
    required this.menu,
    required this.price,
    required this.imageUrl,
    required this.id,
    required this.avgRatings,
    super.key,
  });

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  final _formKey = GlobalKey<FormState>();
  String _menu = "";
  String _warung = "";
  int _price = 0;
  String _imageUrl = "";
  String _reviewText = "";
  int _rating = 1;
  List<Result> _reviewResults = [];

  @override
  void initState() {
    _menu = widget.menu;
    _warung = widget.warung;
    _price = widget.price;
    _imageUrl = widget.imageUrl;
    super.initState();
  }

  Future<Review> fetchReviews(CookieRequest request) async {
    final response = await request.postJson(
        "http://127.0.0.1:8000/ratereview/menu/data",
        jsonEncode(<String, String>{
          'id': widget.id.toString(),
        }));
    Review reviewData = Review.fromJson(response);
    _reviewResults = reviewData.results;
    return reviewData;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    final username = request.getJsonData()['username'];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Menu Review',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white, // Warna teks
          ),
        ),
        backgroundColor: Colors.orange,
      ),
      backgroundColor: Color(0xFFFFFBF2),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Menu Review Section
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFFF5E6C5), // Warna atas
                      Color(0xFFFFC5A5), // Warna bawah
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Gambar dengan Shadow
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color:
                                Colors.grey.withOpacity(0.5), // Warna bayangan
                            spreadRadius: 2,
                            blurRadius: 10,
                            offset: Offset(0, 5), // Posisi bayangan
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          widget.imageUrl,
                          filterQuality: FilterQuality.low,
                          width: 150,
                          height: 150,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Column(
                              children: [
                                const Icon(Icons.error_outline_sharp),
                                Text(
                                  'Fail to Load this Image',
                                  style: GoogleFonts.poppins(),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    // Nama Menu
                    Text(
                      widget.menu,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    // Nama Warung
                    Text(
                      'at ${widget.warung}',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFFFF7124),
                      ),
                    ),
                    SizedBox(height: 10),
                    // Harga Menu
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          'Price: Rp ${widget.price}',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    // Rata-Rata Rating
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          'Avg. Rate: ${widget.avgRatings} / 5.0',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              // Submit Review Section
              if (username != null)
                Text(
                  'Submit a review:',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFF7124), // Warna teks
                  ),
                ),
              if (username != null) SizedBox(height: 10),
              if (username != null)
                Form(
                  key: _formKey,
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Color(0xFFFFEAD7), // Warna latar belakang kotak
                      borderRadius:
                          BorderRadius.circular(16), // Sudut melengkung
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Rating Dropdown
                        Row(
                          children: [
                            Text(
                              'Rate:',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(width: 10),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                color: Colors.white, // Warna latar dropdown
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Colors.grey.shade300, // Warna border
                                  width: 1,
                                ),
                              ),
                              child: DropdownButton<int>(
                                value: _rating != 0 ? _rating : null,
                                underline: SizedBox(), // Hilangkan garis bawah
                                items: List.generate(5, (index) {
                                  return DropdownMenuItem(
                                    value: index + 1,
                                    child: Text('${index + 1}'),
                                  );
                                }),
                                onChanged: (value) {
                                  setState(() {
                                    _rating = value!;
                                  });
                                },
                                hint: Text(
                                  'Select',
                                  style: GoogleFonts.poppins(fontSize: 14),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        // Comment TextField
                        Text(
                          'Comment:',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: 'Write your comment...',
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: EdgeInsets.all(12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                  color: Colors.grey.shade300, width: 1),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                  color: Colors.grey.shade300, width: 1),
                            ),
                          ),
                          maxLines: 4,
                          onChanged: (value) {
                            setState(() {
                              _reviewText = value;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your review comment';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                        // Submit Button
                        Center(
                          child: ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                // If the form is valid, proceed with the submission
                                try {
                                  final response = await request.postJson(
                                    "http://127.0.0.1:8000/ratereview/menu-submit-flutter/",
                                    jsonEncode(<String, String>{
                                      'id': widget.id.toString(),
                                      'rating': _rating.toString(),
                                      'comment': _reviewText,
                                    }),
                                  );
                                  if (context.mounted) {
                                    if (response['status'] == 'success') {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text('Review Submitted!'),
                                        ),
                                      );
                                      // Refresh the page by pushing the current page again
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ReviewPage(
                                            warung: widget.warung,
                                            menu: widget.menu,
                                            price: widget.price,
                                            imageUrl: widget.imageUrl,
                                            id: widget.id,
                                            avgRatings: widget.avgRatings,
                                          ),
                                        ),
                                      );
                                    }
                                  }
                                } catch (e) {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content:
                                            Text('Failed to Submit Review'),
                                      ),
                                    );
                                  }
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Color(0xFFFF7124), // Warna tombol
                              padding: EdgeInsets.symmetric(
                                  horizontal: 50, vertical: 15),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                            child: Text(
                              'Submit Review',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              SizedBox(height: 20),
              // All Reviews Section
              Text(
                'All Reviews:',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFF7124), // Warna teks
                ),
              ),
              SizedBox(height: 10),
              FutureBuilder(
                future: fetchReviews(request),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                          'Failed to load reviews. Please try again later.'),
                    );
                  } else if (!snapshot.hasData) {
                    return Center(
                      child: Text('No reviews yet. Be the first to review!'),
                    );
                  } else {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: _reviewResults.length,
                      itemBuilder: (context, index) {
                        final review = _reviewResults[index];
                        return Column(
                          children: [
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(16),
                              margin: EdgeInsets.only(
                                  bottom: 10), // Memberi jarak antar card
                              decoration: BoxDecoration(
                                color:
                                    Colors.white, // Warna latar belakang card
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.shade300,
                                    blurRadius: 5,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Nama User
                                  Text(
                                    review.user,
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Color(0xFFFF7124),
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  // Rating
                                  Text(
                                    'Rate: ${review.rating}/5',
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  // Tanggal Publikasi
                                  Text(
                                    'Published on: ${review.createdAt.toLocal().toString().split(' ').first}',
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  // Komentar
                                  Text(
                                    review.comment,
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
