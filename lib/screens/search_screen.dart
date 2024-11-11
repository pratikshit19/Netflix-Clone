import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List searchResults = [];
  final TextEditingController _controller = TextEditingController();
  bool isSearching = false; // To show a loading indicator when searching

  // Fetch movies based on search query
  searchMovies(String query) async {
    setState(() {
      isSearching = true;
    });
    var url = Uri.parse('https://api.tvmaze.com/search/shows?q=$query');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      setState(() {
        searchResults = json.decode(response.body);
        isSearching = false; // Stop loading once data is fetched
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose of controller to avoid memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Padding(
          padding: const EdgeInsets.only(right: 20),
          child: Container(
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey[800], // Set the grey background color
              borderRadius:
                  BorderRadius.circular(10), // Optional: rounded corners
            ),
            padding: const EdgeInsets.only(left: 10),
            child: TextField(
              controller: _controller,
              style: const TextStyle(color: Colors.white),
              cursorColor: Colors.white,
              decoration: InputDecoration(
                hintText: 'Search Movies and TV Shows',
                hintStyle: const TextStyle(color: Colors.white54),
                border: InputBorder.none,
                suffixIcon: _controller.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.white),
                        onPressed: () {
                          _controller.clear();
                          setState(() {
                            searchResults = [];
                          });
                        },
                      )
                    : null,
              ),
              onChanged: (value) {
                if (value.isNotEmpty) {
                  searchMovies(value); // Search dynamically when typing
                } else {
                  setState(() {
                    searchResults = [];
                  });
                }
              },
            ),
          ),
        ),
      ),
      body: isSearching
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.red,
              ),
            )
          : searchResults.isEmpty
              ? const Center(
                  child: Text(
                    'What you have in mind?',
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: GridView.builder(
                    itemCount: searchResults.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, // 3 columns like Netflix
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 2 / 3, // Adjust for poster-like shape
                    ),
                    itemBuilder: (context, index) {
                      var movie = searchResults[index]['show'];
                      return GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/details',
                            arguments: movie,
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  movie['image']?['medium'] ??
                                      'https://via.placeholder.com/130x190',
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                ),
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              movie['name'] ?? 'No Title',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
