import '../models/app_localizations.dart';
import '../models/custom_locations.dart';
import 'package:flutter/material.dart';

class STOListView extends StatefulWidget {
  const STOListView({Key? key}) : super(key: key);

  @override
  _STOListViewState createState() => _STOListViewState();
}

class _STOListViewState extends State<STOListView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(
                AppLocalizations.of(context)?.translate("locations_history") ??
                    "")),
        body: FutureBuilder<List<CustomLocation>>(
          future: CustomLocationsManager.getLocations(25),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError) {
              return Container();
            }
            return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  CustomLocation thisLocation = snapshot.data![index];
                  return Dismissible(
                    child: _tile(thisLocation, context),
                    background: Container(
                      child: Container(
                        margin: EdgeInsets.only(right: 10.0),
                        alignment: Alignment.centerRight,
                        child:
                            new LayoutBuilder(builder: (context, constraint) {
                          return new Icon(Icons.delete_forever,
                              size: constraint.biggest.height * 0.5);
                        }),
                      ),
                      color: Colors.red,
                    ),
                    key: new UniqueKey(),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) async => {
                      await thisLocation.deleteThisLocation(),
                      ScaffoldMessenger.of(context).showSnackBar(
                          new SnackBar(content: new Text("Location removed")))
                    },
                  );
                });
          },
        ));
  }

  ListTile _tile(CustomLocation thisLocation, BuildContext context) {
    String title = thisLocation.getLocality() +
        ", " +
        thisLocation.getSubAdministrativeArea() +
        ", " +
        thisLocation.getISOCountryCode();
    String subtitle =
        thisLocation.getTimestamp() + "\n" + thisLocation.getStreet();
    String text = thisLocation.displayCustomText(10.0, 10.0, context);
    return ListTile(
      title: Text(title,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 20,
          )),
      subtitle: new RichText(
        text: new TextSpan(
          // Note: Styles for TextSpans must be explicitly defined.
          // Child text spans will inherit styles from parent
          style: new TextStyle(
            fontSize: 14.0,
            color: Colors.black,
          ),
          children: <TextSpan>[
            new TextSpan(
                text: subtitle,
                style: new TextStyle(fontWeight: FontWeight.bold)),
            new TextSpan(text: text),
          ],
        ),
      ),
      leading: Icon(
        Icons.gps_fixed,
        color: Colors.blue[500],
      ),
    );
  }
}
