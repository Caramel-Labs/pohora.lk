package com.example.server.repository;

import com.example.server.model.Crop;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
@Repository
public interface CropRepository extends JpaRepository<Crop, Long> {
}
