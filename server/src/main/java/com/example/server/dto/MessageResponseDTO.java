package com.example.server.dto;


import lombok.*;

import java.time.LocalDateTime;

@Data
@Setter
@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class MessageResponseDTO {
    private Boolean isBot;
    private String userId;
    private String content;
    private LocalDateTime timestamp;
}
