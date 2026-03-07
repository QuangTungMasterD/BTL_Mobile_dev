import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:btl_music_app/features/comment/data/models/comment_model.dart';
import 'package:btl_music_app/features/comment/data/repo/comment_repo.dart';
import 'package:btl_music_app/core/providers/user_provider.dart';
import 'comment_event.dart';
import 'comment_state.dart';

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  final CommentRepository _repository;
  final UserProvider _userProvider;
  final String songId;
  StreamSubscription? _subscription;

  CommentBloc({
    required CommentRepository repository,
    required UserProvider userProvider,
    required this.songId,
  })  : _repository = repository,
        _userProvider = userProvider,
        super(CommentState(currentUserId: userProvider.user?.uid)) {
    on<LoadComments>(_onLoadComments);
    on<CommentsUpdated>(_onCommentsUpdated);
    on<AddComment>(_onAddComment);
    on<DeleteComment>(_onDeleteComment);
    on<ToggleLike>(_onToggleLike);
    on<SetReplyingTo>(_onSetReplyingTo);
  }

  Future<void> _onLoadComments(
    LoadComments event,
    Emitter<CommentState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));
    _subscription?.cancel();

    _subscription = _repository.getCommentsStream(songId).listen(
      (comments) {
        add(CommentsUpdated(comments));
      },
      onError: (error) {
        add(CommentsUpdated([]));
      },
    );
  }

  void _onCommentsUpdated(
    CommentsUpdated event,
    Emitter<CommentState> emit,
  ) {
    emit(state.copyWith(comments: event.comments, isLoading: false, error: null));
  }

  Future<void> _onAddComment(
    AddComment event,
    Emitter<CommentState> emit,
  ) async {
    final currentUserId = _userProvider.user?.uid;
    if (currentUserId == null) return;

    final newComment = CommentModel(
      id: '',
      songId: songId,
      userId: currentUserId,
      userName: _userProvider.user?.displayName ?? 'Người dùng',
      userAvatar: _userProvider.user?.avatar,
      content: event.content,
      createdAt: DateTime.now(),
      parentId: event.parentId,
    );
    try {
      await _repository.addComment(newComment);
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> _onDeleteComment(
    DeleteComment event,
    Emitter<CommentState> emit,
  ) async {
    try {
      await _repository.softDeleteComment(songId, event.commentId);
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> _onToggleLike(
    ToggleLike event,
    Emitter<CommentState> emit,
  ) async {
    final currentUserId = _userProvider.user?.uid;
    if (currentUserId == null) return;
    try {
      await _repository.toggleLike(songId, event.commentId, currentUserId);
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  void _onSetReplyingTo(
    SetReplyingTo event,
    Emitter<CommentState> emit,
  ) {
    emit(state.copyWith(replyingTo: event.comment));
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
