package org.example.movieappbackend.services;

import org.example.movieappbackend.payloads.UserDto;

import java.util.List;

public interface UserService {
    UserDto createUser(UserDto userDto);

    UserDto updateUser(UserDto userDto, Long userId);

    UserDto getUserById(Long userId);

    List<UserDto> getAllUsers();

    void deleteUserById(Long userId);
}
