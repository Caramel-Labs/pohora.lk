package com.example.server.service;

import com.example.server.dto.FertilizerLogDTO;
import com.example.server.model.Cultivation;
import com.example.server.model.FertilizerLog;

import java.util.List;

public interface FertilizerLogService {
    List<FertilizerLogDTO> getFertilizerLogByCultivationId(Long cultivationId);
    Long createFertilizerLog(FertilizerLogDTO dto);
    void deleteFertilizerLog(Long id);
}
