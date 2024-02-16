import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../components/movie_carousal.dart';
import '../components/movie_slider.dart';
import '../services/api_services.dart';
import '../services/auth_services.dart';
import 'search.dart';
import 'signup.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () {
            setState(() {});
            return Future.value();
          },
          child: ListView(
            children: [
              const SizedBox(height: 20.0),
              // label
              Row(
                children: [
                  const SizedBox(width: 15.0),
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text:
                                "Hi, ${FirebaseAuth.instance.currentUser!.displayName ?? "Buddy"}\n",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25.0,
                            ),
                          ),
                          const TextSpan(
                            text: "What do you want to watch today?",
                            style: TextStyle(
                              fontSize: 12.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      try {
                        await AuthServices.signOut();
                        if (context.mounted) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignUp()),
                          );
                        }
                      } catch (error) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                error.toString(),
                              ),
                            ),
                          );
                        }
                      }
                    },
                    icon: const Icon(
                      Icons.account_circle,
                      size: 40.0,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              // search bar
              GestureDetector(
                onTap: () {
                  showSearch(context: context, delegate: Search());
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15.0,
                    vertical: 12.0,
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 15.0),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(50.0),
                    ),
                    color: Colors.blue.shade50,
                  ),
                  child: const Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Search",
                          style: TextStyle(
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                      Icon(Icons.search),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              MovieCarousal(
                label: "Now Playing Movies",
                fetchData: ApiServices.nowPlayingMovies(),
              ),
              const SizedBox(height: 20.0),
              MovieSlider(
                label: "Top Rated Movies",
                fetchData: ApiServices.topRatedMovies(),
              ),
              const SizedBox(height: 20.0),
              MovieSlider(
                label: "Upcoming movies",
                fetchData: ApiServices.upcomingMovies(),
              ),
              const SizedBox(height: 20.0),
              MovieSlider(
                label: "Popular Movies",
                fetchData: ApiServices.popularMovies(),
              ),
              const SizedBox(height: 20.0),
              MovieSlider(
                label: "Recent Viewed Movies",
                fetchData: ApiServices.recentViewedMovies(),
              ),
              const SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );
  }
}
