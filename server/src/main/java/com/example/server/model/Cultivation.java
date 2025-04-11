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
public class Cultivation {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String soilType;
    private Double landArea;
    private String location;
    private String userId;

    @ManyToOne
    @JoinColumn(name = "crop_id")
    private Crop crop;

    @OneToMany(mappedBy = "cultivation", cascade = CascadeType.ALL)
    private List<FertilizerLog> fertilizerLogs;
}
