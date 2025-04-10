package com.example.server.service.impl;

import com.example.server.dto.CultivationDTO;
import com.example.server.exceptions.ResourceNotFoundException;
import com.example.server.model.Crop;
import com.example.server.model.Cultivation;
import com.example.server.repository.CropRepository;
import com.example.server.repository.CultivationRepository;
import com.example.server.service.CultivationService;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class CultivationServiceImpl implements CultivationService {

    @Autowired
    private final CultivationRepository cultivationRepository;
    @Autowired
    private final CropRepository cropRepository;

    @Override
    public Long createCultivation(CultivationDTO dto) {
        Crop crop = cropRepository.findById(dto.getCropId())
                .orElseThrow(() -> new ResourceNotFoundException("Crop not found with id: " + dto.getCropId()));

        Cultivation cultivation = Cultivation.builder()
                .soilType(dto.getSoilType())
                .landArea(dto.getLandArea())
                .location(dto.getLocation())
                .userId(dto.getUserId())
                .crop(crop)
                .build();
        Cultivation savedCultivation = cultivationRepository.save(cultivation);

        return savedCultivation.getId();
    }

    @Override
    public List<CultivationDTO> getCultivationsByUserId(String userId) {
        return cultivationRepository.findByUserId(userId)
                .stream()
                .map(c -> new CultivationDTO(c.getSoilType(),c.getLandArea(),c.getLocation(),c.getCrop().getId(), c.getUserId()))
                .toList();
    }

    @Override
    public Cultivation getCultivationById(Long cultivationId) {
        return cultivationRepository.findById(cultivationId)
                .orElseThrow(() -> new ResourceNotFoundException("Cultivation not found with id: " + cultivationId));
    }
}
