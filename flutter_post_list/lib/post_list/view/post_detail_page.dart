import 'package:flutter/material.dart';
import 'package:flutter_post_list/post_list/model/post.dart';


class PostDetailPage extends StatelessWidget {
  const PostDetailPage({super.key, required this.post, required this.index, required this.posts, required this.onRemove});
  
  final Post post;
  final int index;
  final List<Post> posts;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Post Detail')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(post.title, style: Theme.of(context).textTheme.titleLarge), // Changed from headline6 to titleLarge
            const SizedBox(height: 16.0),
            Text(post.body),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: onRemove,
              child: const Text('Remove Post'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFFFC0CB), // Changed from primary to backgroundColor
              ),
            ),
            const SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Navigate to previous post (wrap around if at index 0)
                    final prevIndex = index == 0 ? posts.length - 1 : index - 1;
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PostDetailPage(
                          post: posts[prevIndex],
                          index: prevIndex,
                          posts: posts,
                          onRemove: onRemove,
                        ),
                      ),
                    );
                  },
                  child: const Text('Prev'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to next post (wrap around if at last index)
                    final nextIndex = index == posts.length - 1 ? 0 : index + 1;
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PostDetailPage(
                          post: posts[nextIndex],
                          index: nextIndex,
                          posts: posts,
                          onRemove: onRemove,
                        ),
                      ),
                    );
                  },
                  child: const Text('Next'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
