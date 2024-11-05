import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';
import '../../../app-providers/post_provider.dart';
import '../../../commom/ui/shimmers.dart';
import '../../../data-models.dart/postModel.dart' as postData;
import '../for-you/for-you.dart';

class PostsILiked extends StatelessWidget {
  const PostsILiked({super.key});

  @override
  Widget build(BuildContext context) {
    final postProvider = Provider.of<PostProvider>(context);
    return postProvider.isLoadingPostsLiked
        ? ShimmerList()
        : postProvider.postLiked.isNotEmpty
            ? Container(
                child: ListView.separated(
                // physics: NeverScrollableScrollPhysics(),
                // shrinkWrap: true,
                // reverse: true,
                itemCount: postProvider.postLiked.length,
                separatorBuilder: (context, index) {
                  return const Divider(
                      thickness: 1, height: 0, color: Color(0xFF747474));
                },
                itemBuilder: ((BuildContext context, index) {
                  postData.Data post = postProvider.postLiked[index];
                  return PostContainer(
                    id: post.sId as String,
                    content: "${post.message}",
                    commentCounts: post.comments as int,
                    likes: post.likes as int,
                    author: "${post.author![0].firstName}",
                    authorAvatar: post.author![0].profilePicture,
                    date: "${Jiffy(post.updatedAt).fromNow()}",
                    image:
                        post.media!.length > 0 ? "${post.media![0].url}" : null,
                    postProvider: postProvider,
                    authorId: post.author![0].sId as String,
                    userLiked: post.userLiked,
                    isLoggedIn: true,
                  );
                }),
              ))
            : const Center(
                child: Text("You have not liked any post yet",
                    style: TextStyle(color: (Colors.white))));
  }
}
