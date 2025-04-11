package com.example.server.model;

import jakarta.persistence.*;
import lombok.*;

import java.util.List;

@Entity
@Data
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Fertilizer {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String name;
    private String description;
    private String imagePath;
    private String instructions;
    private String percentage;

    @OneToMany(mappedBy = "fertilizer", cascade = CascadeType.ALL)
    private List<FertilizerLog> fertilizerLogs;
}
