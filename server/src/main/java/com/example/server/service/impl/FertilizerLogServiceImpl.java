package com.example.server.service.impl;

import com.example.server.dto.FertilizerLogDTO;
import com.example.server.exceptions.ResourceNotFoundException;
import com.example.server.model.Cultivation;
import com.example.server.model.Fertilizer;
import com.example.server.model.FertilizerLog;
import com.example.server.repository.CultivationRepository;
import com.example.server.repository.FertilizerLogRepository;
import com.example.server.repository.FertilizerRepository;
import com.example.server.service.FertilizerLogService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class FertilizerLogServiceImpl implements FertilizerLogService {

    private final FertilizerLogRepository fertilizerLogRepo;
    private final CultivationRepository cultivationRepository;
    private final FertilizerRepository fertilizerRepository;

    @Override
    public List<FertilizerLogDTO> getFertilizerLogByCultivationId(Long cultivationId) {
        return fertilizerLogRepo.findByCultivationId(cultivationId)
                .stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }
    @Override
    public Long createFertilizerLog(FertilizerLogDTO dto) {
        Cultivation cultivation = cultivationRepository.findById(dto.getCultivationId())
                .orElseThrow(() -> new ResourceNotFoundException("Cultivation not found with id: " + dto.getCultivationId()));

        Fertilizer fertilizer = fertilizerRepository.findById(dto.getFertilizerId())
                .orElseThrow(() -> new ResourceNotFoundException("Fertilizer not found with id: " + dto.getFertilizerId()));

        FertilizerLog log = FertilizerLog.builder()
                .timestamp(dto.getTimestamp() != null ? dto.getTimestamp() : LocalDateTime.now())
                .cultivation(cultivation)
                .fertilizer(fertilizer)
                .build();

        return fertilizerLogRepo.save(log).getId();
    }

    @Override
    public void deleteFertilizerLog(Long id) {
        if (!fertilizerLogRepo.existsById(id)) {
            throw new ResourceNotFoundException("Fertilizer log not found with id: " + id);
        }
        fertilizerLogRepo.deleteById(id);
    }
    private FertilizerLogDTO convertToDTO(FertilizerLog log) {
        FertilizerLogDTO dto = new FertilizerLogDTO();
        dto.setId(log.getId());
        dto.setTimestamp(log.getTimestamp());
        dto.setCultivationId(log.getCultivation().getId());
        dto.setFertilizerId(log.getFertilizer().getId());
        dto.setFertilizerName(log.getFertilizer().getName());
        return dto;
    }
}
