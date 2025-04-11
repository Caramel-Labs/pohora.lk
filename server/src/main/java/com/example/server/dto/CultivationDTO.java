package com.example.server.dto;

import lombok.*;

@Data
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class CultivationDTO {
    private String soilType;
    private Double landArea;
    private String location;
    private Long cropId;
    private String userId;
}
