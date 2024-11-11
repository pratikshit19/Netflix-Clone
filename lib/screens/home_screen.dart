import 'package:flutter/material.dart';
import 'package:movie_app/services/api_service.dart';
import 'dart:math'; // For shuffling

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List movies = [];
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    fetchMovies(); // Fetch movies when the screen loads
    _pageController = PageController(
        viewportFraction: 0.8); // Adjust viewport to show next/previous images
  }

  /*----------------------------- Fetching movies using ApiService-------------------------*/
  void fetchMovies() async {
    try {
      var fetchedMovies =
          await ApiService.fetchMovies("all"); // Fetch movies from ApiService
      setState(() {
        movies = fetchedMovies;
      });
    } catch (e) {
      print('Error fetching movies: $e');
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Row(
          children: [
            Text('Netflix',
                style: TextStyle(
                    color: Colors.red[800],
                    fontWeight: FontWeight.bold,
                    fontSize: 25)),
            const SizedBox(
              width: 5,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text('(Clone)',
                  style: TextStyle(
                      color: Colors.grey[400],
                      fontStyle: FontStyle.italic,
                      fontSize: 12)),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              Navigator.pushNamed(context, '/search');
            },
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: movies.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildContinuousCarousel(), // Adding the continuous carousel before the trending section
                  buildCategorySection('Trending Now', movies),
                  buildCategorySection('Popular Movies', movies),
                  buildCategorySection('Top Rated', movies),
                ],
              ),
            ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.grey[950],
        selectedItemColor: Colors.red[800],
        unselectedItemColor: Colors.white,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
        ],
        onTap: (index) {
          if (index == 1) {
            Navigator.pushNamed(context, '/search');
          }
        },
      ),
    );
  }

  /*------------------ Widget/Function to build the continuous carousel----------------------------*/
  Widget buildContinuousCarousel() {
    List movieList = [
      ...movies,
      ...movies
    ]; // Duplicating list for infinite scrolling effect

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: SizedBox(
          height: 400,
          width: 350,
          child: PageView.builder(
            controller: _pageController,
            itemCount: movieList.length,
            itemBuilder: (context, index) {
              var movie = movieList[index % movies.length]['show'];

              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/details',
                    arguments: movie,
                  );
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 0.2),
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      image: NetworkImage(
                        movie['image']?['original'] ??
                            'https://via.placeholder.com/500x250',
                      ),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  /*------------------ Widget/Function to build each horizontal scrolling categories------------------*/
  Widget buildCategorySection(String title, List<dynamic> movies) {
    List shuffledMovies = List.from(movies)
      ..shuffle(Random()); // Shuffle the movies for each category

    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: shuffledMovies.length,
              itemBuilder: (context, index) {
                var movie = shuffledMovies[index]['show'];
                return buildMovieThumbnail(movie);
              },
            ),
          ),
        ],
      ),
    );
  }

  /*------------------ Widget to build each movie thumbnail card--------------------------*/
  Widget buildMovieThumbnail(dynamic movie) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/details',
          arguments: movie,
        );
      },
      child: Container(
        width: 110,
        margin: const EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                image: DecorationImage(
                  image: NetworkImage(
                    movie['image']?['medium'] ??
                        'https://via.placeholder.com/130x160',
                  ),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              movie['name'] ?? 'No Title',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }
}
