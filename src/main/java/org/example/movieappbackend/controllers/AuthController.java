package org.example.movieappbackend.controllers;

import org.example.movieappbackend.Security.CustomUserDetailService;
import org.example.movieappbackend.Security.JwtTokenHelper;
import org.example.movieappbackend.exceptions.ApiException;
import org.example.movieappbackend.payloads.JwtAuthRequest;
import org.example.movieappbackend.payloads.JwtAuthResponse;
import org.example.movieappbackend.payloads.UserDto;
import org.example.movieappbackend.services.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/v1/auth")
public class AuthController {

    @Autowired
    private JwtTokenHelper jwtTokenHelper;

    @Autowired
    private AuthenticationManager authenticationManager;

    @Autowired
    private CustomUserDetailService customUserDetailService;

    @Autowired
    private UserService userService;

    @PostMapping("/register")
    public ResponseEntity<UserDto> registerUser(@RequestBody UserDto userDto){
        UserDto registeredUser = this.userService.registerUser(userDto);
        return new ResponseEntity<>(registeredUser, HttpStatus.CREATED);
    }

    @PostMapping("/login")
    public ResponseEntity<JwtAuthResponse> createToken(@RequestBody JwtAuthRequest request) throws Exception {
        this.authenticate(request.getUsername(), request.getPassword());

        // Only reach here if authentication succeeds
        System.out.println("Authentication successful for user: " + request.getUsername());

        // Load user details
        UserDetails userDetails = this.customUserDetailService.loadUserByUsername(request.getUsername());

        String token = this.jwtTokenHelper.generateToken(userDetails.getUsername());

        JwtAuthResponse jwtAuthResponse = new JwtAuthResponse();
        jwtAuthResponse.setToken(token);

        return new ResponseEntity<>(jwtAuthResponse, HttpStatus.OK);


    }

    private void authenticate(String username, String password) throws BadCredentialsException {
        UsernamePasswordAuthenticationToken usernamePasswordAuthenticationToken = new UsernamePasswordAuthenticationToken(username, password);

        try {
            this.authenticationManager.authenticate(usernamePasswordAuthenticationToken);
        }
        catch (BadCredentialsException e){
            System.out.println("Invalid Details");
            throw new ApiException("Invalid Username or Password");

        }
    }

    @GetMapping("/me")
    public ResponseEntity<UserDto> getCurrentUser(@RequestHeader(value = "Authorization", required = false) String authHeader) {
        String token = jwtTokenHelper.extractTokenFromHeader(authHeader);
        if (token == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }

        String username = jwtTokenHelper.getUsernameFromToken(token);
        UserDto user = userService.getUserByEmail(username); // your service already has this
        return ResponseEntity.ok(user);
    }



}
