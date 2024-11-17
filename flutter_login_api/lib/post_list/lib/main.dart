import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_login_api/post_list/lib/post_list/post_list.dart'; // Pastikan import PostListCubit
import 'package:flutter_login_api/post_list/lib/post_list/view/post_detail_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Post List',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: BlocProvider(
        create: (context) => PostListCubit()..fetchPosts(),
        child: const PostListView(),
      ),
    );
  }
}

class PostListView extends StatelessWidget {
  const PostListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post List'),
        centerTitle: true,
      ),
      body: BlocBuilder<PostListCubit, PostListState>(
        builder: (context, state) {
          if (state is PostListSuccess) {
            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              itemCount: state.posts.length,
              itemBuilder: (context, index) {
                final post = state.posts[index];
                return Dismissible(
                  key: Key(post.id.toString()),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    context.read<PostListCubit>().removeData(index);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Post "${post.title}" removed'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    color: Colors.redAccent,
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFE4E1), // Pink pastel muda
                        borderRadius: BorderRadius.circular(12.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4.0,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ListTile(
                        title: Text(
                          post.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          post.body.length > 55
                              ? "${post.body.substring(0, 55)}..."
                              : post.body,
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PostDetailPage(
                                post: post,
                                index: index,
                                posts: state.posts,
                                onRemove: () {
                                  context.read<PostListCubit>().removeData(index);
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                          );
                        },
                      ),
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
}
