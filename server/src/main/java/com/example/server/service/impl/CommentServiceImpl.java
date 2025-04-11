package com.example.server.service.impl;

import com.example.server.dto.CommentRequestDTO;
import com.example.server.dto.CommentResponseDTO;
import com.example.server.model.Comment;
import com.example.server.model.News;
import com.example.server.repository.CommentRepository;
import com.example.server.repository.NewsRepository;
import com.example.server.service.CommentService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class CommentServiceImpl implements CommentService {

    private final CommentRepository commentRepository;
    private final NewsRepository newsRepository;

    @Override
    public List<CommentResponseDTO> getCommentsByNewsId(Long newsId) {
        return commentRepository.findByNewsId(newsId)
                .stream()
                .map(this::mapToDTO)
                .collect(Collectors.toList());
    }

    @Override
    public CommentResponseDTO createComment(CommentRequestDTO dto) {
        News news = newsRepository.findById(dto.getNewsId())
                .orElseThrow(() -> new RuntimeException("News not found"));

        Comment comment = Comment.builder()
                .content(dto.getContent())
                .userId(dto.getUserId())
                .timestamp(LocalDateTime.now())
                .news(news)
                .build();

        return mapToDTO(commentRepository.save(comment));
    }

    private CommentResponseDTO mapToDTO(Comment comment) {
        return CommentResponseDTO.builder()
                .id(comment.getId())
                .content(comment.getContent())
                .userId(comment.getUserId())
                .timestamp(comment.getTimestamp())
                .build();
    }
}

