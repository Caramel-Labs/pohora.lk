import 'package:flutter/material.dart';
import 'package:pohora_lk/data/models/news.dart';
import 'package:pohora_lk/data/models/comment.dart';
import 'package:pohora_lk/data/repositories/news_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NewsDetailScreen extends StatefulWidget {
  final int newsId;

  const NewsDetailScreen({super.key, required this.newsId});

  @override
  State<NewsDetailScreen> createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends State<NewsDetailScreen> {
  final NewsRepository _newsRepository = NewsRepository();
  final TextEditingController _commentController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  News? _news;
  List<Comment> _comments = [];
  bool _isLoadingNews = true;
  bool _isLoadingComments = true;
  bool _isPostingComment = false;

  @override
  void initState() {
    super.initState();
    _loadNewsDetail();
    _loadComments();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _loadNewsDetail() async {
    setState(() {
      _isLoadingNews = true;
    });

    try {
      final news = await _newsRepository.getNewsDetail(widget.newsId);
      setState(() {
        _news = news;
        _isLoadingNews = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingNews = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to load news: $e')));
    }
  }

  Future<void> _loadComments() async {
    setState(() {
      _isLoadingComments = true;
    });

    try {
      final comments = await _newsRepository.getNewsComments(widget.newsId);
      setState(() {
        _comments = comments;
        _isLoadingComments = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingComments = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to load comments: $e')));
    }
  }

  Future<void> _postComment() async {
    final comment = _commentController.text.trim();
    if (comment.isEmpty) return;

    // Check if user is logged in
    if (_auth.currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You must be logged in to comment')),
      );
      return;
    }

    setState(() {
      _isPostingComment = true;
    });

    try {
      final success = await _newsRepository.addComment(widget.newsId, comment);

      if (success) {
        _commentController.clear();
        // Reload comments to show the new one
        await _loadComments();
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Failed to add comment')));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() {
        _isPostingComment = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('News Detail'), elevation: 0),
      body:
          _isLoadingNews
              ? const Center(child: CircularProgressIndicator())
              : _news == null
              ? const Center(child: Text('News not found'))
              : Column(
                children: [
                  // News content in a scrollable area
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Cover image
                          _buildCoverImage(),

                          // News content
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Title
                                Text(
                                  _news!.title,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 12),

                                // Author and date
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 16,
                                      backgroundColor: Theme.of(
                                        context,
                                      ).colorScheme.primary.withOpacity(0.2),
                                      child: Text(
                                        _news!.author
                                            .substring(0, 1)
                                            .toUpperCase(),
                                        style: TextStyle(
                                          color:
                                              Theme.of(
                                                context,
                                              ).colorScheme.primary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      _news!.author,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      '•',
                                      style: TextStyle(
                                        color: Colors.grey.shade400,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      _news!.formattedDate,
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 16),
                                const Divider(),
                                const SizedBox(height: 16),

                                // Body
                                Text(
                                  _news!.body,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    height: 1.6,
                                  ),
                                ),

                                const SizedBox(height: 24),

                                // Comments section divider
                                Row(
                                  children: [
                                    const Icon(Icons.comment_outlined),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Comments (${_comments.length})',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 16),

                                // Comments
                                _buildCommentsSection(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Comment input area at the bottom
                  _buildCommentInput(),
                ],
              ),
    );
  }

  Widget _buildCoverImage() {
    // For the image URL, we'll use a placeholder if the API is down
    final imageUrl = 'https://placehold.co/600x400/png?text=${_news!.title}';
    return SizedBox(
      height: 200,
      width: double.infinity,
      child: Image.network(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder:
            (_, __, ___) => Container(
              color: Colors.grey.shade300,
              child: Center(
                child: Icon(
                  Icons.image_not_supported,
                  size: 48,
                  color: Colors.grey.shade500,
                ),
              ),
            ),
      ),
    );
  }

  Widget _buildCommentsSection() {
    if (_isLoadingComments) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_comments.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'No comments yet. Be the first to comment!',
            style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _comments.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        final comment = _comments[index];
        return _buildCommentItem(comment);
      },
    );
  }

  Widget _buildCommentItem(Comment comment) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User avatar
          CircleAvatar(
            radius: 18,
            backgroundColor: Colors.grey.shade200,
            child: Text(
              comment.userName?.substring(0, 1).toUpperCase() ??
                  comment.userId.substring(0, 1).toUpperCase(),
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Comment content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User name and time
                Row(
                  children: [
                    Text(
                      comment.userName ?? 'User',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      comment.timeAgo,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 4),

                // Comment text
                Text(comment.content, style: const TextStyle(height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentInput() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _commentController,
              decoration: const InputDecoration(
                hintText: 'Write a comment...',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              maxLines: 3,
              minLines: 1,
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            height: 48,
            width: 48,
            child:
                _isPostingComment
                    ? const CircularProgressIndicator()
                    : IconButton(
                      icon: const Icon(Icons.send),
                      color: Theme.of(context).colorScheme.primary,
                      onPressed: _postComment,
                    ),
          ),
        ],
      ),
    );
  }
}
