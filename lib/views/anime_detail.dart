import 'package:flutter/material.dart';
import 'package:tugas3/network/base_network.dart';

class DetailScreen extends StatefulWidget {
  final int id;
  final String endpoint;

  const DetailScreen({super.key, required this.id, required this.endpoint});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool _isLoading = true;
  Map<String, dynamic>? _detailData;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchDetailData();
  }

  Future<void> _fetchDetailData() async {
    try {
      final data = await BaseNetwork.getDetail(widget.endpoint, widget.id);
      setState(() {
        _detailData = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Anime Detail"),
        backgroundColor: Colors.deepPurple,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Text(
                    "Error: $_errorMessage",
                    style: const TextStyle(color: Colors.red),
                  ),
                )
              : _detailData != null
                  ? SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Gambar tidak terpotong
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.network(
                              _detailData!['images'][0] ??
                                  'https://via.placeholder.com/600x400',
                              width: double.infinity,
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 4,
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _detailData!['name'] ?? "Unknown",
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    "Kekkei Genkai: ${_detailData!['personal']['kekkeiGenkai'] ?? 'None'}",
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    "Titles: ${(_detailData!['personal']['titles'] as List<dynamic>?)?.join(', ') ?? 'None'}",
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : const Center(child: Text("No Data Available")),
    );
  }
}
