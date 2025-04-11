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
public class Crop {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String name;
    private String description;
    private String imgPath;

    @OneToMany(mappedBy = "crop", cascade = CascadeType.ALL)
    private List<Cultivation> cultivations;
}
