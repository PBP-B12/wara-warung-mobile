import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MenuCard extends StatelessWidget {
  final String title;
  final int price;
  final String imageUrl;
  final String warung;
  final String username;
  final int idMenu;
  final int avgRating;
  final Function deleteMenu;
  final Function EditMenuScreen;

  const MenuCard({
    super.key,
    required this.title,
    required this.price,
    required this.imageUrl,
    required this.warung,
    required this.idMenu,
    required this.avgRating,
    required this.username, // Menambahkan parameter username
    required this.deleteMenu, // Menambahkan parameter deleteMenu
    required this.EditMenuScreen,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topCenter, // Start at the top
          end: Alignment.bottomCenter, // End at the bottom
          colors: [
            Color(0xFFF5E6C5), // #f5e6c5
            Color(0xFFFFC5A5), // #ffc5a5
          ],
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(
            25), // Ensure clipping matches the container's borderRadius
        child: Column(
          children: [
            Expanded(
              flex: 5,
              child: Stack(
                children: [
                  Image.network(
                    filterQuality: FilterQuality.low,
                    imageUrl,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error_outline_sharp),
                          Text(
                            'Fail to Load this Image',
                            style: GoogleFonts.poppins(),
                          )
                        ],
                      );
                    },
                  ),
                  if (username == "admin")
                    Positioned(
                      top: 4,
                      right: 10,
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EditMenuScreen(
                                            warung: warung,
                                            menu: title,
                                            price: price,
                                            imageUrl: imageUrl,
                                            id: idMenu,
                                          )));
                            },
                            child: Container(
                                padding: const EdgeInsets.all(7.5),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: Colors.blue),
                                child: const Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                  size: 17.5,
                                )),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          InkWell(
                            onTap: () => deleteMenu(),
                            child: Container(
                                padding: const EdgeInsets.all(7.5),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: Colors.red),
                                child: const Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                  size: 17.5,
                                )),
                          ),
                        ],
                      ),
                    )
                ],
              ),
            ),
            Expanded(
              flex: 6,
              child: Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 17.5,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'Rp ${price}',
                          style: GoogleFonts.poppins(),
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on_outlined,
                              color: Colors.orange,
                              size: 15,
                            ),
                            Expanded(
                              child: Text(
                                warung,
                                maxLines: 1,
                                style: GoogleFonts.poppins(),
                              ),
                            )
                          ],
                        ),
                        RichText(
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Rate : ',
                                style: GoogleFonts.poppins(
                                  color: Colors.orange,
                                  fontWeight: FontWeight.bold,
                                ), // Orange color for 'Rate :'
                              ),
                              TextSpan(
                                text: '${avgRating} out of 5',
                                style: GoogleFonts.poppins(
                                  color: Colors.black,
                                ), // Default color for the rest of the text
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Expanded(child: SizedBox()),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          final id = idMenu;
                          // TODO: goto Detail Page
                          print('TODO: goto Detail Page');
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 6, horizontal: 10),
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(10)),
                          child: Text(
                            'See Details',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 12.5,
                            ),
                          ),
                        ),
                      ),
                      if (username != null)
                        Column(
                          children: [
                            const SizedBox(
                              height: 2,
                            ),
                            InkWell(
                              onTap: () {
                                final id = idMenu;
                                // TODO: goto Add to List Page
                                print('// TODO: goto Add to List Page');
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 6, horizontal: 10),
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Text(
                                  'Add to List',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 12.5,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
