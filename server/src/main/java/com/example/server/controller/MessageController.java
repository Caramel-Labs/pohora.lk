package com.example.server.controller;

import com.example.server.dto.MessageRequestDTO;
import com.example.server.dto.MessageResponseDTO;
import com.example.server.service.MessageService;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/messages")
@RequiredArgsConstructor
public class MessageController {

    @Autowired
    private final MessageService messageService;

    @GetMapping("/{userId}")
    public ResponseEntity<List<MessageResponseDTO>> getMessages(@PathVariable String userId) {
        return ResponseEntity.ok(messageService.getMessagesByUserId(userId));
    }

    @PostMapping("/send")
    public ResponseEntity<MessageResponseDTO> handleMessage(@RequestBody MessageRequestDTO requestDTO) {
        return ResponseEntity.ok(messageService.handleMessage(requestDTO));
    }
}