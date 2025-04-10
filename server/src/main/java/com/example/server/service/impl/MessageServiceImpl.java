package com.example.server.service.impl;

import com.example.server.dto.MessageRequestDTO;
import com.example.server.dto.MessageResponseDTO;
import com.example.server.model.Message;
import com.example.server.repository.MessageRepository;
import com.example.server.service.MessageService;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class MessageServiceImpl implements MessageService {

    @Autowired
    private final MessageRepository messageRepository;

    private final RestTemplate restTemplate;

    @Override
    public List<MessageResponseDTO> getMessagesByUserId(String userId) {
        List<Message> messages = messageRepository.findByUserId(userId);
        return messages.stream().map(this::mapToDTO).collect(Collectors.toList());
    }

    @Override
    public MessageResponseDTO handleMessage(MessageRequestDTO requestDTO) {
        // 1. Save user message
        Message userMessage = Message.builder()
                .isBot(false)
                .userId(requestDTO.getUserId())
                .content(requestDTO.getContent())
                .timestamp(LocalDateTime.now())
                .build();
        messageRepository.save(userMessage);

        // 2. Build request for external bot API
        Map<String, Object> message = Map.of(
                "content", requestDTO.getContent(),
                "sender", "human"
        );
        Map<String, Object> requestBody = Map.of(
                "messages", List.of(message)
        );

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        HttpEntity<Map<String, Object>> request = new HttpEntity<>(requestBody, headers);

        // 3. Send request
        ResponseEntity<Map> response = restTemplate.postForEntity(
                "https://pohora-intelligence.koyeb.app/chat/get-agent-response/",
                request,
                Map.class
        );

        // 4. Parse response
        Map<String, Object> data = (Map<String, Object>) response.getBody().get("data");
        String botReply = (String) data.get("output");
        if (botReply.length() > 255) {
            botReply = botReply.substring(0, 255);
        }
        // 5. Save bot message
        Message botMessage = Message.builder()
                .isBot(true)
                .userId(requestDTO.getUserId())
                .content(botReply)
                .timestamp(LocalDateTime.now())
                .build();
        messageRepository.save(botMessage);

        // 6. Return bot reply
        return mapToDTO(botMessage);
    }
    private MessageResponseDTO mapToDTO(Message message) {
        return MessageResponseDTO.builder()
                .isBot(message.getIsBot())
                .userId(message.getUserId())
                .content(message.getContent())
                .timestamp(message.getTimestamp())
                .build();
    }

}

