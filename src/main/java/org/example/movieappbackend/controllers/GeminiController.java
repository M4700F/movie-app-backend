package org.example.movieappbackend.controllers;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.*;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.RestTemplate;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/chat")
@CrossOrigin(origins = "*")
public class GeminiController {

    @Value("${gemini.api.key}")
    private String apiKey;

    // ✅ Using Gemini Pro model (most compatible)
    private final String GEMINI_API_URL =
            "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=";

    @PostMapping
    public ResponseEntity<Map<String, Object>> chat(@RequestBody Map<String, String> request) {
        String prompt = request.get("message");

        if (prompt == null || prompt.trim().isEmpty()) {
            return ResponseEntity.badRequest().body(Map.of("error", "Message is required"));
        }

        RestTemplate restTemplate = new RestTemplate();

        try {
            // ✅ Correct request body for Gemini 1.5
            Map<String, Object> body = Map.of(
                    "contents", List.of(
                            Map.of(
                                    "parts", List.of(
                                            Map.of("text", prompt)
                                    )
                            )
                    )
            );

            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);

            HttpEntity<Map<String, Object>> entity = new HttpEntity<>(body, headers);

            ResponseEntity<Map> response = restTemplate.exchange(
                    GEMINI_API_URL + apiKey,
                    HttpMethod.POST,
                    entity,
                    Map.class
            );

            Map<String, Object> bodyMap = response.getBody();
            if (bodyMap == null) {
                return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                        .body(Map.of("error", "Invalid response from Gemini API"));
            }

            // ✅ Extract response from Gemini 1.5 structure
            List<Map<String, Object>> candidates = (List<Map<String, Object>>) bodyMap.get("candidates");
            if (candidates == null || candidates.isEmpty()) {
                return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                        .body(Map.of("error", "No response from Gemini API"));
            }

            Map<String, Object> content = (Map<String, Object>) candidates.get(0).get("content");
            if (content == null) {
                return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                        .body(Map.of("error", "No content in response"));
            }

            List<Map<String, Object>> parts = (List<Map<String, Object>>) content.get("parts");
            if (parts == null || parts.isEmpty()) {
                return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                        .body(Map.of("error", "No parts in response"));
            }

            String reply = (String) parts.get(0).get("text");

            return ResponseEntity.ok(Map.of("response", reply));

        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of("error", "Failed to process request: " + e.getMessage()));
        }
    }
}