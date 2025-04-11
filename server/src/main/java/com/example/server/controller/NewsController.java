package com.example.server.controller;

import com.example.server.dto.CommentRequestDTO;
import com.example.server.dto.CommentResponseDTO;
import com.example.server.dto.NewsResponseDTO;
import com.example.server.service.CommentService;
import com.example.server.service.NewsService;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/news")
@RequiredArgsConstructor
public class NewsController {

    @Autowired
    private final NewsService newsService;
    @Autowired
    private final CommentService commentService;

    // GET all news
    @GetMapping
    public ResponseEntity<List<NewsResponseDTO>> getAllNews() {
        return ResponseEntity.ok(newsService.getAllNews());
    }

    // GET single news
    @GetMapping("/{id}")
    public ResponseEntity<NewsResponseDTO> getNewsById(@PathVariable Long id) {
        return ResponseEntity.ok(newsService.getNewsById(id));
    }

    // GET all comments by newsId
    @GetMapping("/{newsId}/comments")
    public ResponseEntity<List<CommentResponseDTO>> getCommentsByNewsId(@PathVariable Long newsId) {
        return ResponseEntity.ok(commentService.getCommentsByNewsId(newsId));
    }

    // POST a comment
    @PostMapping("/comment")
    public ResponseEntity<CommentResponseDTO> createComment(@RequestBody CommentRequestDTO dto) {
        return ResponseEntity.status(HttpStatus.CREATED).body(commentService.createComment(dto));
    }
}
