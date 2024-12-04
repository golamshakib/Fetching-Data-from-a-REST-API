import 'package:assignment_1_fetching_data_from_api/providers/post_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = '/';

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PostProvider>().getAllPost();
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Consumer<PostProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.postsList.isEmpty) {
            return const Center(child: Text('No posts available.'));
          }
          return ListView.builder(
            itemCount: provider.postsList.length,
            itemBuilder: (_, index) {
              final post = provider.postsList[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                child: Card(
                  elevation: 5,
                  surfaceTintColor: Colors.black,
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text('Title: ${post.title}'),
                    subtitle: Text(
                      'Body: ${post.body}',
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                    leading: CircleAvatar(child: Text(post.id.toString())),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
