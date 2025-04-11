package com.example.server.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/home")
@RequiredArgsConstructor
public class HelloController {
    @GetMapping("/")
    public ResponseEntity<String> sayHello() {
        return ResponseEntity.ok("This is the backend server of the Agri Assistant App");
    }
    @GetMapping("/info")
    public String getSystemInfo() {
        String os = System.getProperty("os.name");
        String osVersion = System.getProperty("os.version");
        String osArch = System.getProperty("os.arch");
        String javaVersion = System.getProperty("java.version");
        String user = System.getProperty("user.name");

        return String.format("OS: %s\nOS Version: %s\nOS Architecture: %s\nJava Version: %s\nUser: %s",
                os, osVersion, osArch, javaVersion, user);
    }

}