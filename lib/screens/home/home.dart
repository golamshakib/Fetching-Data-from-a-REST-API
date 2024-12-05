import 'package:assignment_1_fetching_data_from_api/common/widgets/custom_shape/container/rounded_container.dart';
import 'package:assignment_1_fetching_data_from_api/providers/connectivity_provider.dart';
import 'package:assignment_1_fetching_data_from_api/providers/post_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  /// - Method to fetch Posts based on connection
  Future<void> _fetchPosts () async {
    final isConnected = context.read<ConnectivityProvider>().isConnected;
    await context.read<PostProvider>().getAllPosts(isConnected: isConnected);
  }

  @override
  void initState() {

    /// - Setup callback for connectivity restoration
    final connectivity = context.read<ConnectivityProvider>();
    connectivity.onConnectedCallback = () async {
      await _fetchPosts();
    };
    /// - Setup callback for connectivity loss
    connectivity.onDisconnectedCallback = () {
      context.read<PostProvider>().clearPosts();
    };
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final isConnected = context.read<ConnectivityProvider>().isConnected;
      if (isConnected) {
        _fetchPosts();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home', style: TextStyle(fontSize: 18),),
      ),
      body: Stack(
        children: [
          /// -- Background Container Design
          Positioned(
            bottom: -150.0,
            right: -250.0,
            child: YRoundedContainer(
              height: 400.0,
              width: 400.0,
              backgroundColor: const Color(0xFF4868FF).withOpacity(0.1),
            ),
          ),
          Positioned(
            bottom: 100.0,
            right: -300.0,
            child: YRoundedContainer(
              height: 400.0,
              width: 400.0,
              backgroundColor: const Color(0xFF4868FF).withOpacity(0.1),
            ),
          ),
          Positioned(
            top: -150.0,
            left: -250.0,
            child: YRoundedContainer(
              height: 400.0,
              width: 400.0,
              radius: 400.0,
              backgroundColor: const Color(0xFF4868FF).withOpacity(0.1),
            ),
          ),
          Positioned(
            top: 100.0,
            left: -300.0,
            child: YRoundedContainer(
              height: 400.0,
              width: 400.0,
              radius: 400.0,
              backgroundColor: const Color(0xFF4868FF).withOpacity(0.1),
            ),
          ),

          /// -- Internet Connection Container & Showing Data
          RefreshIndicator(
            onRefresh: () async {
              await _fetchPosts();
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Consumer<ConnectivityProvider>(
                  builder: (context, provider, child) {
                    if (!provider.isConnected) {
                      return Container(
                        width: double.infinity,
                        color: Colors.red.withOpacity(0.9),
                        padding: const EdgeInsets.all(6.0),
                        child: const Text(
                          "No Internet Connection",
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),

                /// - Showing Data in the ListView.builder
                Expanded(
                  child: Consumer<PostProvider>(
                    builder: (context, provider, child) {
                      if (provider.isLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (provider.postsList.isEmpty) {
                        return const Center(child: Text('No Posts available.'));
                      }
                      return ListView.builder(
                        itemCount: provider.postsList.length,
                        itemBuilder: (_, index) {
                          final post = provider.postsList[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Colors.grey, width: 1,
                                ),
                              ),
                              margin: const EdgeInsets.all(8.0),
                              child: ListTile(
                                title: Text('Title: ${post.title}'),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('UserID: ${post.userId}'),
                                    Text(
                                      'Body: ${post.body}',
                                      maxLines: 4,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                                leading: CircleAvatar(child: Text(post.id.toString())),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
