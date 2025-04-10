package com.example.server.service;

import com.example.server.dto.MessageRequestDTO;
import com.example.server.dto.MessageResponseDTO;

import java.util.List;

public interface MessageService {
    List<MessageResponseDTO> getMessagesByUserId(String userId);
    MessageResponseDTO handleMessage(MessageRequestDTO requestDTO);
}
