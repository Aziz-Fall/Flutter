import 'package:flutter/material.dart';
import 'package:weatherApp/API_manager.dart';

class Search extends SearchDelegate<City> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            query = " ";
            Navigator.pop(context);
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    Future<Cities> cities = APIManager.searchCity(query);
    debugPrint("=========query Results: $query");
    return Container(
      child: Center(
        child: FutureBuilder<Cities>(
          future: cities,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return getListView(snapshot.data.listCities);
            }

            return Container(
              child: Center(
                child: Text("Unkow city $query !"),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    debugPrint("=========query: $query");
    return Container(
      child: Center(
        child: Text(""),
      ),
    );
  }

  ListView getListView(List<City> listCities) {
    return ListView.builder(
        itemCount: listCities.length,
        itemBuilder: (context, index) {
          return Container(
                  child: Center(
                child: ListTile(
                  onTap: () => close(context, listCities[index]),
                  title: Text(listCities[index].name),
                  leading: Icon(Icons.location_city),
                ),
              ));
        });
  }
}
