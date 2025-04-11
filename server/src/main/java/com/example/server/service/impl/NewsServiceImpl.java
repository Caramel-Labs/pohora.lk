package com.example.server.service.impl;

import com.example.server.dto.NewsResponseDTO;
import com.example.server.model.News;
import com.example.server.repository.NewsRepository;
import com.example.server.service.NewsService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class NewsServiceImpl implements NewsService {

    private final NewsRepository newsRepository;

    @Override
    public List<NewsResponseDTO> getAllNews() {
        return newsRepository.findAll().stream().map(this::mapToDTO).collect(Collectors.toList());
    }

    @Override
    public NewsResponseDTO getNewsById(Long id) {
        News news = newsRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("News not found"));
        return mapToDTO(news);
    }

    private NewsResponseDTO mapToDTO(News news) {
        return NewsResponseDTO.builder()
                .id(news.getId())
                .title(news.getTitle())
                .body(news.getBody())
                .imagePath(news.getImagePath())
                .timestamp(news.getTimestamp())
                .author(news.getAuthor())
                .build();
    }
}
