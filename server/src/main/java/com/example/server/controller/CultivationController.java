package com.example.server.controller;

import com.example.server.dto.CultivationDTO;
import com.example.server.model.Cultivation;
import com.example.server.service.CultivationService;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/cultivations")
@RequiredArgsConstructor
public class CultivationController {
    @Autowired
    private CultivationService cultivationService;

    @PostMapping
    public ResponseEntity<Long> createCultivation(@RequestBody CultivationDTO dto) {
        return ResponseEntity.ok(cultivationService.createCultivation(dto));
    }

    @GetMapping("/user/{userId}")
    public ResponseEntity<List<CultivationDTO>> getByUserId(@PathVariable String userId) {
        return ResponseEntity.ok(cultivationService.getCultivationsByUserId(userId));
    }

    @GetMapping("/{id}")
    public ResponseEntity<Cultivation> getById(@PathVariable Long id) {
        return ResponseEntity.ok(cultivationService.getCultivationById(id));
    }
}

