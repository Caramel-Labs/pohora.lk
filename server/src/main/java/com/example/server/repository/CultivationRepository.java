package com.example.server.repository;

import com.example.server.dto.CultivationDTO;
import com.example.server.model.Cultivation;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CultivationRepository extends JpaRepository<Cultivation, Long> {
    List<Cultivation> findByUserId(String userId);
}

