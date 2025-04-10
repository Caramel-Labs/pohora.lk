package com.example.server.dto;

import com.example.server.model.Cultivation;
import com.example.server.model.Fertilizer;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import lombok.*;

import java.time.LocalDateTime;

@Data
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class FertilizerLogDTO {
    private Long id;
    private LocalDateTime timestamp;
    private Long cultivationId;
    private Long fertilizerId;
    private String fertilizerName;
}
