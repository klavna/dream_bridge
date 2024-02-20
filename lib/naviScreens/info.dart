import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class InformationScreen extends StatelessWidget {
  const InformationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/background_2.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 125.0, left: 30),
            child: Text(
              'Small Actions,\nBig Impact',
              style: TextStyle(
                fontFamily: 'Roboto-Black',
                fontSize: 50.0,
                color: Color(0xff846DA0),
                height: 1,
              ),
            ),
          ),

          // [위치 조정] CarouselSlider
          const SizedBox(height: 35),

          // [디자인] CarouselSlider
          Center(
            child: CarouselSlider(
              items: [
                // Add your carousel items here
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: const AssetImage('assets/images/wonder_1.jpg'),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.3), // 조절 가능한 어두운 정도
                        BlendMode.darken,
                      ),
                    ),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: const Stack(
                    children: [
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Help a hurting child!',
                                style: TextStyle(
                                  fontFamily: 'Roboto-Bold',
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white, // 하얀색 글자
                                ),
                              ),
                              SizedBox(height: 1.0),
                              Text(
                                'Your donation can bring a smile to a child in need.',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontFamily: 'Roboto-Regular',
                                  fontSize: 13.0,
                                  color: Colors.white, // 하얀색 글자
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: const AssetImage('assets/images/wonder_2.jpg'),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.3), // 조절 가능한 어두운 정도
                        BlendMode.darken,
                      ),
                    ),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: const Stack(
                    children: [
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Light up the future of children!',
                                style: TextStyle(
                                  fontFamily: 'Roboto-Bold',
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white, // 하얀색 글자
                                ),
                              ),
                              SizedBox(height: 1.0),
                              Text(
                                "Spark Joy in a Child's Life with Your Generous Gift.",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontFamily: 'Roboto-Regular',
                                  fontSize: 13.0,
                                  color: Colors.white, // 하얀색 글자
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: const AssetImage('assets/images/wonder_3.jpg'),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.3), // 조절 가능한 어두운 정도
                        BlendMode.darken,
                      ),
                    ),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: const Stack(
                    children: [
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Bring Hope to Disaster Relief!',
                                style: TextStyle(
                                  fontFamily: 'Roboto-Bold',
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white, // 하얀색 글자
                                ),
                              ),
                              SizedBox(height: 1.0),
                              Text(
                                "Contribute to disaster relief and offer a warm helping hand.",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontFamily: 'Roboto-Regular',
                                  fontSize: 13.0,
                                  color: Colors.white, // 하얀색 글자
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Add more slides as needed
              ],
              options: CarouselOptions(
                height: 320,
                // Adjust the height as needed
                enlargeCenterPage: true,
                autoPlay: true,
                aspectRatio: 16 / 9,
                autoPlayCurve: Curves.fastOutSlowIn,
                enableInfiniteScroll: true,
                autoPlayAnimationDuration: const Duration(milliseconds: 600),
                viewportFraction: 0.8,
              ),
            ),
          ),
          // 따로 추가한 텍스트
          Padding(
            padding: const EdgeInsets.only(left: 30, top: 23),
            child: RichText(
              text: const TextSpan(
                children: [
                  TextSpan(
                    text:
                        ' When we come together, small actions \n can create unexpected miracles and \n have a significant impact. \n Join us now, and help our small actions \n bloom the flower of hope \n in the vast world!',
                    style: TextStyle(
                      fontFamily: 'Roboto-Bold',
                      fontSize: 20.0,
                      color: Colors.black45,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
