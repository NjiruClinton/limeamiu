import 'package:flutter/material.dart';


class MySearchBar extends StatelessWidget {
  final TextEditingController searchController;
  const MySearchBar({super.key, required this.searchController});

  @override
  Widget build(BuildContext context) {
    return Container(

      //margin: const EdgeInsets.symmetric(horizontal: 25),
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      width: MediaQuery.sizeOf(context).width,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30))

      ),

      child: TextField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: 'Search a patient...',
            // Add a clear button to the search bar
            suffixIcon: IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                // Clear the search field
                searchController.clear();

              },
            ),
            prefixIcon: IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                // Perform the search here
              },
            ),
            // bottom line only when user is typing
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                  color: Colors.grey.shade800
                      .withOpacity(0.5)),
            ),
          ),
          onChanged: (value) {
            // setState(() {
            // });
          }),
    );
  }
}
