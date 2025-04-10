package com.example.server.dto;

import lombok.*;

import java.time.LocalDateTime;

@Data
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class NewsResponseDTO {
    private Long id;
    private String title;
    private String body;
    private String imagePath;
    private LocalDateTime timestamp;
    private String author;
}
