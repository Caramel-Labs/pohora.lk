package com.example.server.service;

import com.example.server.dto.FertilizerDTO;

import java.util.List;

public interface FertilizerService {
    List<FertilizerDTO> getAllFertilizers();
    FertilizerDTO getFertilizerById(Long id);
    void deleteFertilizer(Long id);
}
