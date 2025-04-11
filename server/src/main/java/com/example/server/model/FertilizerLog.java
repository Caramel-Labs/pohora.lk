package com.example.server.model;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

@Entity
@Data
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class FertilizerLog {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private LocalDateTime timestamp;

    @ManyToOne
    @JoinColumn(name = "cultivation_id")
    private Cultivation cultivation;

    @ManyToOne
    @JoinColumn(name = "fertilizer_id")
    private Fertilizer fertilizer;
}

