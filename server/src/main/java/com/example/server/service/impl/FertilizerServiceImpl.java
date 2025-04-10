package com.example.server.service.impl;

import com.example.server.dto.FertilizerDTO;
import com.example.server.exceptions.ResourceNotFoundException;
import com.example.server.model.Fertilizer;
import com.example.server.repository.FertilizerRepository;
import com.example.server.service.FertilizerService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class FertilizerServiceImpl implements FertilizerService {

    private final FertilizerRepository fertilizerRepository;

    @Override
    public List<FertilizerDTO> getAllFertilizers() {
        return fertilizerRepository.findAll().stream().map(this::convertToDTO).toList();
    }

    @Override
    public FertilizerDTO getFertilizerById(Long id) {
        Fertilizer fertilizer = fertilizerRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Fertilizer not found with id: " + id));
        return convertToDTO(fertilizer);
    }

    @Override
    public void deleteFertilizer(Long id) {
        if (!fertilizerRepository.existsById(id)) {
            throw new ResourceNotFoundException("Fertilizer not found with id: " + id);
        }
        fertilizerRepository.deleteById(id);
    }

    private FertilizerDTO convertToDTO(Fertilizer fertilizer) {
        return FertilizerDTO.builder()
                .id(fertilizer.getId())
                .name(fertilizer.getName())
                .description(fertilizer.getDescription())
                .imagePath(fertilizer.getImagePath())
                .instructions(fertilizer.getInstructions())
                .percentage(fertilizer.getPercentage())
                .build();
    }
}
