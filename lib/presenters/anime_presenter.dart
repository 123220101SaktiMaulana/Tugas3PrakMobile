import 'package:tugas3/models/anime_model.dart';
import 'package:tugas3/network/base_network.dart';

abstract class AnimeView {
    void showLoading();
    void hideLoading();
    void showAnimeList(List<Anime> animeList);
    void showError(String message);
}

class AnimePresenter {
    final AnimeView view;
    AnimePresenter(this.view);

Future<void> loadAnimeData(String endpoint) async {
    try {
        view.showLoading();
        final List<dynamic> data = await BaseNetwork.getList(endpoint);
        final animeList = data.map((json) => Anime.fromJson(json)).toList();
        view.showAnimeList(animeList);
    } catch (e) {
        view.showError(e.toString());
    } finally {
        view.hideLoading();
        }
    }
}
