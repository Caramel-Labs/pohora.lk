package com.example.server.service;

import com.example.server.dto.NewsResponseDTO;

import java.util.List;

public interface NewsService {
    List<NewsResponseDTO> getAllNews();
    NewsResponseDTO getNewsById(Long id);
}

