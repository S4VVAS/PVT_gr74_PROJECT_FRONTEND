import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:history_go/src/components/custom_app_bar.dart';
import 'package:history_go/src/models/place.dart';


class InfoPage extends StatefulWidget {
  InfoPage(this.place);
  final Place place;

  @override
  _InfoPageState createState() => new _InfoPageState(place);
}

class _InfoPageState extends State<InfoPage> {
  _InfoPageState(this.place) {first = place.entries[0];}
  final Place place;
  Entries first;
  String title;
  String description;
  String date;
  String photographer;

  @override
  void initState() {
    super.initState();
    title = first.title;
    description = first.desc;
    date = first.date ;
    photographer = first.name;
  }

  void setText(int index) {
    setState(() {
      title = place.entries[index].title ?? "Titel saknas";
      description = place.entries[index].desc ?? "Beskrivning saknas";
      //date = place.entries[index].date ?? "Datum saknas";
      //photographer = place.entries[index].name ?? "Okänt";
    });
  }

  Widget _infoPicture() {
    List<Image> images = new List();
    place.getImages().forEach((img) {
      images.add(Image.network(img));
    });
    return Carousel(
      autoplay: false,
      animationCurve: Curves.fastOutSlowIn,
      animationDuration: Duration(milliseconds: 2000),
      images: images,
      indicatorBgPadding: 8.0,
      dotColor: Colors.lightBlue,
      dotIncreasedColor: Colors.lightBlue,
      dotBgColor: Colors.white.withOpacity(0.0),
      onImageChange: (_, current) => setText(current),
      showIndicator: (place.entries.length == 1) ? false : true,
    );
  }

  Widget _infoText() {
    return Container(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(title,
                style: Theme.of(context)
                    .textTheme
                    .headline4
                    .copyWith(color: Colors.black)),
            Expanded(
                flex: 2,
                child: Container(
                    padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child: Text(description,
                        style: Theme.of(context).textTheme.bodyText2))),
            extraInfo("Bild tagen: $date"),
            extraInfo("Fotograf: $photographer"),
            Expanded(flex: 3, child: SizedBox())
          ],
        ));
  }

  Widget extraInfo(String info) {
    return Align(
        alignment: Alignment.topLeft,
        child: Text(info,
            style: Theme.of(context).textTheme.bodyText1,
            textAlign: TextAlign.left));
  }

  Widget noPlacePage(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              Colors.blue,
              Colors.lightBlueAccent,
            ]),
          ),
          child: Column(
            children: <Widget>[
              Text('Plats saknas.'),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    RouteSettings settings = ModalRoute.of(context).settings;

    //place = settings.arguments;

    if (place == null)
      return noPlacePage(context);
    else {
      return Scaffold(
        appBar: CustomAppBar(
          backButton: true,
        ),
        body: Center(
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: _infoPicture(),
                ),
                //TODO: Fix infopage
                Expanded(
                  child: _infoText(),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}
