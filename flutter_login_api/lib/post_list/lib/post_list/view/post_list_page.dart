import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_login_api/post_list/lib/post_list/post_list.dart';
import 'package:flutter_login_api/post_list/lib/post_list/view/post_detail_page.dart';
import 'package:flutter_login_api/post_list/lib/post_list/model/post.dart';

part "post_list_view.dart";

class PostListPage extends StatelessWidget {
  const PostListPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute(
      builder: (_) => const PostListPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Post List')),
      body: BlocBuilder<PostListCubit, PostListState>(
        builder: (context, state) {
          if (state is PostListSuccess) {
            return ListView.builder(
              itemCount: state.posts.length,
              itemBuilder: (context, index) {
                final post = state.posts[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.pink[50],
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ListTile(
                      title: Text(
                        post.title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        post.body.length > 55
                            ? "${post.body.substring(0, 55)}..."
                            : post.body,
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () {
                          _showRemoveConfirmation(context, index);
                        },
                      ),
                      onLongPress: () {
                        _showRemoveConfirmation(context, index);
                      },
                    ),
                  ),
                );
              },
            );
          } else if (state is PostListError) {
            return Center(
              child: Text(
                state.errorMessage,
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (state is PostListLoading) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return Center(
              child: ElevatedButton(
                onPressed: () => context.read<PostListCubit>().fetchPosts(),
                child: const Text("Refresh"),
              ),
            );
          }
        },
      ),
    );
  }

void _showRemoveConfirmation(BuildContext context, int index) {
  showModalBottomSheet(
    context: context,
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Are you sure you want to remove this post?",
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    context.read<PostListCubit>().removeData(index);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Post removed from the list"),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                  child: const Text("Remove"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}
}