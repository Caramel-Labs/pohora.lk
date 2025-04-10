package com.example.server.controller;

import com.example.server.dto.FertilizerDTO;
import com.example.server.service.FertilizerService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/fertilizers")
@RequiredArgsConstructor
public class FertilizerController {

    private final FertilizerService fertilizerService;

    @GetMapping
    public ResponseEntity<List<FertilizerDTO>> getAllFertilizers() {
        List<FertilizerDTO> fertilizers = fertilizerService.getAllFertilizers();
        return ResponseEntity.ok(fertilizers);
    }

    @GetMapping("/{id}")
    public ResponseEntity<FertilizerDTO> getFertilizerById(@PathVariable Long id) {
        FertilizerDTO fertilizer = fertilizerService.getFertilizerById(id);
        return ResponseEntity.ok(fertilizer);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteFertilizer(@PathVariable Long id) {
        fertilizerService.deleteFertilizer(id);
        return ResponseEntity.noContent().build();
    }
}
