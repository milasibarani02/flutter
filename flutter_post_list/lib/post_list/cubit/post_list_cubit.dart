import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_post_list/post_list/model/post.dart'; // Pastikan model ini sudah benar

part 'post_list_state.dart';

class PostListCubit extends Cubit<PostListState> {
  PostListCubit() : super(const PostListState.initial());

  // Fetch data from API
  fetchPosts() async {
    try {
      emit(const PostListState.loading());
      Dio dio = Dio();

      final res = await dio.get("https://jsonplaceholder.typicode.com/posts");

      if (res.statusCode == 200) {
        final List<Post> posts = (res.data as List).map<Post>((d) {
          return Post.fromJson(d);
        }).toList();

        emit(PostListState.success(posts)); // Emit the fetched posts
      } else {
        emit(PostListState.error("Error loading data: ${res.data.toString()}"));
      }
    } catch (e) {
      emit(PostListState.error("Error loading data: ${e.toString()}"));
    }
  }

  // Remove data from the list
  void removeData(int index) {
    if (state is PostListSuccess) {
      final posts = List<Post>.from((state as PostListSuccess).posts);

      if (index >= 0 && index < posts.length) {
        posts.removeAt(index);

        // Emit updated state with the modified list of posts
        emit(PostListState.success(posts)); 
      }
    }
  }
}
