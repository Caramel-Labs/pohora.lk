package com.example.server.dto;
import lombok.*;

@Data
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class FertilizerDTO {
    private Long id;
    private String name;
    private String description;
    private String imagePath;
    private String instructions;
    private String percentage;
}
