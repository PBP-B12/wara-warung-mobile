import 'package:flutter/material.dart';

void main() {
  runApp(MenuReviewApp());
}

class MenuReviewApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ReviewPage(),
    );
  }
}

class ReviewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Menu Review'),
        backgroundColor: Colors.orange,
      ),
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
                  color: Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 150,
                      height: 150,
                      color: Colors.grey.shade300,
                      child: Center(
                        child: Text(
                          '150 x 150',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Bakso Sapi',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'at Warung Lawar Soto',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text('Price: Rp 20000'),
                    SizedBox(height: 5),
                    Text('Avg. Rate: 0.0 / 5.0'),
                  ],
                ),
              ),
              SizedBox(height: 20),
              // Submit Review Section
              Text(
                'Submit a review:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    // Rating Dropdown
                    Row(
                      children: [
                        Text('Rate: '),
                        SizedBox(width: 10),
                        DropdownButton<int>(
                          items: List.generate(5, (index) {
                            return DropdownMenuItem(
                              value: index + 1,
                              child: Text('${index + 1}'),
                            );
                          }),
                          onChanged: (value) {},
                          hint: Text('Select'),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    // Comment TextField
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Comment',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 4,
                    ),
                    SizedBox(height: 10),
                    // Submit Button
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                      ),
                      child: Text('Submit'),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              // All Reviews Section
              Text(
                'All Reviews:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'admin',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    Text('Rate: 5/5'),
                    SizedBox(height: 5),
                    Text('Published on: 2024-12-09 03:56:40'),
                    SizedBox(height: 5),
                    Text('test'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
