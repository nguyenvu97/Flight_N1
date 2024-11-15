import 'package:flutter/material.dart';

class CustomerSearchView extends SearchDelegate {
  List<String> data = [
    "Fiction",
    "Non-Fiction",
    "Science",
    "Mystery",
    "Thriller",
    "Romance",
    "Fantasy",
    "Biography",
    "History",
    "Self-Help"
  ];

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        // key: sideMenuScaffoldKey,
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(Icons.arrow_back_ios));
  }

  @override
  Widget buildResults(BuildContext context) {
    List<String> matchQuery = [];
    for (var item in data) {
      if (item.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(item);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var kq = matchQuery[index];
        return ListTile(
          title: Text(kq),
          onTap: () {
            query = kq;
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matchQuery = [];
    for (var item in data) {
      if (item.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(item);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        final kq = matchQuery[index];
        return ListTile(
          title: Text(kq),
          onTap: () {
            query = kq;
          },
        );
      },
    );
  }
}
