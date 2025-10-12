package org.example.movieappbackend.services.impl;

import org.example.movieappbackend.entities.User;
import org.example.movieappbackend.exceptions.ResourceNotFoundException;
import org.example.movieappbackend.payloads.UserDto;
import org.example.movieappbackend.repositories.UserRepo;
import org.example.movieappbackend.services.UserService;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class UserServiceImpl implements UserService {

    @Autowired
    private UserRepo userRepo;

    @Autowired
    private ModelMapper modelMapper;


    @Override
    public UserDto createUser(UserDto userDto) {
        User user = this.userRepo.save(this.modelMapper.map(userDto, User.class));
        return this.modelMapper.map(user, UserDto.class);
    }

    @Override
    public UserDto updateUser(UserDto userDto, Long userId) {
        User user = this.userRepo.findById(userId).orElseThrow(()-> new ResourceNotFoundException("User", "Id", userId));
        user.setName(userDto.getName());
        user.setEmail(userDto.getEmail());
        user.setPassword(userDto.getPassword());
        user.setAbout(userDto.getAbout());
        return this.modelMapper.map(user, UserDto.class);
    }

    @Override
    public UserDto getUserById(Long userId) {
        User user = this.userRepo.findById(userId).orElseThrow(() -> new ResourceNotFoundException("User", "Id", userId));
        return this.modelMapper.map(user, UserDto.class);
    }

    @Override
    public List<UserDto> getAllUsers() {
        List<User> users = this.userRepo.findAll();
        return users.stream()
                .map(user -> this.modelMapper.map(user, UserDto.class))
                .toList();
    }

    @Override
    public void deleteUserById(Long userId) {
        User user = this.userRepo.findById(userId).orElseThrow(() -> new ResourceNotFoundException("User", "Id", userId));
        this.userRepo.delete(user);
    }
}
