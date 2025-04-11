package com.example.server.dto;

import lombok.*;

@Data
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class CommentRequestDTO {
    private String content;
    private String userId;
    private Long newsId;
}
