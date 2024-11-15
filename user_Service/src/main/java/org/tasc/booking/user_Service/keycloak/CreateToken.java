//package org.springframework.boot.login.keycloak;
//
//import com.fasterxml.jackson.core.JsonProcessingException;
//import com.fasterxml.jackson.databind.JsonNode;
//import com.fasterxml.jackson.databind.ObjectMapper;
//import lombok.RequiredArgsConstructor;
//import org.springframework.beans.factory.annotation.Value;
//import org.springframework.boot.login.dto.UserDto;
//import org.springframework.http.HttpEntity;
//import org.springframework.http.HttpHeaders;
//import org.springframework.http.HttpMethod;
//import org.springframework.http.ResponseEntity;
//import org.springframework.security.crypto.password.PasswordEncoder;
//import org.springframework.util.LinkedMultiValueMap;
//import org.springframework.util.MultiValueMap;
//import org.springframework.web.bind.annotation.*;
//import org.springframework.web.client.RestTemplate;
//import org.springframework.web.util.UriComponentsBuilder;
//
//
//@RestController
//@RequestMapping("api/v1/token")
//@RequiredArgsConstructor
//public class CreateToken {
//    public final RestTemplate restTemplate;
//
//    @Value("${spring.security.oauth2.resourceserver.opaquetoken.client-id}")
//    public String clientId;
//    @Value("${spring.security.oauth2.resourceserver.opaquetoken.client-secret}")
//    public String clientSecret;
//    @Value("${token.enpont}")
//    public String tokenEndpoint;
//
//
//    public final String USER_GROUP= "00fb228b-6c9c-470b-97d0-3c3cbec28465";
//    public final String ADMIN_GROUP= "9e683088-ed54-4ca1-96c8-d763642e2e50";
//
//    public final PasswordEncoder passwordEncoder;
//
//
//    private String getTokenProject() throws JsonProcessingException {
//
//        String url = UriComponentsBuilder.fromHttpUrl(tokenEndpoint).toUriString();
//
//        HttpHeaders headers = new HttpHeaders();
//        headers.set("Content-Type", "application/x-www-form-urlencoded");
//
//        MultiValueMap<String,String> body = new LinkedMultiValueMap<>();
//        body.add("grant_type", "client_credentials");
//        body.add("client_id", clientId);
//        body.add("client_secret", clientSecret);
//
//        HttpEntity<MultiValueMap<String, String>> request = new HttpEntity<>(body, headers);
//        ResponseEntity<String> response = restTemplate.exchange(url, HttpMethod.POST, request, String.class);
//
//        if(response.getStatusCode().is2xxSuccessful()){
//            String data = response.getBody();
//
//            ObjectMapper mapper = new ObjectMapper();
//            JsonNode jsonNode = mapper.readTree(data);
//            return jsonNode.path("access_token").asText();
//
//        }else {
//            System.err.println("Failed to get token. Status code: " + response.getStatusCode());
//        }
//        return "Failed to get token. Status code";
//    }
//
//    @PostMapping
//    public String add(@RequestBody  UserDto userDto) throws JsonProcessingException {
//        String url = String.format("http://localhost:8081/admin/realms/%s/users", clientId);
//        String token = getTokenProject();
//
//
//        HttpHeaders headers = new HttpHeaders();
//        headers.set("Content-Type", "application/json");
//        headers.set("Authorization","Bearer " + token);
//
//
//
//        HttpEntity<UserDto>request = new HttpEntity<>(userDto, headers);
//        ResponseEntity<String> response = restTemplate.exchange(url, HttpMethod.POST, request, String.class);
//        if (response.getStatusCode().is2xxSuccessful()) {
//            String dataUser = userId(userDto.getUsername(),token);
//            System.out.println(dataUser);
//            addUserInGroup(dataUser,token);
//
//
//            return response.getBody();
//        }
//        return "loi me roi";
//    }
//
//
//
//
//
//    public String userId(String uerName,String token) throws JsonProcessingException {
//        String url = String.format("http://localhost:8081/admin/realms/%s/users?username=%s", clientId,uerName);
//        HttpHeaders headers = new HttpHeaders();
//        headers.set("Content-Type", "application/json");
//        headers.set("Authorization","Bearer " + token);
//
//        HttpEntity<String> request = new HttpEntity<>(headers);
//        ResponseEntity<String> response = restTemplate.exchange(url, HttpMethod.GET, request, String.class);
//        if (response.getStatusCode().is2xxSuccessful()) {
//            ObjectMapper objectMapper = new ObjectMapper();
//            JsonNode jsonNode = objectMapper.readTree(response.getBody());
//            JsonNode firstObject = jsonNode.get(0);
//            return firstObject.path("id").asText();
//        }
//        return "loi me roi";
//    }
//
//
//    public String addUserInGroup(String userId,String token){
//        String url = String.format("http://localhost:8081/admin/realms/%s/users/%s/groups/%s",clientId,userId,USER_GROUP);
//        HttpHeaders headers = new HttpHeaders();
//        headers.set("Content-Type", "application/json");
//        headers.set("Authorization","Bearer " + token);
//        HttpEntity<String> request = new HttpEntity<>(headers);
//        ResponseEntity<String> response = restTemplate.exchange(url, HttpMethod.PUT, request, String.class);
//
//        if (response.getStatusCode().is2xxSuccessful()) {
//            return  "add OK " + userId + USER_GROUP;
//        }
//        return "loi me roi addUserInGroup";
//
//    }
//
//    // todo login
//    @PostMapping("/login")
//    private String login(@RequestParam String email,@RequestParam String password) throws JsonProcessingException {
//
//        String url = UriComponentsBuilder.fromHttpUrl(tokenEndpoint).toUriString();
//
//        HttpHeaders headers = new HttpHeaders();
//        headers.set("Content-Type", "application/x-www-form-urlencoded");
//
//
//        MultiValueMap<String,String> body = new LinkedMultiValueMap<>();
//        body.add("client_id", clientId);
//        body.add("client_secret", clientSecret);
//        body.set("grant_type", "password");
//        body.add("username", email);
//        body.add("password", password);
//
//
//
//        HttpEntity<MultiValueMap<String, String>> request = new HttpEntity<>(body, headers);
//        ResponseEntity<String> response = restTemplate.exchange(url, HttpMethod.POST, request, String.class);
//
//        if(response.getStatusCode().is2xxSuccessful()){
//            String data = response.getBody();
//            System.out.println(data);
//
//            ObjectMapper mapper = new ObjectMapper();
//            JsonNode jsonNode = mapper.readTree(data);
//
//            userInfo(jsonNode.path("access_token").asText());
//            return jsonNode.path("access_token").asText();
//
//        }else {
//            System.err.println("Failed to get token. Status code: " + response.getStatusCode());
//        }
//        return "Failed to get token. Status code";
//    }
//
//
//
//
//
//
//
//    @GetMapping("groupId")
//
//    public String groupId() throws JsonProcessingException {
//        String url = String.format("http://localhost:8081/admin/realms/%s/groups", clientId);
//
//        String token = getTokenProject();
//
//        HttpHeaders headers = new HttpHeaders();
//        headers.set("Authorization","bearer " + token);
//
//        HttpEntity<String> request = new HttpEntity<>(headers);
//        ResponseEntity<String> response = restTemplate.exchange(url, HttpMethod.GET, request, String.class);
//        if (response.getStatusCode().is2xxSuccessful()) {
//            return response.getBody();
//        }
//        return "loi me roi";
//
//    }
//
//    @GetMapping("user_info")
//    public String userInfo(String token) {
//        String url =String.format("http://localhost:8081/realms/%s/protocol/openid-connect/token/introspect",clientId);
//        HttpHeaders headers = new HttpHeaders();
//        headers.set("Content-Type", "application/x-www-form-urlencoded");
//
//        MultiValueMap<String,String>body = new LinkedMultiValueMap<>();
//        body.add("token", token);
//        body.add("client_id", clientId);
//        body.add("client_secret", clientSecret);
//        HttpEntity<MultiValueMap<String, String>> request = new HttpEntity<>(body, headers);
//        ResponseEntity<String> response = restTemplate.exchange(url,HttpMethod.POST,request,String.class);
//        if (response.getStatusCode().is2xxSuccessful()) {
//            System.out.println(response.getBody());
//          return response.getBody();
//        }
//
//return null;
//    }
//
//
//
//
//}
