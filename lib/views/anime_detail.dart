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
      appBar: AppBar(
        title: const Text("Detail"),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(child: Text("Error: $_errorMessage"))
              : _detailData != null
                  ? Column(
                      children: [
                        Image.network(
                          _detailData!['images'][0] ??
                              'https://placeholder.co/600x400',
                        ),
                        Text("Name: ${_detailData!['name']}"),
                        Text(
                          "Kekkei Genkai: ${_detailData!['personal']['kekkeiGenkai'] ?? 'Empty'}",
                        ),
                        Text(
                          "Titles: ${_detailData!['personal']['titles']}",
                        ),
                      ],
                    )
                  : const Text("No Data Available"),
    );
  }
}