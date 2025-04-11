package com.example.server.service;

import com.example.server.dto.CommentRequestDTO;
import com.example.server.dto.CommentResponseDTO;

import java.util.List;

public interface CommentService {
    List<CommentResponseDTO> getCommentsByNewsId(Long newsId);
    CommentResponseDTO createComment(CommentRequestDTO dto);
}
