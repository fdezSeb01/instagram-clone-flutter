import "package:flutter/material.dart";
import "package:instagram_clone/models/post.dart";
import "package:instagram_clone/models/user.dart";
import "package:instagram_clone/providers/user_provider.dart";
import "package:instagram_clone/utils/colors.dart";
import "package:instagram_clone/widgets/like_animation.dart";
import "package:intl/intl.dart";
import "package:provider/provider.dart";

class PostCard extends StatefulWidget {
  final Post post;

  const PostCard({
    super.key,
    required this.post,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLikeAnimating = false;

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    return Container(
      color: mobileBackgroundColor,
      padding: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      child: Column(
        children: [
          //header
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 4,
              horizontal: 16,
            ).copyWith(right: 0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(widget.post.profImage),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.post.username,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return Dialog(
                          child: ListView(
                            padding: const EdgeInsets.symmetric(
                              vertical: 16,
                            ),
                            shrinkWrap: true,
                            children: [
                              'Delete',
                              'Report',
                              'Stop Following',
                            ]
                                .map((e) => InkWell(
                                      onTap: () {},
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 12,
                                          horizontal: 16,
                                        ),
                                        child: Text(e),
                                      ),
                                    ))
                                .toList(),
                          ),
                        );
                      },
                    );
                  },
                  icon: const Icon(Icons.more_vert),
                ),
              ],
            ),
          ),
          //image section
          GestureDetector(
            child: Stack(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.35,
                  width: double.infinity,
                  child: Image.network(
                    widget.post.postUrl,
                    fit: BoxFit.cover,
                  ),
                ),
                LikeAnimation(
                  isAnimating: isLikeAnimating,
                  duration: const Duration(milliseconds: 400),
                  onEnd: () {
                    setState(() {
                      isLikeAnimating = false;
                    });
                  },
                  child: const Icon(
                    Icons.favorite,
                    color: primaryColor,
                    size: 100,
                  ),
                )
              ],
            ),
            onDoubleTap: () {
              setState(() {
                isLikeAnimating = true;
              });
            },
          ),
          //interaction secction
          Row(
            children: [
              LikeAnimation(
                isAnimating: widget.post.likes.contains(user.uid),
                smallLike: true,
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.favorite,
                    color: Colors.red,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.comment_outlined,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.send,
                ),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.bookmark_outline,
                    ),
                  ),
                ),
              )
            ],
          ),
          //caption
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //likes
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '${widget.post.likes.length} likes',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                //username and caption
                Container(
                  width: double.infinity,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(top: 5),
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                      children: [
                        TextSpan(
                          text: widget.post.username,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1,
                          ),
                        ),
                        TextSpan(
                          text: ' ${widget.post.description}',
                        ),
                      ],
                    ),
                  ),
                ),
                //tap to see comments
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(top: 5),
                  child: GestureDetector(
                    onTap: () {},
                    child: Text(
                      'View all 15 comments',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: secondaryColor),
                    ),
                  ),
                ),
                //Date
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    DateFormat('dd/MM/yyyy')
                        .format(widget.post.datePublished.toDate()),
                    style: Theme.of(context).textTheme.labelMedium!.copyWith(
                          color: secondaryColor,
                          letterSpacing: 1,
                        ),
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
