package com.example.server.controller;

import com.example.server.dto.FertilizerLogDTO;
import com.example.server.model.Cultivation;
import com.example.server.model.Fertilizer;
import com.example.server.model.FertilizerLog;
import com.example.server.service.FertilizerLogService;
import com.example.server.service.impl.FertilizerLogServiceImpl;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/fertilizerLogs")
@RequiredArgsConstructor
public class FertilizerLogController {
    @Autowired
    private final FertilizerLogService fertilizerLogService;

    @GetMapping("/{cultivationId}")
    public ResponseEntity<List<FertilizerLogDTO>> getByUserId(@PathVariable Long cultivationId) {
        return ResponseEntity.ok(fertilizerLogService.getFertilizerLogByCultivationId(cultivationId));
    }
    @PostMapping
    public ResponseEntity<Long> createFertilizerLog(@RequestBody FertilizerLogDTO dto) {
        Long id = fertilizerLogService.createFertilizerLog(dto);
        return ResponseEntity.status(HttpStatus.CREATED).body(id);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteFertilizerLog(@PathVariable Long id) {
        fertilizerLogService.deleteFertilizerLog(id);
        return ResponseEntity.noContent().build();
    }
}
