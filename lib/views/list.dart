import 'package:flutter/material.dart';
import 'package:tugas3/models/anime_model.dart';
import 'package:tugas3/presenters/anime_presenter.dart';
import 'package:tugas3/views/anime_detail.dart';

class AnimeListScreen extends StatefulWidget {
  const AnimeListScreen({super.key});

  @override
  State<AnimeListScreen> createState() => _AnimeListScreenState();
}

class _AnimeListScreenState extends State<AnimeListScreen>
    implements AnimeView {
  late AnimePresenter _presenter;
  bool _isLoading = false;
  List<Anime> _animeList = [];
  String? _errorMessage;
  String _currentEndpoint = "akatsuki";

  @override
  void initState() {
    super.initState();
    _presenter = AnimePresenter(this);
    _presenter.loadAnimeData(_currentEndpoint);
  }

  void _fetchData(String endpoint) {
    setState(() {
      _currentEndpoint = endpoint;
      _presenter.loadAnimeData(endpoint);
    });
  }

  @override
  void showLoading() {
    setState(() {
      _isLoading = true;
    });
  }

  @override
  void hideLoading() {
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void showAnimeList(List<Anime> animeList) {
    setState(() {
      _animeList = animeList;
      _errorMessage = null; // reset error
    });
  }

  @override
  void showError(String message) {
    setState(() {
      _errorMessage = message;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Anime List"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => _fetchData("akatsuki"),
                child: const Text("Akatsuki"),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () => _fetchData("kara"),
                child: const Text("Kara"),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () => _fetchData("characters"),
                child: const Text("Characters"),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _errorMessage != null
                    ? Center(
                        child: Text(
                          "Error: $_errorMessage",
                          style: const TextStyle(color: Colors.red),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _animeList.length,
                        itemBuilder: (context, index) {
                          final anime = _animeList[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(12),
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    anime.imageUrl.isNotEmpty
                                        ? anime.imageUrl
                                        : 'https://via.placeholder.com/100',
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                title: Text(
                                  anime.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                subtitle: Text(
                                  "Family: ${anime.familyCreator}",
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 13,
                                  ),
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DetailScreen(
                                        id: anime.id,
                                        endpoint: _currentEndpoint,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
