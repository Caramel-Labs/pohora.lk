package com.example.server.repository;

import com.example.server.model.Cultivation;
import com.example.server.model.FertilizerLog;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface FertilizerLogRepository extends JpaRepository<FertilizerLog, Long> {
    List<FertilizerLog> findByCultivationId(Long cultivationId);
}
