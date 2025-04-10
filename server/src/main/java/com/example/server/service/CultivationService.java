package com.example.server.service;

import com.example.server.dto.CultivationDTO;
import com.example.server.model.Cultivation;

import java.util.List;

public interface CultivationService {
    Long createCultivation(CultivationDTO cultivationDTO);
    List<CultivationDTO> getCultivationsByUserId(String userId);
    Cultivation getCultivationById(Long cultivationId);
}

