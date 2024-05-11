import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:licenta_ui/charts_widgets/bar_graph/bar_graph.dart';

class ChartsPage extends StatefulWidget {
  final List<List<double>> weeklySummary;

  const ChartsPage({Key? key, required this.weeklySummary}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ChartsPageState createState() => _ChartsPageState();
}

class _ChartsPageState extends State<ChartsPage> {
  int current = 0;

  final List<String> chartsTitlesList = [
    'Average temperature per day',
    'Average light level per day',
    'Average air moisture per day',
    'Average soil moisture per day'
  ];

  @override
  Widget build(BuildContext context) {
    final CarouselController controller = CarouselController();

    final List<Widget> chartsSliders = chartsTitlesList
        .map(
          (item) => Container(
            margin: EdgeInsets.all(5.0),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              child: Stack(
                children: <Widget>[
                  BarGraph(
                    weeklySummary: widget.weeklySummary[current],
                    chartTitle: chartsTitlesList[current],
                  ),
                ],
              ),
            ),
          ),
        )
        .toList();

    return Scaffold(
      body: Column(children: [
        Expanded(
          child: CarouselSlider(
            items: chartsSliders,
            carouselController: controller,
            options: CarouselOptions(
                autoPlay: false,
                enlargeCenterPage: true,
                enableInfiniteScroll: true,
                aspectRatio: 0.7,
                viewportFraction: 0.9,
                onPageChanged: (index, reason) {
                  setState(() {
                    current = index;
                  });
                }),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: chartsTitlesList.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () => controller.animateToPage(entry.key),
              child: Container(
                width: 8.0,
                height: 20.0,
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: (Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.teal)
                      .withOpacity(current == entry.key ? 1.0 : 0.4),
                ),
              ),
            );
          }).toList(),
        ),
      ]),
    );
  }
}
